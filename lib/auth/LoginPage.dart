import 'dart:convert';
import 'package:flutter/material.dart';
import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../model/user_model.dart'; // Adjust the path as necessary

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // Using Future synchronously with .then(), avoid async/await here
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your username and password')),
      );
      return;
    }

    // Call AuthServices.login and handle response with .then() and .catchError()
    AuthServices.login(username, password).then((response) {
      print('Raw response: ${response.body}'); // Print the raw response
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Assuming 'user' is the key for user object
        Globals.user = UserModel.fromJson(responseBody['user']);
        Globals.token = responseBody['token'].toString(); // Convert token to String if necessary

        // Show the success dialog first
        _showSuccessDialog().then((_) {
          // After the dialog is dismissed, navigate to the dashboard
          Navigator.pushReplacementNamed(context, '/sales-dashboard');
        });
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'] ?? 'Unknown error';
        Globals.errorSnackBar(context, errorMessage); // Show error message
      }
    }).catchError((error) {
      print('Error during login: $error');
      Globals.errorSnackBar(context, 'Login failed: $error');
    });
  }

  // Method to show a simplified success dialog
  Future<void> _showSuccessDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Successful'),
          content: Text('You have successfully logged in. Welcome back!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Continue'),
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
                  'Hello Again!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent[400],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username/Email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                      activeColor: Colors.redAccent[400],
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(color: Colors.redAccent[400]),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.redAccent[400]),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login, // Call _login without async/await
                  child: Text('Sign In'),
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
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(color: Colors.redAccent[400]),
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
