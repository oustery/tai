import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_skeleton/app.dart';

void main() {
  testWidgets('App boots and shows Tai brand', (tester) async {
    await tester.pumpWidget(const TaiApp());
    // pumpAndSettle нельзя — TaiLogo(animate: true) на welcome-экране
    // использует .repeat(), который никогда не завершается.
    // Достаточно одного кадра для проверки отрисовки.
    await tester.pump();

    expect(find.text('Tai'), findsOneWidget);
    expect(find.text('Привет! Я Tai'), findsOneWidget);
  });

  testWidgets('Suggestion triggers a user + assistant message', (tester) async {
    await tester.pumpWidget(const TaiApp());
    await tester.pump();

    // Тапаем по подсказке.
    await tester.tap(find.text('Дай 5 идей для пет-проекта'));
    await tester.pump();

    // Сообщение пользователя появляется сразу.
    expect(find.text('Дай 5 идей для пет-проекта'), findsOneWidget);

    // Продвигаем часы на 4 секунды — этого хватит для завершения
    // mock-стрима (thinking 650мс + ~40 токенов × 28мс ≈ 1.8с).
    // pumpAndSettle не подходит: TypingIndicator тоже использует .repeat().
    await tester.pump(const Duration(seconds: 4));
  });
}