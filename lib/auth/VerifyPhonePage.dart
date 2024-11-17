import 'dart:convert';
import 'package:flutter/material.dart';
import '../Services/auth_services.dart'; // Ganti dengan nama file service Anda

class VerifyPhonePage extends StatefulWidget {
  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  Future<void> _verifyPhone() async {
    final phone = _phoneController.text.trim();
    final verificationCode = _verificationCodeController.text.trim();

    if (phone.isEmpty || verificationCode.isEmpty) {
      _showDialog('Error', 'Please fill all fields');
    } else {
      final response = await AuthServices.verifyPhone(phone, verificationCode);
      if (response.statusCode == 200) {
        _showDialog('Success', 'Phone verified successfully', onSuccess: () {
          Navigator.pushReplacementNamed(context, '/login'); // Navigasi ke halaman login
        });
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'] ?? 'Unknown error';
        _showDialog('Error', errorMessage);
      }
    }
  }

  void _showDialog(String title, String content, {Function? onSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (onSuccess != null) onSuccess();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Verify Phone',
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent[400],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter the verification code sent to your phone.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.phone, color: Colors.grey[600]),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey[600]),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyPhone,
                  child: Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: screenWidth * 0.05),
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
    );
  }
}
