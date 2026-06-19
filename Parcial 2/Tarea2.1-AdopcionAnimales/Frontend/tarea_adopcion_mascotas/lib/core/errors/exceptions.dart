
class SolicitudInvalidaException implements Exception {
  final String message;
  const SolicitudInvalidaException(this.message);

  @override
  String toString() => message;
}