import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_skeleton/main.dart';

void main() {
  testWidgets('App renders placeholder text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Пустое приложение'), findsOneWidget);
  });
}
