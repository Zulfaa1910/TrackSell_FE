import 'dart:io';
import 'package:flutter/material.dart';
import '../Services/reseller_service.dart';
import '../model/reseller_model.dart';
import 'reseller_form_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResellerPage extends StatefulWidget {
  @override
  _ResellerPageState createState() => _ResellerPageState();
}

class _ResellerPageState extends State<ResellerPage> {
  List<Reseller> listReseller = [];
  ResellerService resellerService = ResellerService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Fetch reseller data
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Reseller> data = await resellerService.getData();
      setState(() {
        listReseller = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching resellers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Delete reseller data
  Future<void> deleteData(int id) async {
    try {
      final success = await resellerService.deleteData(id);
      if (success) {
        setState(() {
          listReseller.removeWhere((reseller) => reseller.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reseller deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reseller: $e')),
      );
    }
  }

  // Show edit reseller dialog
void showEditDialog(Reseller reseller) async {
  // Fetch the userId to be passed with the update
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fix here: Parse userId as int if stored as String
  int userId;
  try {
    userId = prefs.getInt('userId') ?? 0; // Default to 0 if not found
  } catch (e) {
    String? userIdString = prefs.getString('userId');
    userId = userIdString != null ? int.tryParse(userIdString) ?? 0 : 0;
  }

  TextEditingController nameController =
      TextEditingController(text: reseller.name);
  TextEditingController birthdateController =
      TextEditingController(text: reseller.birthdate);
  String selectedGender =
      reseller.gender == 'male' ? 'Laki-laki' : 'Perempuan';
  TextEditingController phoneController =
      TextEditingController(text: reseller.phone);
  TextEditingController addressController =
      TextEditingController(text: reseller.address);

    String? imagePath = reseller.imagePath;
    double? latitude = reseller.latitude;
    double? longitude = reseller.longitude;

    // Function to pick image
    Future<void> pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imagePath = image.path; // Update the image path
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Reseller'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  TextFormField(
                    controller: birthdateController,
                    decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        birthdateController.text =
                            "${picked.toLocal()}".split(' ')[0];
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                    items: ['Laki-laki', 'Perempuan']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedGender = value;
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Telepon'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Telepon wajib diisi'
                        : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Alamat'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Alamat wajib diisi'
                        : null,
                  ),
                  if (imagePath != null)
                    (imagePath?.startsWith('http') ?? false)
                        ? Image.network(imagePath!,
                            height: 100) // For URL image
                        : Image.file(File(imagePath!),
                            height: 100), // For local image
// For local image
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: pickImage, // Call the function to pick an image
                    child: Text('Pilih Gambar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Code to select location
                    },
                    child: Text('Pilih Lokasi'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    birthdateController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua field wajib diisi')),
                  );
                } else {
                  String genderValue =
                      selectedGender == 'Laki-laki' ? 'male' : 'female';
                  try {
                    bool success = await resellerService.updateData(
                      id: reseller.id,
                      name: nameController.text,
                      birthdate: birthdateController.text,
                      gender: genderValue,
                      phone: phoneController.text,
                      address: addressController.text,
                      imagePath: imagePath, // Send updated image path
                      latitude: latitude,
                      longitude: longitude,
                      userId: userId, // Pass the userId
                    );

                    if (success) {
                      await getData();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Reseller updated successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update reseller')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating reseller: $e')),
                    );
                  }
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Reseller'),
        backgroundColor: Colors.redAccent[400],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : listReseller.isEmpty
              ? Center(child: Text('Tidak ada data reseller'))
              : ListView.builder(
                  itemCount: listReseller.length,
                  itemBuilder: (context, index) {
                    final reseller = listReseller[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(reseller.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(height: 8),
                                  Text('Tanggal Lahir: ${reseller.birthdate}'),
                                  Text('Jenis Kelamin: ${reseller.gender}'),
                                  Text('Telepon: ${reseller.phone}'),
                                  Text('Alamat: ${reseller.address}'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: reseller.imagePath != null
                                  ? (reseller.imagePath!.startsWith('http'))
                                      ? Image.network(reseller.imagePath!,
                                          height: 100)
                                      : Image.file(File(reseller.imagePath!),
                                          height: 100)
                                  : Placeholder(fallbackHeight: 100),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                showEditDialog(reseller), // Edit reseller
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Hapus Reseller'),
                                  content: Text(
                                      'Apakah Anda yakin ingin menghapus reseller ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await deleteData(reseller.id);
                                      },
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResellerFormPage(
                onSubmit: (name, birthdate, gender, phone, address, imagePath,
                    latitude, longitude) async {
                  try {
                    // Fetch the userId for new reseller creation
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int userId = prefs.getInt('userId') ?? 0;

                    bool success = await resellerService.postData(
                      name: name,
                      birthdate: birthdate,
                      gender: gender,
                      phone: phone,
                      address: address,
                      imagePath: imagePath,
                      latitude: latitude ?? 0.0,
                      longitude: longitude ?? 0.0,
                      userId: userId,
                    );
                    if (success) {
                      await getData();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reseller added successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add reseller')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding reseller: $e')),
                    );
                  }
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.redAccent[400],
        child: Icon(Icons.add),
      ),
    );
  }
}