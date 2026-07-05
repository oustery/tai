import 'package:flutter/material.dart';

import 'package:flutter_app_skeleton/models/conversation.dart';
import 'package:flutter_app_skeleton/state/chat_store.dart';
import 'package:flutter_app_skeleton/widgets/tai_logo.dart';

/// Боковое меню: создание нового чата и список диалогов.
///
/// Включает TaiLogo в хедере, полноширинную кнопку «Новый чат»,
/// список диалогов с кастомными плитками и фирменный footer.
class ConversationsDrawer extends StatelessWidget {
  const ConversationsDrawer({super.key, required this.store});

  final ChatStore store;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final currentId = store.current?.id;

    return Drawer(
      backgroundColor: scheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Хедер с логотипом
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const TaiLogo(size: 36),
                  const SizedBox(width: 12),
                  Text(
                    'Tai',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Кнопка «Новый чат»
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    store.newConversation();
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Новый чат'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Разделитель с отступами
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            // Список диалогов
            Expanded(
              child: ListenableBuilder(
                listenable: store,
                builder: (context, _) {
                  final items = store.conversations;
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Пока нет диалогов',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final c = items[index];
                      return _ConversationTile(
                        conversation: c,
                        selected: c.id == currentId,
                        onTap: () {
                          store.select(c.id);
                          Navigator.of(context).maybePop();
                        },
                        onDelete: () => store.delete(c.id),
                      );
                    },
                  );
                },
              ),
            ),
            // Footer с фирменным акцентом
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tai · v0.2.0',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Плитка одного диалога в боковом меню.
class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final Conversation conversation;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: selected ? scheme.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 20,
                color: selected
                    ? scheme.onSecondaryContainer
                    : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurface,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Удалить',
              ),
            ],
          ),
        ),
      ),
    );
  }
}