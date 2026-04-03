import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import 'auth_provider.dart';
import '../models/group_model.dart';

// Service provider
final chatServiceProvider = Provider((ref) => ChatService());

// Chats stream for current user
final chatsStreamProvider = StreamProvider<List<ChatModel>>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  return currentUser.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      final chatService = ref.watch(chatServiceProvider);
      return chatService.getChatsStream(user.uid);
    },
    loading: () => Stream.value([]),
    error: (err, st) => Stream.value([]),
  );
});

// Groups stream for current user
final groupsStreamProvider = StreamProvider<List<GroupModel>>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  return currentUser.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      final chatService = ref.watch(chatServiceProvider);
      return chatService.getGroupsStream(user.uid);
    },
    loading: () => Stream.value([]),
    error: (err, st) => Stream.value([]),
  );
});

// Messages stream for a specific chat
final messagesStreamProvider = StreamProvider.family<List<MessageModel>, ({String chatId, bool isGroup})>((ref, params) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getMessagesStream(
    params.chatId,
    isGroup: params.isGroup,
  );
});

// Typing status stream
final typingStatusProvider = StreamProvider.family<Map<String, bool>, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getTypingStream(chatId);
});

// Send message params
class SendMessageParams {
  final String chatId;
  final String content;
  final MessageType type;
  final String? mediaUrl;
  final String? mediaName;
  final int? mediaSize;
  final ReplyTo? replyTo;
  final bool isGroup;

  SendMessageParams({
    required this.chatId,
    required this.content,
    this.type = MessageType.text,
    this.mediaUrl,
    this.mediaName,
    this.mediaSize,
    this.replyTo,
    this.isGroup = false,
  });
}

// Send message provider
final sendMessageProvider = FutureProvider.family<void, SendMessageParams>((ref, params) async {
  final currentUser = ref.watch(currentUserProvider);
  final chatService = ref.watch(chatServiceProvider);

  await currentUser.when(
    data: (user) {
      if (user == null) throw Exception('User not logged in');
      return chatService.sendMessage(
        params.chatId,
        params.content,
        user.uid,
        user.name,
        type: params.type,
        mediaUrl: params.mediaUrl,
        mediaName: params.mediaName,
        mediaSize: params.mediaSize,
        replyTo: params.replyTo,
        isGroup: params.isGroup,
      );
    },
    loading: () => throw Exception('Loading user'),
    error: (err, st) => throw err,
  );
});

// Update typing status
class UpdateTypingParams {
  final String chatId;
  final bool isTyping;

  UpdateTypingParams({
    required this.chatId,
    required this.isTyping,
  });
}

final updateTypingProvider = FutureProvider.family<void, UpdateTypingParams>((ref, params) async {
  final currentUser = ref.watch(currentUserProvider);
  final chatService = ref.watch(chatServiceProvider);

  await currentUser.when(
    data: (user) {
      if (user == null) throw Exception('User not logged in');
      return chatService.updateTypingStatus(params.chatId, user.uid, params.isTyping);
    },
    loading: () => throw Exception('Loading user'),
    error: (err, st) => throw err,
  );
});
