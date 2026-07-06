import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/screens/home_screen.dart';
import 'package:flutter_app_skeleton/services/ai_service.dart';
import 'package:flutter_app_skeleton/theme/app_theme.dart';

/// Корневой виджет приложения Tai.
///
/// Настраивает Material 3 тему (светлую и тёмную), переключение темевой схемы
/// и размещает [HomeScreen] в качестве стартового экрана.
class TaiApp extends StatefulWidget {
  const TaiApp({super.key});

  @override
  State<TaiApp> createState() => _TaiAppState();
}

class _TaiAppState extends State<TaiApp> {
  ThemeMode _themeMode = ThemeMode.system;

  /// Экземпляр ИИ-сервиса создаётся один раз и переживает перестроения
  /// виджета (например, при переключении темы).
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
      themeAnimationDuration: const Duration(milliseconds: 400),
      home: HomeScreen(
        aiService: _ai,
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
