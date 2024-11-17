import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Warna ikon kembali (back) hitam
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black), // Warna teks hitam
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menambahkan ikon besar di atas teks
            Icon(
              Icons.mail_outline,
              size: 100, // Ukuran ikon besar
              color: Colors.redAccent[400], // Warna ikon merah diganti dengan Colors.redAccent[400]
            ),
            SizedBox(height: 20),
            Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600], // Warna teks abu-abu lembut
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.grey[600], // Warna ikon email abu-abu
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[600]), // Warna label abu-abu
                filled: true,
                fillColor: Colors.grey[200], // Warna latar belakang field abu-abu muda
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent[400]!, width: 2.0), // Border saat fokus merah diganti
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(color: Colors.black), // Warna teks hitam
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _sendPasswordResetEmail();
              },
              child: Text('Send Reset Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[400], // Warna latar belakang tombol merah diganti
                foregroundColor: Colors.white, // Warna teks tombol putih
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 20), // Warna teks tombol putih
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

  void _sendPasswordResetEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      // Implementasikan logika untuk mengirim email reset password
      // Misalnya, memanggil API untuk mengirim email reset password

      // Menampilkan pop-up di atas halaman menggunakan Overlay
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Password Reset Link Sent',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'A password reset link has been sent to $email. Please check your inbox.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Menutup pop-up
                        Navigator.pushReplacementNamed(context, '/login'); // Navigasi kembali ke halaman login
                      },
                      child: Text('OK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Warna latar belakang tombol putih
                        foregroundColor: Colors.redAccent[400]!, // Warna teks tombol merah diganti
                        side: BorderSide(color: Colors.redAccent[400]!, width: 2.0), // Border tombol merah diganti
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        textStyle: TextStyle(fontSize: 16, color: Colors.redAccent[400]!), // Warna teks tombol merah diganti
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Menambahkan pop-up ke Overlay
      Overlay.of(context).insert(overlayEntry);

      // Menghapus pop-up setelah beberapa detik
      Future.delayed(Duration(seconds: 3), () {
        overlayEntry.remove();
      });
    } else {
      // Jika email kosong, beri tahu pengguna untuk mengisi email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email'),
        ),
      );
    }
  }
}
