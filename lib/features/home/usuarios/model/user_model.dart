class UserModel {
  final int id;
  final String username;
  final String email;
  final int? roleId; // Puede ser null
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para convertir el modelo a un mapa (Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roleId': roleId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Método para crear una instancia del modelo desde un mapa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      roleId: map['roleId'], // Puede ser null
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
