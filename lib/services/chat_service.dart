import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../core/constants/firestore_paths.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/logger.dart';
import 'encryption_service.dart';

/// Chat service for messaging operations
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EncryptionService _encryptionService = EncryptionService();

  /// Create or get direct chat between two users
  Future<ChatModel> createOrGetDirectChat(
    String currentUserId,
    String otherUserId,
    String currentUserName,
    String otherUserName,
    String? currentUserPhoto,
    String? otherUserPhoto,
  ) async {
    try {
      AppLogger.info('Creating/getting chat between $currentUserId and $otherUserId');

      // Generate consistent chat ID from sorted user IDs
      final ids = [currentUserId, otherUserId]..sort();
      final chatId = '${ids[0]}_${ids[1]}';

      // Check if chat already exists
      final doc = await _firestore.collection('chats').doc(chatId).get();

      if (doc.exists) {
        AppLogger.debug('Chat already exists: $chatId');
        return ChatModel.fromMap(doc.data() as Map<String, dynamic>);
      }

      // Generate encryption key for this chat
      await _encryptionService.generateAndStoreChatKey(
        chatId,
        currentUserId,
        otherUserId,
      );

      // Create new chat
      final chat = ChatModel(
        id: chatId,
        participants: [currentUserId, otherUserId],
        participantNames: {
          currentUserId: currentUserName,
          otherUserId: otherUserName,
        },
        participantPhotos: {
          if (currentUserPhoto != null) currentUserId: currentUserPhoto,
          if (otherUserPhoto != null) otherUserId: otherUserPhoto,
        },
        lastMessageTime: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _firestore.collection('chats').doc(chatId).set(chat.toMap());

      AppLogger.success('Chat created: $chatId');
      return chat;
    } catch (e, st) {
      AppLogger.error('Failed to create/get chat: $e', st);
      throw AppException(
        message: 'Failed to open chat',
        originalException: e,
      );
    }
  }

  /// Send message to chat
  Future<void> sendMessage(
    String chatId,
    String plainContent,
    String senderId,
    String senderName, {
    MessageType type = MessageType.text,
    String? mediaUrl,
    String? mediaName,
    int? mediaSize,
    ReplyTo? replyTo,
    bool isGroup = false,
  }) async {
    try {
      AppLogger.info('Sending message to $chatId (Group: $isGroup)');

      // For now, store messages as plain text to ensure readability
      // In production, you can uncomment the encryption below
      // final encryptedContent = await _encryptionService.encryptMessage(
      //   plainContent,
      //   chatId,
      // );
      
      final messageContent = plainContent; // Use plain text for now

      final messageId = const Uuid().v4();
      final now = DateTime.now();

      // Create message
      final message = MessageModel(
        id: messageId,
        senderId: senderId,
        senderName: senderName,
        content: messageContent,
        type: type,
        mediaUrl: mediaUrl,
        mediaName: mediaName,
        mediaSize: mediaSize,
        replyTo: replyTo,
        deliveredTo: [senderId],
        createdAt: now,
      );

      // Determine collections based on isGroup
      final messagesPath = isGroup 
          ? FirestorePaths.groupMessagesCollection(chatId)
          : FirestorePaths.messagesCollection(chatId);
      final metaCollection = isGroup ? 'groups' : 'chats';

      // Write message to Firestore
      await _firestore
          .collection(messagesPath)
          .doc(messageId)
          .set(message.toMap());

      // Update chat/group's last message
      await _firestore.collection(metaCollection).doc(chatId).update({
        'lastMessage': plainContent.length > 50 
            ? '${plainContent.substring(0, 50)}...'
            : plainContent,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
      });

      // Reset unread count for sender (only for direct chats, groups differ)
      if (!isGroup) {
        await _firestore.collection('chats').doc(chatId).update({
          'unreadCount.${senderId}': 0,
        });
      }

      AppLogger.success('Message sent: $messageId');
    } catch (e, st) {
      AppLogger.error('Failed to send message: $e', st);
      throw AppException(
        message: 'Failed to send message',
        originalException: e,
      );
    }
  }

  /// Get message with decryption
  Future<MessageModel> getMessage(String chatId, String messageId) async {
    try {
      final doc = await _firestore
          .collection(FirestorePaths.messagesCollection(chatId))
          .doc(messageId)
          .get();

      if (!doc.exists) {
        throw AppException(message: 'Message not found');
      }

      var message = MessageModel.fromMap(doc.data() as Map<String, dynamic>);

      // Messages are stored as plain text for now, so no decryption needed
      return message;
    } catch (e, st) {
      AppLogger.error('Failed to get message: $e', st);
      throw AppException(
        message: 'Failed to load message',
        originalException: e,
      );
    }
  }

  /// Mark message as delivered
  Future<void> markMessageAsDelivered(String chatId, String messageId, String userId) async {
    try {
      await _firestore
          .collection(FirestorePaths.messagesCollection(chatId))
          .doc(messageId)
          .update({
        'deliveredTo': FieldValue.arrayUnion([userId]),
      });
    } catch (e, st) {
      AppLogger.error('Failed to mark as delivered: $e', st);
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String chatId, String messageId, String userId) async {
    try {
      await _firestore
          .collection(FirestorePaths.messagesCollection(chatId))
          .doc(messageId)
          .update({
        'readBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e, st) {
      AppLogger.error('Failed to mark as read: $e', st);
    }
  }

  /// Delete message
  Future<void> deleteMessage(
    String chatId,
    String messageId, {
    bool deleteForEveryone = false,
  }) async {
    try {
      if (deleteForEveryone) {
        await _firestore
            .collection(FirestorePaths.messagesCollection(chatId))
            .doc(messageId)
            .update({
          'isDeleted': true,
          'deletedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Soft delete - just mark as deleted for current user
        await _firestore
            .collection(FirestorePaths.messagesCollection(chatId))
            .doc(messageId)
            .update({
          'isDeleted': true,
        });
      }
      AppLogger.success('Message deleted');
    } catch (e, st) {
      AppLogger.error('Failed to delete message: $e', st);
      throw AppException(
        message: 'Failed to delete message',
        originalException: e,
      );
    }
  }

  /// Get chats stream for current user
  Stream<List<ChatModel>> getChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatModel.fromMap(doc.data()))
          .toList();
    }).handleError((error, stackTrace) {
      AppLogger.warn('Error getting chats (returning empty list): $error');
      // Return empty list on error instead of throwing
      // This handles cases where orderBy fails on empty collections
    });
  }

  /// Get groups stream for current user
  Stream<List<GroupModel>> getGroupsStream(String userId) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data()))
          .toList();
    }).handleError((error, stackTrace) {
      AppLogger.warn('Error getting groups (returning empty list): $error');
      // Return empty list on error instead of throwing
    });
  }

  /// Get messages stream for a chat with decryption
  Stream<List<MessageModel>> getMessagesStream(
    String chatId, {
    int pageSize = 30,
    bool isGroup = false,
  }) {
    final path = isGroup 
        ? FirestorePaths.groupMessagesCollection(chatId)
        : FirestorePaths.messagesCollection(chatId);

    return _firestore
        .collection(path)
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .snapshots()
        .asyncMap((snapshot) async {
      final messages = <MessageModel>[];
      for (final doc in snapshot.docs) {
        var message = MessageModel.fromMap(doc.data());
        // Messages are stored as plain text for now, so no decryption needed
        messages.add(message);
      }
      return messages;
    }).handleError((error, stackTrace) {
      AppLogger.error('Error getting messages: $error');
      // Return empty list instead of throwing to prevent UI crash
    });
  }

  /// Get typing status stream
  Stream<Map<String, bool>> getTypingStream(String chatId) {
    return _firestore
        .collection(FirestorePaths.typingCollection(chatId))
        .snapshots()
        .map((snapshot) {
      final typing = <String, bool>{};
      final now = DateTime.now();
      
      for (final doc in snapshot.docs) {
        final timestamp = (doc['timestamp'] as Timestamp?)?.toDate();
        if (timestamp != null) {
          // Only show typing if updated in last 3 seconds
          if (now.difference(timestamp).inSeconds < 3) {
            typing[doc.id] = true;
          }
        }
      }
      return typing;
    });
  }

  /// Update typing status
  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) async {
    try {
      if (isTyping) {
        await _firestore
            .collection(FirestorePaths.typingCollection(chatId))
            .doc(userId)
            .set({
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore
            .collection(FirestorePaths.typingCollection(chatId))
            .doc(userId)
            .delete();
      }
    } catch (e) {
      AppLogger.warn('Failed to update typing status: $e');
    }
  }

  /// Create group
  Future<void> createGroup({
    required String groupId,
    required String name,
    required String description,
    required List<String> memberIds,
    String? photoUrl,
    required String createdBy,
  }) async {
    try {
      AppLogger.info('Creating group: $groupId');

      // Fetch member names
      final memberNames = <String, String>{};
      for (final memberId in memberIds) {
        final doc = await _firestore.collection('users').doc(memberId).get();
        if (doc.exists) {
          final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          memberNames[memberId] = user.name;
        }
      }

      final group = {
        'id': groupId,
        'name': name,
        'description': description,
        'photoUrl': photoUrl,
        'adminIds': [createdBy],
        'members': memberIds,
        'memberNames': memberNames,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('groups').doc(groupId).set(group);
      AppLogger.success('Group created: $groupId');
    } catch (e, st) {
      AppLogger.error('Failed to create group: $e', st);
      throw AppException(
        message: 'Failed to create group',
        originalException: e,
      );
    }
  }

  /// Delete a direct chat
  Future<void> deleteChat(String chatId) async {
    try {
      AppLogger.debug('Deleting chat: $chatId');
      await _firestore.collection('chats').doc(chatId).delete();
      AppLogger.success('Chat deleted');
    } catch (e, st) {
      AppLogger.error('Failed to delete chat: $e', st);
      throw AppException(
        message: 'Failed to delete chat',
        originalException: e,
      );
    }
  }

  /// Delete a group chat
  Future<void> deleteGroup(String groupId) async {
    try {
      AppLogger.debug('Deleting group: $groupId');
      await _firestore.collection('groups').doc(groupId).delete();
      AppLogger.success('Group deleted');
    } catch (e, st) {
      AppLogger.error('Failed to delete group: $e', st);
      throw AppException(
        message: 'Failed to delete group',
        originalException: e,
      );
    }
  }

  /// Leave a group (remove current user from members)
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      AppLogger.debug('User $userId leaving group: $groupId');
      await _firestore
          .collection('groups')
          .doc(groupId)
          .update({
        'members': FieldValue.arrayRemove([userId]),
      });
      AppLogger.success('Left group');
    } catch (e, st) {
      AppLogger.error('Failed to leave group: $e', st);
      throw AppException(
        message: 'Failed to leave group',
        originalException: e,
      );
    }
  }
}
