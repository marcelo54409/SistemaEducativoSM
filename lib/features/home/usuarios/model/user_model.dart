class UserModel {
  final int id;
  final String email;
  final String businessName;
  final String name;
  final String jobTitle;
  final String phone;
  final String username;

  UserModel({
    required this.id,
    required this.email,
    required this.businessName,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.username,
  });

  // Método para convertir el modelo a un mapa (Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'businessName': businessName,
      'name': name,
      'jobTitle': jobTitle,
      'phone': phone,
      'username': username,
    };
  }

  // Método para crear una instancia del modelo desde un mapa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      businessName: map['businessName'],
      name: map['name'],
      jobTitle: map['jobTitle'],
      phone: map['phone'],
      username: map['username'],
    );
  }
}
