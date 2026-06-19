class PasoModelo {
  final int pasos;
  final double calorias;
  final double distanciaKm;
  final List<RegistroDiario> historial;

  const PasoModelo({
    this.pasos = 0,
    this.calorias = 0.0,
    this.distanciaKm = 0.0,
    this.historial = const [],
  });

  PasoModelo copyWith({
    int? pasos,
    double? calorias,
    double? distanciaKm,
    List<RegistroDiario>? historial,
  }) {
    return PasoModelo(
      pasos: pasos ?? this.pasos,
      calorias: calorias ?? this.calorias,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      historial: historial ?? this.historial,
    );
  }

  String get distanciaTexto {
    if (distanciaKm < 1.0) {
      return '${(distanciaKm * 1000).toStringAsFixed(0)} m';
    }
    return '${distanciaKm.toStringAsFixed(2)} km';
  }
}

class RegistroDiario {
  final String fecha;
  final int pasos;
  final double calorias;
  final double distanciaKm;

  const RegistroDiario({
    required this.fecha,
    required this.pasos,
    required this.calorias,
    required this.distanciaKm,
  });
}
