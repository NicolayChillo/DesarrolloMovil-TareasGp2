class AcelerometroModelo {
  final double x;
  final double y;
  final double z;

  const AcelerometroModelo({this.x = 0.0, this.y = 0.0, this.z = 0.0});

  String get estadoInclinacion {
    if (esHorizontal) return 'Horizontal - Nivel perfecto';
    if (x > 4.0) return 'Inclinado a la Derecha';
    if (x < -4.0) return 'Inclinado a la Izquierda';
    if (y > 4.0) return 'Inclinado hacia Adelante';
    if (y < -4.0) return 'Inclinado hacia Atrás';
    return 'Levemente Inclinado';
  }

  bool get esHorizontal => x.abs() < 1.2 && y.abs() < 1.2;

  bool get inclinadoDerecha => x > 4.0;
  bool get inclinadoIzquierda => x < -4.0;

  AcelerometroModelo copyWith({double? x, double? y, double? z}) {
    return AcelerometroModelo(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
    );
  }
}
