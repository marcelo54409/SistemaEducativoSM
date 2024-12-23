class CondonacionModel {
  final int idCondonacion;
  final int idDeuda;
  final String fecha;

  CondonacionModel({
    required this.idCondonacion,
    required this.idDeuda,
    required this.fecha,
  });

  factory CondonacionModel.fromJson(Map<String, dynamic> json) {
    return CondonacionModel(
      idCondonacion: json['idCondonacion'] ?? 0,
      idDeuda: json['idDeuda'] ?? 0,
      fecha: json['fecha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCondonacion': idCondonacion,
      'idDeuda': idDeuda,
      'fecha': fecha,
    };
  }
}
