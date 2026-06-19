class CorreoModel {
  final String id;
  final String remitente;
  final String asunto;
  final String cuerpo;
  bool leido;
  final DateTime fecha;

  CorreoModel({
    required this.id,
    required this.remitente,
    required this.asunto,
    required this.cuerpo,
    this.leido = false,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}
