import 'package:flutter_test/flutter_test.dart';
import 'package:detector_luz/main.dart';
import 'package:provider/provider.dart';
import 'package:detector_luz/controlador/luz_controlador.dart';

void main() {
  testWidgets('Detector luz app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LuzControlador(),
        child: const DetectorLuzApp(),
      ),
    );
    expect(find.text('Detector de Luz'), findsOneWidget);
  });
}
