import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/reseller_model.dart';  // Import model Reseller

class ResellerService {
  final String _baseUrl = 'http://192.168.200.34:8000/api/resellers';

  // Fetch list of resellers
  Future<List<Reseller>> getData() async {
    try {
      final token = await _getAuthToken();  // Get the auth token

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        return responseBody.map((json) => Reseller.fromJson(json)).toList();
      } else {
        _logError(response);  // Log response in case of failure
        throw Exception('Failed to load resellers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching resellers: $e');
    }
  }

  // Save user ID in SharedPreferences
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');  // Assumes you store the auth token
  }

  // Helper function to create the headers with the token
  Map<String, String> _getHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',  // Include the Bearer token
      'Content-Type': 'application/json',
    };
  }

  // Log error response for debugging
  void _logError(http.Response response) {
    print('Error: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  // Post new reseller data
  Future<bool> postData({
    required String name,
    required String birthdate,
    required String gender,
    required String phone,
    required String address,
    String? imagePath,
    required double latitude,
    required double longitude,
    required int userId, // Add the userId parameter
  }) async {
    try {
      final token = await _getAuthToken();  // Get the auth token

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(token),
        body: jsonEncode({
          'name': name,
          'birthdate': birthdate,
          'gender': gender,
          'phone': phone,
          'address': address,
          'profile_photo': imagePath, // Use 'profile_photo' instead of 'imagePath'
          'latitude': latitude,
          'longitude': longitude,
          'user_id': userId,  // Include userId to associate with logged-in user
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        _logError(response);  // Log response in case of failure
        throw Exception('Failed to create reseller. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating reseller: $e');
    }
  }

  // Update existing reseller data
  Future<bool> updateData({
    required int id,
    required String name,
    required String birthdate,
    required String gender,
    required String phone,
    required String address,
    String? imagePath,
    required double latitude,
    required double longitude,
    required int userId, // Add the userId parameter
  }) async {
    try {
      final token = await _getAuthToken();  // Get the auth token

      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: _getHeaders(token),
        body: jsonEncode({
          'name': name,
          'birthdate': birthdate,
          'gender': gender,
          'phone': phone,
          'address': address,
          'profile_photo': imagePath,  // Use 'profile_photo' instead of 'imagePath'
          'latitude': latitude,
          'longitude': longitude,
          'user_id': userId,  // Include userId to associate with logged-in user
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _logError(response);  // Log response in case of failure
        throw Exception('Failed to update reseller. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating reseller: $e');
    }
  }

  // Delete reseller by ID
  Future<bool> deleteData(int id) async {
    try {
      final token = await _getAuthToken();  // Get the auth token

      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _logError(response);  // Log response in case of failure
        throw Exception('Failed to delete reseller. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting reseller: $e');
    }
  }
}
