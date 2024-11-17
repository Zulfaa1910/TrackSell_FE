import 'package:flutter/material.dart';
import '../model/user_model.dart';

class Globals {
  static const String apiBaseUrl = 'http://192.168.200.34:8000/api'; // Adjust with your actual API URL
  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static UserModel? user;
  static String? token;

  // Function to show an error SnackBar
  static void errorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ));
  }
}
