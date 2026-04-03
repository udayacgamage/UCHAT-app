import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/media_provider.dart';
import '../../models/message_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

/// Chat screen for displaying and sending messages
class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final bool isGroup;

  const ChatScreen({
    required this.chatId,
    this.isGroup = false,
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    try {
      await ref.read(sendMessageProvider(
        SendMessageParams(
          chatId: widget.chatId,
          content: content,
          isGroup: widget.isGroup,
        ),
      ).future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearChatMessages() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat Messages?'),
        content: const Text(
          'This will delete all messages in this chat. The chat will remain but all messages will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(clearChatMessagesProvider(
        ClearChatParams(
          chatId: widget.chatId,
          isGroup: widget.isGroup,
        ),
      ).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat messages cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear chat: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleAttachment() async {
    final mediaService = ref.read(mediaServiceProvider);

    // Show source picker
    final source = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, 0),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, 1),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final imageFile = source == 0
        ? await mediaService.pickImageFromCamera()
        : await mediaService.pickImageFromGallery();

    if (imageFile == null) return;

    setState(() => _isUploading = true);

    try {
      // Upload image
      final stream = mediaService.uploadImageToStorage(imageFile, widget.chatId);

      String? downloadUrl;
      await for (final event in stream) {
        if (event.url != null) {
          downloadUrl = event.url;
        }
      }

      if (downloadUrl != null) {
        // Send image message
        final currentUser = ref.read(currentUserProvider).value;
        if (currentUser != null) {
          await ref.read(sendMessageProvider(
            SendMessageParams(
              chatId: widget.chatId,
              content: 'Sent an image',
              type: MessageType.image,
              mediaUrl: downloadUrl,
              mediaName: 'image.jpg',
              mediaSize: await imageFile.length(),
              isGroup: widget.isGroup,
            ),
          ).future);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesStreamProvider((
      chatId: widget.chatId,
      isGroup: widget.isGroup
    )));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isGroup ? 'Group Chat' : 'Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear Chat'),
                onTap: _clearChatMessages,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () {
                // Don't show loading - just return empty container (silent refresh)
                return Container();
              },
              error: (err, st) => Center(
                child: Text('Error loading messages: $err'),
              ),
              data: (messageList) {
                if (messageList.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                return currentUser.when(
                  loading: () => Container(), // Silent loading
                  error: (err, st) => Center(child: Text('Error: $err')),
                  data: (user) {
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        final message = messageList[index];
                        final isSent = user?.uid == message.senderId;

                        return MessageBubble(
                          senderName: message.senderName,
                          content: message.isDeleted
                              ? 'This message was deleted'
                              : message.content,
                          mediaUrl: message.isDeleted ? null : message.mediaUrl,
                          timestamp: message.createdAt,
                          isSent: isSent,
                          isRead: message.readBy.isNotEmpty,
                          isDelivered: message.deliveredTo.isNotEmpty,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          MessageInput(
            onMessageSend: _sendMessage,
            onAttachmentPress: _handleAttachment,
            controller: _messageController,
            isEnabled: !_isUploading,
          ),
        ],
      ),
    );
  }
}
