class PadreModel {
  final int idPadre;
  final String primerNombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String direccion;
  final String telefono;
  final String email;
  final String dni;
  final int idAlumno;
  final String ubicacion;

  PadreModel({
    this.idPadre = 0,
    this.primerNombre = "desconocido",
    this.apellidoPaterno = "N/A",
    this.apellidoMaterno = "N/A",
    this.direccion = "N/A",
    this.telefono = "N/A",
    this.email = "N/A",
    this.dni = "N/A",
    this.idAlumno = 0,
    this.ubicacion = "N/A",
  });

  // Método para convertir el modelo a un mapa (Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {
      'idPadre': idPadre,
      'primerNombre': primerNombre,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'dni': dni,
      'idAlumno': idAlumno,
      'ubicacion': ubicacion,
    };
  }

  // Método para crear una instancia del modelo desde un mapa
  factory PadreModel.fromMap(Map<String, dynamic> map) {
    return PadreModel(
      idPadre: map['idPadre'] ?? 0,
      primerNombre: map['primerNombre'] ?? "desconocido",
      apellidoPaterno: map['ApellidoPaterno'] ?? "N/A",
      apellidoMaterno: map['ApellidoMaterno'] ?? "N/A",
      direccion: map['direccion'] ?? "N/A",
      telefono: map['telefono'] ?? "N/A",
      email: map['email'] ?? "N/A",
      dni: map['dni'] ?? "N/A",
      idAlumno: map['idAlumno'] ?? 0,
      ubicacion: map['ubicacion'] ?? "N/A",
    );
  }
}
