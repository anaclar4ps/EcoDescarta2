import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('Abre o guia de descarte', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoDescartaApp());

    expect(find.text('Descarte certo'), findsOneWidget);

    await tester.tap(find.text('Guia'));
    await tester.pumpAndSettle();

    expect(find.text('Cores das lixeiras'), findsOneWidget);
  });
}