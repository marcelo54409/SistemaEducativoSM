class PagoModel {
  final int idPago;
  final int idPadre;
  final int idAlumno;
  final int idDeuda;
  final String fechaPago;
  final String estadoPago;

  PagoModel({
    required this.idPago,
    required this.idPadre,
    required this.idAlumno,
    required this.idDeuda,
    required this.fechaPago,
    required this.estadoPago,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      idPago: json['idPago'] ?? 0,
      idPadre: json['idPadre'] ?? 0,
      idAlumno: json['idAlumno'] ?? 0,
      idDeuda: json['idDeuda'] ?? 0,
      fechaPago: json['fechaPago'] ?? '',
      estadoPago: json['estadoPago'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPago': idPago,
      'idPadre': idPadre,
      'idAlumno': idAlumno,
      'idDeuda': idDeuda,
      'fechaPago': fechaPago,
      'estadoPago': estadoPago,
    };
  }
}
