import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/screens/home_screen.dart';
import 'package:flutter_app_skeleton/services/ai_service.dart';
import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Корневой виджет приложения Tai.
///
/// Claude Dark Minimal: тёмная тема по умолчанию, переключение доступно.
class TaiApp extends StatefulWidget {
  const TaiApp({super.key});

  @override
  State<TaiApp> createState() => _TaiAppState();
}

class _TaiAppState extends State<TaiApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  final AiService _ai = MockAiService();

  bool get _isDark {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system && platformDark);
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      themeAnimationDuration: const Duration(milliseconds: 300),
      home: HomeScreen(
        aiService: _ai,
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
