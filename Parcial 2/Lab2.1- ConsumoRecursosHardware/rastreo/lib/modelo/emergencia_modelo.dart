class EmergenciaModelo {
  final double? latitud;
  final double? longitud;
  final String? imagenPath;
  final DateTime? timestamp;

  const EmergenciaModelo({
    this.latitud,
    this.longitud,
    this.imagenPath,
    this.timestamp,
  });

  bool get tieneUbicacion => latitud != null && longitud != null;
  bool get tieneFoto => imagenPath != null;

  String get latitudTexto =>
      latitud != null ? latitud!.toStringAsFixed(6) : 'Sin datos';

  String get longitudTexto =>
      longitud != null ? longitud!.toStringAsFixed(6) : 'Sin datos';

  String get urlMaps => tieneUbicacion
      ? 'https://maps.google.com/?q=${latitud!.toStringAsFixed(6)},${longitud!.toStringAsFixed(6)}'
      : '';

  EmergenciaModelo copyWith({
    double? latitud,
    double? longitud,
    String? imagenPath,
    DateTime? timestamp,
  }) {
    return EmergenciaModelo(
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      imagenPath: imagenPath ?? this.imagenPath,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
