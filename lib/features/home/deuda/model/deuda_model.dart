class DeudaModel {
  final int idDeuda;
  final int idAlumno;
  final int idAsignarEscala;
  final int idAsignarConcepto;
  final String fecha;
  String? nombreAlumno; // Nuevo campo

  DeudaModel(
      {required this.idDeuda,
      required this.idAlumno,
      required this.idAsignarEscala,
      required this.idAsignarConcepto,
      required this.fecha,
      this.nombreAlumno});

  factory DeudaModel.fromJson(Map<String, dynamic> json) {
    return DeudaModel(
      idDeuda: json['idDeuda'] ?? 0,
      idAlumno: json['idAlumno'] ?? 0,
      idAsignarEscala: json['idAsignarEscala'] ?? 0,
      idAsignarConcepto: json['idAsignar_Concepto'] ?? 0,
      fecha: json['fecha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDeuda': idDeuda,
      'idAlumno': idAlumno,
      'idAsignarEscala': idAsignarEscala,
      'idAsignar_Concepto': idAsignarConcepto,
      'fecha': fecha,
    };
  }

  @override
  String toString() {
    return 'DeudaModel{idDeuda: $idDeuda, idAlumno: $idAlumno, idAsignarEscala: $idAsignarEscala, idAsignarConcepto: $idAsignarConcepto, fecha: $fecha, nombreAlumno: $nombreAlumno}';
  }
}
