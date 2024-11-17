class Reseller {
  final int id;
  final String name;
  final String birthdate;
  final String gender;
  final String phone;
  final String address;
  final String? imagePath;  // Optional image path
  final double latitude;    // Required latitude
  final double longitude;   // Required longitude
  final int userId;         // Added userId

  // Constructor
  Reseller({
    required this.id,
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.phone,
    required this.address,
    this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.userId,  // Ensure userId is passed
  });

  // Factory method to create a Reseller from a JSON object
  factory Reseller.fromJson(Map<String, dynamic> json) {
    return Reseller(
      id: json['id'],
      name: json['name'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      imagePath: json['profile_photo'],  // Mapping to match the 'profile_photo' field from backend
      latitude: _parseDouble(json['latitude']),  // Convert to double if necessary
      longitude: _parseDouble(json['longitude']),  // Convert to double if necessary
      userId: json['user_id'],  // Ensure the user_id is correctly parsed
    );
  }

  // Helper function to safely parse latitude and longitude
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0; // Return a default value if null
    if (value is double) return value; // If already a double, return it
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Try to parse string to double, return 0.0 if invalid
    }
    return 0.0; // Default to 0.0 if the type is not double or string
  }

  // Method to convert a Reseller to a JSON object for sending to your backend
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthdate': birthdate,
      'gender': gender,
      'phone': phone,
      'address': address,
      'profile_photo': imagePath,  // Ensure you use the correct field name ('profile_photo' on backend)
      'latitude': latitude,
      'longitude': longitude,
      'user_id': userId,  // Include user_id when sending to backend
    };
  }
}
