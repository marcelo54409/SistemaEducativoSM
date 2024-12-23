class EscalasModel {
  final int idEscala;
  final String escala;
  final String descripcion;
  final double monto;

  EscalasModel({
    required this.idEscala,
    required this.escala,
    required this.descripcion,
    required this.monto,
  });

  factory EscalasModel.fromJson(Map<String, dynamic> json) {
    return EscalasModel(
      idEscala: json['idEscala'] ?? 0,
      escala: json['escala'] ?? '',
      descripcion: json['descripcion'] ?? '',
      monto: double.parse(json['monto'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEscala': idEscala,
      'escala': escala,
      'descripcion': descripcion,
      'monto': monto,
    };
  }

  EscalasModel copyWith({
    int? idEscala,
    String? escala,
    String? descripcion,
    double? monto,
  }) {
    return EscalasModel(
      idEscala: idEscala ?? this.idEscala,
      escala: escala ?? this.escala,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
    );
  }

  @override
  String toString() =>
      'EscalasModel(idEscala: $idEscala, escala: $escala, descripcion: $descripcion, monto: $monto)';
}
