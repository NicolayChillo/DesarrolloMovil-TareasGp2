import 'package:flutter_test/flutter_test.dart';
import 'package:geolocalizacion/main.dart';
import 'package:provider/provider.dart';
import 'package:geolocalizacion/controlador/camara_controlador.dart';

void main() {
  testWidgets('Geolocalizacion app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CamaraControlador(),
        child: const GeolocalizacionApp(),
      ),
    );
    expect(find.text('Cámara Turística'), findsOneWidget);
  });
}
