class UserProfile {
  final String alamat;
  final String nomorTelepon;
  final String jenisKelamin;
  final String tanggalLahir;
  final String? foto;
  final double? latitude;
  final double? longitude;

  UserProfile({
    required this.alamat,
    required this.nomorTelepon,
    required this.jenisKelamin,
    required this.tanggalLahir,
    this.foto,
    this.latitude,
    this.longitude,
  });

  // Factory constructor to create a UserProfile from a map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Check if required fields are missing
    if (json['alamat'] == null || json['nomor_telepon'] == null || json['jenis_kelamin'] == null || json['tanggal_lahir'] == null) {
      throw Exception('Missing required user profile fields');
    }

    return UserProfile(
      alamat: json['alamat'],
      nomorTelepon: json['nomor_telepon'],
      jenisKelamin: json['jenis_kelamin'],
      tanggalLahir: json['tanggal_lahir'],
      foto: json['foto'],
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null,
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null,
    );
  }
}
