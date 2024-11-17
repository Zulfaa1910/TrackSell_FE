import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Services/auth_services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'VerifyPhonePage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'male';
  String _deviceBrand = '';
  String _uniqueCode = ''; // Untuk menyimpan Android ID
  bool _isPasswordVisible = false; // Untuk mengatur visibilitas password

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _deviceBrand = androidInfo.model;
        _uniqueCode = androidInfo.id; // Menggunakan androidInfo.id
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceBrand = iosInfo.model;
      });
    }
  }

  Future<void> registerUser() async {
    try {
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'birthdate': _birthdateController.text,
        'gender': _gender,
        'address': _addressController.text,
        'merk_hp': _deviceBrand,
        'kode_unik': _uniqueCode, // Menggunakan _uniqueCode dari androidInfo.id
        'kode_sales': 'SALES_CODE',
      };

      final response = await AuthServices.register(userData);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User created: ${data['user']}');
        print('Token: ${data['token']}');

        // Setelah registrasi berhasil, alihkan ke halaman verifikasi nomor telepon
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyPhonePage()),
        );
      } else {
        _showErrorSnackBar('Registration failed: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _register() {
    if (_validateInputs()) {
      registerUser();
    } else {
      _showErrorSnackBar("Please fill all fields correctly");
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _birthdateController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;
  }

  void _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _birthdateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Fungsi untuk menampilkan snackbar dengan pesan error
  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent[400],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Join us and explore the app!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildTextField(_nameController, 'Name', Icons.person),
                          SizedBox(height: 20),
                          _buildTextField(_emailController, 'Email', Icons.email),
                          SizedBox(height: 20),
                          _buildPasswordField(),
                          SizedBox(height: 20),
                          _buildTextField(_phoneController, 'Phone', Icons.phone),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => _selectBirthDate(context),
                            child: AbsorbPointer(
                              child: _buildTextField(
                                _birthdateController,
                                'Birthdate',
                                Icons.calendar_today,
                                obscureText: false,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildGenderSelection(),
                          SizedBox(height: 20),
                          _buildTextField(_addressController, 'Address', Icons.location_on),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to login page
                  },
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(color: Colors.redAccent[400]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
      ),
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
    );
  }

  // New method to build the password field with visibility toggle
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
            });
          },
        ),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Male'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'other',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Other'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
