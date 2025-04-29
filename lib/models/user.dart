class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? address;
  final String? phone;
  final String theme;
  final String language;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.address,
    this.phone,
    this.theme = 'light',
    this.language = 'en',
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      address: data['address'],
      phone: data['phone'],
      theme: data['theme'] ?? 'light',
      language: data['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'address': address,
      'phone': phone,
      'theme': theme,
      'language': language,
    };
  }
}