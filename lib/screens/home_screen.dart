import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/services/ai_service.dart';
import 'package:flutter_app_skeleton/state/chat_store.dart';
import 'package:flutter_app_skeleton/widgets/chat_composer.dart';
import 'package:flutter_app_skeleton/widgets/conversations_drawer.dart';
import 'package:flutter_app_skeleton/widgets/message_list_view.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';
import 'package:flutter_app_skeleton/widgets/welcome_state.dart';

/// Главный экран приложения: AppBar, список сообщений и поле ввода.
///
/// Пересборки при стриминге ограничены только списком сообщений и
/// композитором (scoped [ListenableBuilder]), AppBar остаётся статичным.
/// При прокрутке вверх появляется FAB для быстрого возврата вниз.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.aiService,
    required this.isDark,
    required this.onToggleTheme,
  });

  final AiService aiService;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ChatStore _store = ChatStore(widget.aiService);
  final ScrollController _scrollController = ScrollController();
  bool _showScrollFab = false;

  @override
  void initState() {
    super.initState();
    _store.addListener(_scrollToBottom);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _store.removeListener(_scrollToBottom);
    _store.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Автопрокрутка к нижнему краю при новом сообщении / токене стрима.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  /// Показываем / скрываем FAB «вниз» в зависимости от позиции скролла.
  void _onScroll() {
    final showFab =
        _scrollController.hasClients && _scrollController.offset > 200;
    if (showFab != _showScrollFab) {
      setState(() => _showScrollFab = showFab);
    }
  }

  void _scrollToBottomInstant() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: ConversationsDrawer(store: _store),
      appBar: AppBar(
        // AppBar статичен — не пересобирается при стриминге
        titleSpacing: 16,
        title: const Row(
          children: [TaiLogo(size: 34), SizedBox(width: 12), Text('Tai')],
        ),
        actions: [
          IconButton(
            onPressed: _store.newConversation,
            icon: const Icon(Icons.add_comment_rounded),
            tooltip: 'Новый чат',
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Сменить тему',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          // Основной контент
          Column(
            children: [
              // Область сообщений / welcome — пересобирается при изменениях store
              Expanded(
                child: ListenableBuilder(
                  listenable: _store,
                  builder: (context, _) {
                    final conv = _store.current;
                    final hasMsgs = conv != null && conv.messages.isNotEmpty;
                    return hasMsgs
                        ? MessageListView(
                            messages: conv.messages,
                            controller: _scrollController,
                          )
                        : WelcomeState(onSuggestion: _store.send);
                  },
                ),
              ),
              // Композитор — пересобирается только для isGenerating
              ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  return ChatComposer(
                    onSubmit: _store.send,
                    isGenerating: _store.isGenerating,
                    onStop: _store.stop,
                  );
                },
              ),
            ],
          ),
          // FAB «прокрутить вниз» — появляется при скролле вверх
          if (_showScrollFab)
            Positioned(
              bottom: 76,
              right: 16,
              child: TweenAnimationBuilder<double>(
                tween: const Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * value,
                      child: child,
                    ),
                  );
                },
                child: Material(
                  elevation: 3,
                  shape: const CircleBorder(),
                  color: scheme.surfaceContainerHigh,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _scrollToBottomInstant,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
