import 'package:flutter/material.dart';

/// Точка входа в приложение.
///
/// Содержит минимальный пустой каркас:MaterialApp с пустым экраном.
/// Используйте [runApp] для запуска корневого виджета.
void main() {
  runApp(const MyApp());
}

/// Корневой виджет приложения.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Skeleton',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Пустое приложение'),
        ),
      ),
    );
  }
}
