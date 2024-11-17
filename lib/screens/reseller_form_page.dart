import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../model/reseller_model.dart';
import '../Services/reseller_service.dart'; // Import service untuk menyimpan data

class ResellerFormPage extends StatefulWidget {
  final Reseller? reseller;
  final Function(String, String, String, String, String, String?, double?, double?) onSubmit;
  final bool showAppBar;

  ResellerFormPage({
    this.reseller,
    required this.onSubmit,
    this.showAppBar = true,
  });

  @override
  _ResellerFormPageState createState() => _ResellerFormPageState();
}

class _ResellerFormPageState extends State<ResellerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthdateController;
  String _selectedGender = 'Laki-laki';
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  XFile? _profileImage; // Untuk foto profil
  LatLng _currentLocation = LatLng(-6.200000, 106.816666); // Lokasi default Jakarta
  Set<Marker> _markers = {}; // Set untuk menyimpan marker
  GoogleMapController? _mapController;
  bool _isMapInitialized = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reseller?.name ?? '');
    _birthdateController = TextEditingController(text: widget.reseller?.birthdate ?? '');
    _selectedGender = widget.reseller?.gender == 'male' ? 'Laki-laki' : 'Perempuan';
    _phoneController = TextEditingController(text: widget.reseller?.phone ?? '');
    _addressController = TextEditingController(text: widget.reseller?.address ?? '');
    _setInitialLocation(); // Dapatkan lokasi awal saat dimuat
  }

  // Fungsi untuk mendapatkan lokasi saat ini dari pengguna
  Future<void> _setInitialLocation() async {
    Position position = await _getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isMapInitialized = true;
      _markers.add(Marker(markerId: MarkerId('currentLocation'), position: _currentLocation));
    });
  }

  // Fungsi untuk mendapatkan posisi saat ini
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi dinonaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak secara permanen.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Fungsi untuk menangani pembuatan peta
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentLocation, zoom: 14),
    ));
  }

  // Fungsi untuk memilih gambar dari kamera untuk foto profil
  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Sesuaikan kualitas gambar
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile; // Tetapkan ke foto profil
        });
      }
    } catch (e) {
      print('Gagal memilih gambar: $e');
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile; // Tetapkan ke foto profil
        });
      }
    } catch (e) {
      print('Gagal memilih gambar: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (DateTime.now().difference(picked).inDays < 17 * 365) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usia minimal 17 tahun')),
        );
      } else {
        _birthdateController.text = "${picked.toLocal()}".split(' ')[0];
      }
    }
  }

  // Fungsi untuk menangani pengiriman data
  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ambil data dari form
        String name = _nameController.text;
        String birthdate = _birthdateController.text;
        String gender = _selectedGender;
        String phone = _phoneController.text;
        String address = _addressController.text;
        String? profileImagePath = _profileImage?.path;
        double latitude = _currentLocation.latitude;
        double longitude = _currentLocation.longitude;

        // Kirim data menggunakan service Reseller
        bool success;
        if (widget.reseller == null) {
          // Jika reseller baru, buat baru
          success = await ResellerService().postData(
            name: name,
            birthdate: birthdate,
            gender: gender == 'Laki-laki' ? 'male' : 'female',
            phone: phone,
            address: address,
            imagePath: profileImagePath,
            latitude: latitude,
            longitude: longitude,
            userId: 1, // Gantilah ini dengan ID user yang sesuai
          );
        } else {
          // Jika reseller sudah ada, lakukan update
          success = await ResellerService().updateData(
            id: widget.reseller!.id,
            name: name,
            birthdate: birthdate,
            gender: gender == 'Laki-laki' ? 'male' : 'female',
            phone: phone,
            address: address,
            imagePath: profileImagePath,
            latitude: latitude,
            longitude: longitude,
            userId: 1, // Gantilah ini dengan ID user yang sesuai
          );
        }

        if (success) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan saat menyimpan data')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat menyimpan data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.reseller == null ? 'Tambah Reseller' : 'Edit Reseller'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Reseller',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Nama', _nameController),
                  SizedBox(height: 10),
                  _buildBirthdateField(context),
                  SizedBox(height: 10),
                  _buildGenderDropdown(),
                  SizedBox(height: 10),
                  _buildTextField('Telepon', _phoneController),
                  SizedBox(height: 10),
                  _buildTextField('Alamat', _addressController),
                  SizedBox(height: 20),

                  // Tombol Unggah Foto Profil
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImageSource? source = await showDialog<ImageSource>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Pilih Sumber Gambar'),
                            content: Text('Pilih sumber gambar untuk foto profil'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, ImageSource.camera),
                                child: Text('Kamera'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                                child: Text('Galeri'),
                              ),
                            ],
                          );
                        },
                      );

                      if (source != null) {
                        final pickedFile = await _picker.pickImage(
                          source: source,
                          imageQuality: 80,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _profileImage = pickedFile;
                          });
                        }
                      }
                    },
                    icon: Icon(Icons.photo_camera),
                    label: Text('Unggah Foto Profil'),
                  ),
                  SizedBox(height: 20),

                  // Peta Lokasi
                  if (_isMapInitialized)
                    Container(
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation,
                          zoom: 14,
                        ),
                        markers: _markers,
                      ),
                    ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Harap isi $label';
        }
        return null;
      },
    );
  }

  Widget _buildBirthdateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectBirthdate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _birthdateController,
          decoration: InputDecoration(
            labelText: 'Tanggal Lahir',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap isi Tanggal Lahir';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: [
        DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
        DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Jenis Kelamin',
        border: OutlineInputBorder(),
      ),
    );
  }
}
