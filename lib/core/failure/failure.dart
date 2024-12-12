class Failure {
  final String message;

  Failure([this.message = "Ha ocurrido un error!"]);

  @override
  String toString() => message;
}
