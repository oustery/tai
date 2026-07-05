import 'package:flutter/material.dart';

/// Поле ввода и кнопка отправки сообщения.
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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top:
                BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                style: TextStyle(color: scheme.onSurface, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Спросите что-нибудь у Tai…',
                  isCollapsed: false,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: IconButton.filled(
                onPressed: actionEnabled
                    ? (widget.isGenerating ? widget.onStop : _submit)
                    : null,
                icon: Icon(
                  widget.isGenerating
                      ? Icons.stop_rounded
                      : Icons.arrow_upward_rounded,
                ),
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
