class FotoModelo {
  final String imagenPath;
  final double latitud;
  final double longitud;
  final DateTime timestamp;

  const FotoModelo({
    required this.imagenPath,
    required this.latitud,
    required this.longitud,
    required this.timestamp,
  });

  String get urlMaps =>
      'https://maps.google.com/?q=${latitud.toStringAsFixed(6)},${longitud.toStringAsFixed(6)}';

  String get coordenadasTexto =>
      '${latitud.toStringAsFixed(6)}, ${longitud.toStringAsFixed(6)}';

  String get fechaTexto {
    final d = timestamp;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
