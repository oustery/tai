import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/services/ai_service.dart';
import 'package:flutter_app_skeleton/state/chat_store.dart';
import 'package:flutter_app_skeleton/widgets/chat_composer.dart';
import 'package:flutter_app_skeleton/widgets/conversations_drawer.dart';
import 'package:flutter_app_skeleton/widgets/message_list_view.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';
import 'package:flutter_app_skeleton/widgets/welcome_state.dart';

/// Главный экран приложения: AppBar, список сообщений и поле ввода.
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

  @override
  void initState() {
    super.initState();
    _store.addListener(_scrollToBottom);
  }

  @override
  void dispose() {
    _store.removeListener(_scrollToBottom);
    _store.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = _scrollController;
      if (!controller.hasClients) {
        return;
      }
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final conversation = _store.current;
        final hasMessages =
            conversation != null && conversation.messages.isNotEmpty;

        return Scaffold(
          drawer: ConversationsDrawer(store: _store),
          appBar: AppBar(
            titleSpacing: 20,
            title: const Row(
              children: [
                TaiLogo(size: 34),
                SizedBox(width: 12),
                Text('Tai'),
              ],
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
          body: Column(
            children: [
              Expanded(
                child: hasMessages
                    ? MessageListView(
                        messages: conversation.messages,
                        controller: _scrollController,
                      )
                    : WelcomeState(onSuggestion: _store.send),
              ),
              ChatComposer(
                onSubmit: _store.send,
                isGenerating: _store.isGenerating,
                onStop: _store.stop,
              ),
            ],
          ),
        );
      },
    );
  }
}
