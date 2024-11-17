import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menambahkan delay sebelum berpindah ke halaman login
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Pastikan file logo.png ada di folder assets
              height: 150, // Ukuran logo
            ),
            SizedBox(height: 20),
            Text(
              'TrackSell',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent[400], // Warna teks merah
                shadows: [
                  Shadow(
                    offset: Offset(3.0, 3.0), // Mengatur posisi bayangan
                    blurRadius: 3.0, // Mengatur kelembutan bayangan
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan dengan transparansi
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
