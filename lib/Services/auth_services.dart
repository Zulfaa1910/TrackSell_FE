import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import './globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  // Helper function for making post requests
  static Future<http.Response> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${Globals.apiBaseUrl}$endpoint');
    try {
      final response = await http.post(
        url,
        headers: Globals.defaultHeaders,
        body: jsonEncode(body),
      );

      print('$endpoint response: ${response.body}');
      return response;
    } catch (e) {
      print('Error during $endpoint request: $e');
      rethrow;
    }
  }

  // Register User
  static Future<http.Response> register(Map<String, dynamic> userData) async {
    final response = await _postRequest('/auth/register', userData);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Globals.user = UserModel.fromJson(data['user']);
      Globals.token = data['token'];

      // Save token and user in shared preferences for future use
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', Globals.token ?? '');
      await prefs.setString('userId', Globals.user?.id ?? '');

      // Set authorization header globally
      Globals.defaultHeaders['Authorization'] = 'Bearer ${Globals.token}';
    } else {
      print('Register failed: ${response.body}');
    }

    return response;
  }

  // Login User
  static Future<http.Response> login(String email, String password) async {
    final response = await _postRequest('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Globals.user = UserModel.fromJson(data['user']);
      Globals.token = data['token'];

      // Save token and user in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', Globals.token ?? '');
      await prefs.setString('userId', Globals.user?.id ?? '');

      // Set authorization header globally
      Globals.defaultHeaders['Authorization'] = 'Bearer ${Globals.token}';
    } else {
      print('Login failed: ${response.body}');
    }

    return response;
  }

  // Verify Phone
  static Future<http.Response> verifyPhone(String phone, String code) async {
    final response = await _postRequest('/auth/verify-phone', {
      'phone': phone,
      'verification_code': code,
    });

    if (response.statusCode == 200) {
      Globals.user?.phoneVerifiedAt = DateTime.now();
    } else {
      print('Phone verification failed: ${response.body}');
    }

    return response;
  }

  // Log out the user (remove token and user data)
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userId');
    Globals.token = null;
    Globals.user = null;

    print('User logged out');
  }
}
