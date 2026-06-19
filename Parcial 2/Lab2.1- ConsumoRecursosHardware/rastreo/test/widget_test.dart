import 'package:flutter_test/flutter_test.dart';
import 'package:rastreo/main.dart';
import 'package:provider/provider.dart';
import 'package:rastreo/controlador/emergencia_controlador.dart';

void main() {
  testWidgets('Rastreo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => EmergenciaControlador(),
        child: const RastreoApp(),
      ),
    );
    expect(find.text('Sistema de Emergencia'), findsOneWidget);
  });
}
