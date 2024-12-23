class AsignarConceptoModel {
  final int idAsignarConcepto;
  final int idEscala;
  final int idConcepto;

  AsignarConceptoModel({
    required this.idAsignarConcepto,
    required this.idEscala,
    required this.idConcepto,
  });

  // Método para convertir el modelo a un mapa (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'idAsignar_Concepto': idAsignarConcepto,
      'idEscala': idEscala,
      'idConcepto': idConcepto,
    };
  }

  // Método para crear una instancia del modelo desde un mapa
  factory AsignarConceptoModel.fromJson(Map<String, dynamic> map) {
    return AsignarConceptoModel(
      idAsignarConcepto: map['idAsignar_Concepto'],
      idEscala: map['idEscala'],
      idConcepto: map['idConcepto'],
    );
  }
}
