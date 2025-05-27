import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isEnabled;
  final bool isLoading;
  final String? placeholder;

  const ChatInput({
    required this.onSendMessage,
    super.key,
    this.isEnabled = true,
    this.isLoading = false,
    this.placeholder,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Color(0xFF2A2A2A),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice input button
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF2D7D7D),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: widget.isEnabled ? _handleVoiceInput : null,
                icon: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 12),

            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? const Color(0xFF2D7D7D)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: widget.isEnabled && !widget.isLoading,
                        decoration: InputDecoration(
                          hintText: widget.placeholder ?? 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),

                    // Send button
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: _isComposing &&
                                widget.isEnabled &&
                                !widget.isLoading
                            ? _handleSend
                            : null,
                        icon: widget.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2D7D7D),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.send_rounded,
                                color: _isComposing && widget.isEnabled
                                    ? const Color(0xFF2D7D7D)
                                    : Colors.white.withOpacity(0.3),
                                size: 20,
                              ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVoiceInput() {
    // Handle voice input
    // You can integrate with speech_to_text package here
  }
}
