class UserModel {
  String id;
  String email;
  String phone;
  String name; // Name of the user
  String gender; // Gender of the user
  String birthdate; // Birthdate of the user
  String address; // Address of the user
  DateTime? phoneVerifiedAt; // Optional, for verified phone date
  String kodeUnik; // Added unique code
  String kodeSales; // Added sales code
  String merkHp; // Added phone brand info

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.gender,
    required this.birthdate,
    required this.address,
    this.phoneVerifiedAt,
    required this.kodeUnik,  // Required field for kode unik
    required this.kodeSales, // Required field for kode sales
    required this.merkHp,    // Required field for phone brand
  });

  // Factory constructor to create a UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(), // Convert id to string
      email: json['email'],
      phone: json['phone'].toString(), // Convert phone to string if needed
      name: json['name'], // Get name from JSON
      gender: json['gender'], // Get gender from JSON
      birthdate: json['birthdate'], // Get birthdate from JSON
      address: json['address'], // Get address from JSON
      phoneVerifiedAt: json['phone_verified_at'] != null 
          ? DateTime.parse(json['phone_verified_at']) 
          : null, // Parse phone verified at if not null
      kodeUnik: json['kode_unik'],  // Get kode unik from JSON
      kodeSales: json['kode_sales'], // Get kode sales from JSON
      merkHp: json['merk_hp'],      // Get phone brand info from JSON
    );
  }

  // Method to convert UserModel instance back to JSON (optional if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
      'address': address,
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'kode_unik': kodeUnik,
      'kode_sales': kodeSales,
      'merk_hp': merkHp,
    };
  }
}
