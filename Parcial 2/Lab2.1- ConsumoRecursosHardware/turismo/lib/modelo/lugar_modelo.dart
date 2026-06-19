class LugarModelo {
  final String nombre;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String categoria;
  final String emoji;
  double? distanciaKm;

  LugarModelo({
    required this.nombre,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.categoria,
    required this.emoji,
    this.distanciaKm,
  });

  String get distanciaTexto {
    if (distanciaKm == null) return 'Calculando...';
    if (distanciaKm! < 1.0) return '${(distanciaKm! * 1000).toStringAsFixed(0)} m';
    return '${distanciaKm!.toStringAsFixed(1)} km';
  }

  String get urlMaps =>
      'https://maps.google.com/?q=${latitud.toStringAsFixed(6)},${longitud.toStringAsFixed(6)}';
}
