import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/theme/text_styles.dart';

/// Message input widget with emoji and attachment support
class MessageInput extends StatefulWidget {
  final Function(String) onMessageSend;
  final Function()? onAttachmentPress;
  final bool isEnabled;
  final TextEditingController? controller;

  const MessageInput({
    required this.onMessageSend,
    this.onAttachmentPress,
    this.isEnabled = true,
    this.controller,
    super.key,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late TextEditingController _controller;
  bool _showEmojiPicker = false;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateComposingStatus);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateComposingStatus() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    widget.onMessageSend(_controller.text.trim());
    _controller.clear();
    _showEmojiPicker = false;
    setState(() {
      _isComposing = false;
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message input field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Attachment button
              IconButton(
                icon: const Icon(Icons.attach_file),
                color: AppColors.primary,
                onPressed: widget.isEnabled ? widget.onAttachmentPress : null,
              ),
              
              // Text input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.isEnabled,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyles.bodyMedium.copyWith(
                      color: isDark 
                        ? AppColors.darkTextSecondary 
                        : AppColors.lightTextSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: isDark 
                          ? AppColors.inputBorder 
                          : AppColors.divider,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: isDark 
                          ? AppColors.inputBorder 
                          : AppColors.divider,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.cardDark : AppColors.background,
                  ),
                ),
              ),
              
              // Emoji button
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                color: AppColors.primary,
                onPressed: widget.isEnabled ? _toggleEmojiPicker : null,
              ),
              
              // Send button
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(
                    _isComposing ? Icons.send : Icons.send_outlined,
                    color: _isComposing ? AppColors.primary : AppColors.lightTextSecondary,
                  ),
                  onPressed: _isComposing ? _sendMessage : null,
                ),
              ),
            ],
          ),
        ),
        
        // Emoji picker
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
              },
              onBackspacePressed: () {
                if (_controller.text.isNotEmpty) {
                  _controller.text = _controller.text.substring(
                    0,
                    _controller.text.length - 1,
                  );
                }
              },
              config: Config(
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                ),
                skinToneConfig: SkinToneConfig(
                  enabled: true,
                  dialogBackgroundColor: isDark ? AppColors.cardDark : AppColors.surface,
                  indicatorColor: AppColors.primary,
                ),
                categoryViewConfig: CategoryViewConfig(
                  categoryIcons: const CategoryIcons(),
                  backgroundColor: isDark ? AppColors.cardDark : AppColors.background,
                  indicatorColor: AppColors.primary,
                  iconColor: AppColors.lightTextSecondary,
                  iconColorSelected: AppColors.primary,
                  backspaceColor: AppColors.error,
                  dividerColor: AppColors.divider,
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  enabled: true,
                  backgroundColor: isDark ? AppColors.cardDark : AppColors.surface,
                  buttonColor: AppColors.primary,
                  buttonIconColor: AppColors.sentText,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

