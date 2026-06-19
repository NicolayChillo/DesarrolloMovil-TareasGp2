import 'package:flutter_test/flutter_test.dart';
import 'package:turismo/main.dart';
import 'package:provider/provider.dart';
import 'package:turismo/controlador/turismo_controlador.dart';

void main() {
  testWidgets('Turismo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TurismoControlador(),
        child: const TurismoApp(),
      ),
    );
    expect(find.text('Turismo Ecuador'), findsOneWidget);
  });
}
