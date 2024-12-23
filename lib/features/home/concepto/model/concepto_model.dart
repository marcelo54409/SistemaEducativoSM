class ConceptoModel {
  final int idConcepto;
  final String concepto;
  final String descripcion;

  ConceptoModel({
    required this.idConcepto,
    required this.concepto,
    required this.descripcion,
  });

  factory ConceptoModel.fromJson(Map<String, dynamic> json) {
    return ConceptoModel(
      idConcepto: json['idConcepto'] ?? 0,
      concepto: json['concepto'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idConcepto': idConcepto,
      'concepto': concepto,
      'descripcion': descripcion,
    };
  }

  ConceptoModel copyWith({
    int? idConcepto,
    String? concepto,
    String? descripcion,
  }) {
    return ConceptoModel(
      idConcepto: idConcepto ?? this.idConcepto,
      concepto: concepto ?? this.concepto,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  @override
  String toString() =>
      'ConceptoModel(idConcepto: $idConcepto, concepto: $concepto, descripcion: $descripcion)';
}
