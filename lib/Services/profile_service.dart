// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/UserProfile.dart'; // Update with actual path
// import 'globals.dart'; // Import the file with baseURL and headers

// class ProfileService {
//   static Future<UserProfile> getProfile() async {
//     try {
//       final response = await http.get(
//         Uri.parse('${baseURL}profile'),
//         headers: {
//           ...headers,
//           'Authorization': 'Bearer your_access_token', // Replace with actual token
//         },
//       );

//       if (response.statusCode == 200) {
//         return UserProfile.fromJson(json.decode(response.body));
//       } else {
//         throw Exception('Failed to load profile');
//       }
//     } catch (e) {
//       throw Exception('Failed to load profile: ${e.toString()}');
//     }
//   }

//   static Future<void> updateProfile(UserProfile profile) async {
//     try {
//       var request = http.MultipartRequest('PUT', Uri.parse('${baseURL}profile'));
//       request.headers.addAll({
//         ...headers,
//         'Authorization': 'Bearer your_access_token', // Replace with actual token
//       });

//       request.fields['alamat'] = profile.alamat ?? '';
//       request.fields['nomor_telepon'] = profile.nomorTelepon ?? '';
//       request.fields['jenis_kelamin'] = profile.jenisKelamin ?? '';
//       request.fields['tanggal_lahir'] = profile.tanggalLahir ?? '';
//       request.fields['latitude'] = profile.latitude?.toString() ?? '';
//       request.fields['longitude'] = profile.longitude?.toString() ?? '';

//       if (profile.foto != null) {
//         request.files.add(await http.MultipartFile.fromPath('foto', profile.foto!));
//       }

//       final response = await request.send();

//       if (response.statusCode != 200) {
//         throw Exception('Failed to update profile');
//       }
//     } catch (e) {
//       throw Exception('Failed to update profile: ${e.toString()}');
//     }
//   }

//   static Future<void> deleteProfile() async {
//     try {
//       final response = await http.delete(
//         Uri.parse('${baseURL}profile'),
//         headers: {
//           ...headers,
//           'Authorization': 'Bearer your_access_token', // Replace with actual token
//         },
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete profile');
//       }
//     } catch (e) {
//       throw Exception('Failed to delete profile: ${e.toString()}');
//     }
//   }
// }
