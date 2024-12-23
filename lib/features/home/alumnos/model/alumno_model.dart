class AlumnoModelo {
  final int id;
  final String primerNombre;
  final String otrosNombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final int anio;
  final String seccion;
  final String periodo;
  final String estado;
  final String imagenPerfil;

  AlumnoModelo({
    required this.id,
    required this.primerNombre,
    required this.otrosNombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.anio,
    required this.seccion,
    required this.periodo,
    required this.estado,
    required this.imagenPerfil,
  });

  // Factory constructor para crear una instancia desde un mapa JSON
  factory AlumnoModelo.fromJson(Map<String, dynamic> json) {
    return AlumnoModelo(
      id: json['idAlumno'] ?? 0,
      primerNombre: json['primerNombre'] ?? '',
      otrosNombres: json['otrosNombres'] ?? '',
      apellidoPaterno: json['ApellidoPaterno'] ?? '',
      apellidoMaterno: json['ApellidoMaterno'] ?? '',
      anio: json['anio'] ?? 0,
      seccion: json['seccion'] ?? '',
      periodo: json['periodo'] ?? '',
      estado: json['estado'] ?? '',
      imagenPerfil: json['imagen_perfil'] ?? '',
    );
  }

  // Método para convertir una instancia a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'idAlumno': id,
      'primerNombre': primerNombre,
      'otrosNombres': otrosNombres,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      'anio': anio,
      'seccion': seccion,
      'periodo': periodo,
      'estado': estado,
      'imagen_perfil': imagenPerfil,
    };
  }
}
