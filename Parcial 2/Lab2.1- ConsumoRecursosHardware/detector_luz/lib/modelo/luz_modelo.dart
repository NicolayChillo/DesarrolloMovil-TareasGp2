class LuzModelo {
  final double lux;

  const LuzModelo({this.lux = 0.0});

  String get clasificacion {
    if (lux < 10) return 'Oscuro';
    if (lux < 200) return 'Normal';
    return 'Muy Iluminado';
  }

  String get recomendacion {
    if (lux < 10) {
      return 'Ambiente muy oscuro. Enciende luces para proteger tu vista.';
    }
    if (lux < 50) {
      return 'Luz tenue. Adecuada para ambientes relajados o descanso.';
    }
    if (lux < 200) {
      return 'Ambiente adecuado para lectura y trabajo normal.';
    }
    if (lux < 500) {
      return 'Buena iluminacion. Ideal para trabajo de precision.';
    }
    return 'Muy iluminado. Protege tus ojos de exposicion prolongada.';
  }

  String get icono {
    if (lux < 10) return '🌑';
    if (lux < 200) return '💡';
    return '☀️';
  }

  double get progreso => (lux / 1000).clamp(0.0, 1.0);

  LuzModelo copyWith({double? lux}) => LuzModelo(lux: lux ?? this.lux);
}
