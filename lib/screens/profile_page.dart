import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Import package intl untuk formatting tanggal
import '../Services/globals.dart'; // Import globals to access user data

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _profileImage = null;
    });
  }

  void _saveProfile() {
    print("Data profil berhasil disimpan.");
  }

  Future<void> _editField(String field, String initialValue, Function(String) onSave) async {
    final TextEditingController controller = TextEditingController(text: initialValue);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: field),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Simpan"),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Globals.user;

    // Format tanggal lahir, pastikan user?.birthdate dalam format DateTime atau String yang bisa diparse
    String formattedDate = '';
    if (user?.birthdate != null) {
      try {
        // Jika birthdate dalam format DateTime
        DateTime birthdate = DateTime.parse(user!.birthdate); // Parse jika birthdate dalam format string
        formattedDate = DateFormat('dd MMM yyyy').format(birthdate); // Contoh format: 01 Jan 2023
      } catch (e) {
        // Jika birthdate sudah string, gunakan secara langsung
        formattedDate = user?.birthdate ?? "Tanggal Lahir tidak tersedia";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        backgroundColor: Colors.redAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                  child: _profileImage == null
                      ? Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: _profileImage != null
                  ? TextButton(
                      onPressed: _deleteImage,
                      child: Text('Hapus Foto', style: TextStyle(color: Colors.redAccent)),
                    )
                  : Container(),
            ),

            // Informasi profil
            ListTile(
              title: Text("Nama"),
              subtitle: Text(user?.name ?? "Nama tidak tersedia"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Nama", user?.name ?? "", (value) {
                  setState(() {
                    user?.name = value;
                  });
                }),
              ),
            ),
            ListTile(
              title: Text("Email"),
              subtitle: Text(user?.email ?? "Email tidak tersedia"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Email", user?.email ?? "", (value) {
                  setState(() {
                    user?.email = value;
                  });
                }),
              ),
            ),
            ListTile(
              title: Text("Jenis Kelamin"),
              subtitle: Text(user?.gender ?? "Jenis Kelamin tidak tersedia"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Jenis Kelamin", user?.gender ?? "", (value) {
                  setState(() {
                    user?.gender = value;
                  });
                }),
              ),
            ),
            ListTile(
              title: Text("Tanggal Lahir"),
              subtitle: Text(formattedDate),  // Menampilkan tanggal yang sudah diformat
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Tanggal Lahir", user?.birthdate ?? "", (value) {
                  setState(() {
                    user?.birthdate = value;
                  });
                }),
              ),
            ),
            ListTile(
              title: Text("Alamat"),
              subtitle: Text(user?.address ?? "Alamat tidak tersedia"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Alamat", user?.address ?? "", (value) {
                  setState(() {
                    user?.address = value;
                  });
                }),
              ),
            ),
            ListTile(
              title: Text("Nomor Telepon"),
              subtitle: Text(user?.phone ?? "Nomor Telepon tidak tersedia"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField("Nomor Telepon", user?.phone ?? "", (value) {
                  setState(() {
                    user?.phone = value;
                  });
                }),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent[400]),
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
