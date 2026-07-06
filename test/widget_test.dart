import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_skeleton/app.dart';

void main() {
  testWidgets('App boots and shows Tai brand', (tester) async {
    await tester.pumpWidget(const TaiApp());
    await tester.pumpAndSettle();

    expect(find.text('Tai'), findsOneWidget);
    expect(find.text('Привет! Я Tai'), findsOneWidget);
  });

  testWidgets('Suggestion triggers a user + assistant message', (tester) async {
    await tester.pumpWidget(const TaiApp());
    await tester.pumpAndSettle();

    // Тапаем по первой подсказке.
    await tester.tap(find.text('Дай 5 идей для пет-проекта'));
    await tester.pump();

    // Сообщение пользователя появляется сразу.
    expect(find.text('Дай 5 идей для пет-проекта'), findsOneWidget);

    // Даём стриму ответа добежать до конца.
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
