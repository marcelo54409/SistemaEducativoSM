class AsigEscalaModel {
  final int idAsignarEscala;
  final int idAlumno;
  final int idEscala;
  final String fechaAsignacion;

  AsigEscalaModel({
    required this.idAsignarEscala,
    required this.idAlumno,
    required this.idEscala,
    required this.fechaAsignacion,
  });

  // Método para convertir el modelo a un mapa (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'idAsignarEscala': idAsignarEscala,
      'idAlumno': idAlumno,
      'idEscala': idEscala,
      'fechaAsignacion': fechaAsignacion,
    };
  }

  // Método para crear una instancia del modelo desde un mapa
  factory AsigEscalaModel.fromJson(Map<String, dynamic> map) {
    return AsigEscalaModel(
      idAsignarEscala: map['idAsignarEscala'],
      idAlumno: map['idAlumno'],
      idEscala: map['idEscala'],
      fechaAsignacion: map['fechaAsignacion'],
    );
  }
}
