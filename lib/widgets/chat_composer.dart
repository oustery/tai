import 'package:flutter/material.dart';

/// Поле ввода и кнопка отправки сообщения.
///
/// Claude Dark Minimal: плоское поле без границ, отправка — простой
/// заполненный круг (primary при активности, surfaceContainerHigh иначе).
/// Без градиентов и теней.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSubmit,
    required this.isGenerating,
    required this.onStop,
  });

  final ValueChanged<String> onSubmit;
  final bool isGenerating;
  final VoidCallback onStop;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCanSend);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _updateCanSend() {
    final next = _controller.text.trim().isNotEmpty;
    if (next != _canSend) setState(() => _canSend = next);
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty || widget.isGenerating) return;
    widget.onSubmit(text);
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final actionEnabled = widget.isGenerating || _canSend;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Текстовое поле — плоское, без границ
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Спросите что-нибудь у Tai\u2026',
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Кнопка отправки — простой круг
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: actionEnabled
                      ? scheme.primary
                      : scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    onPressed: actionEnabled
                        ? (widget.isGenerating ? widget.onStop : _submit)
                        : null,
                    icon: Icon(
                      widget.isGenerating
                          ? Icons.stop_rounded
                          : Icons.arrow_upward_rounded,
                      color: actionEnabled
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                      size: 22,
                    ),
                    tooltip: widget.isGenerating ? 'Остановить' : 'Отправить',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
