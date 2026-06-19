import 'package:flutter_test/flutter_test.dart';
import 'package:contador_pasos/main.dart';
import 'package:provider/provider.dart';
import 'package:contador_pasos/controlador/pasos_controlador.dart';

void main() {
  testWidgets('Contador pasos app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PasosControlador(),
        child: const ContadorPasosApp(),
      ),
    );
    expect(find.text('Contador de Pasos'), findsOneWidget);
  });
}
