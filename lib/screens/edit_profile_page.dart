import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String alamat;
  final String nomorTelepon;
  final Function(String, String) onProfileUpdated;

  EditProfilePage({
    required this.alamat,
    required this.nomorTelepon,
    required this.onProfileUpdated,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _alamatController;
  late TextEditingController _nomorTeleponController;

  @override
  void initState() {
    super.initState();
    _alamatController = TextEditingController(text: widget.alamat);
    _nomorTeleponController = TextEditingController(text: widget.nomorTelepon);
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _nomorTeleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.redAccent[400],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nomorTeleponController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update profil dengan data baru
                widget.onProfileUpdated(
                  _alamatController.text,
                  _nomorTeleponController.text,
                );
                Navigator.pop(context); // Kembali ke halaman profil
              },
              child: const Text('Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: screenWidth * 0.045),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
