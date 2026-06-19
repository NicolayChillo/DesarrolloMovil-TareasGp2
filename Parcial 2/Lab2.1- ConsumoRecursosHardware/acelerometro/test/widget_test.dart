import 'package:flutter_test/flutter_test.dart';
import 'package:acelerometro/main.dart';
import 'package:provider/provider.dart';
import 'package:acelerometro/controlador/acelerometro_controlador.dart';

void main() {
  testWidgets('Acelerometro app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AcelerometroControlador(),
        child: const AcelerometroApp(),
      ),
    );
    expect(find.text('Nivelador Digital'), findsOneWidget);
  });
}
