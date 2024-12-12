class Role {
  final int roleId;
  final String code;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  Role({
    required this.roleId,
    required this.code,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'code': code,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
