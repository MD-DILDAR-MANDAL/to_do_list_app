class AppUser {
  final String id;
  final String name;
  final String email;

  AppUser({required this.id, required this.name, required this.email});

  factory AppUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return AppUser(
      id: documentId,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'email': email};
  }
}
