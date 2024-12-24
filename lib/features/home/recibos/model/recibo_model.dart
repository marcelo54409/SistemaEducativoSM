class ReciboModel {
  final int idRecibo;
  final int idAlumno;
  final int idDeuda;
  final String formaPago;
  final String nOperacion;
  final String fechaEmision;
  final String importe;

  ReciboModel({
    required this.idRecibo,
    required this.idAlumno,
    required this.idDeuda,
    required this.formaPago,
    required this.nOperacion,
    required this.fechaEmision,
    required this.importe,
  });

  factory ReciboModel.fromJson(Map<String, dynamic> json) {
    return ReciboModel(
      idRecibo: json['idRecibo'] ?? 0,
      idAlumno: json['idAlumno'] ?? 0,
      idDeuda: json['idDeuda'] ?? 0,
      formaPago: json['formaPago'] ?? '',
      nOperacion: json['nOperacion'] ?? '',
      fechaEmision: json['fechaEmision'] ?? '',
      importe: json['importe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRecibo': idRecibo,
      'idAlumno': idAlumno,
      'idDeuda': idDeuda,
      'formaPago': formaPago,
      'nOperacion': nOperacion,
      'fechaEmision': fechaEmision,
      'importe': importe,
    };
  }

  @override
  String toString() {
    return 'ReciboModel(idRecibo: $idRecibo, idAlumno: $idAlumno, idDeuda: $idDeuda, formaPago: $formaPago, nOperacion: $nOperacion, fechaEmision: $fechaEmision, importe: $importe)';
  }
}
