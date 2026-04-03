import 'package:cloud_firestore/cloud_firestore.dart';

/// Chat model for direct and group chats
class ChatModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String> participantPhotos;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final Map<String, int> unreadCount;
  final bool isGroup;
  final DateTime createdAt;

  const ChatModel({
    required this.id,
    required this.participants,
    this.participantNames = const {},
    this.participantPhotos = const {},
    this.lastMessage = '',
    required this.lastMessageTime,
    this.lastMessageSenderId = '',
    this.unreadCount = const {},
    this.isGroup = false,
    required this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
      participantPhotos: Map<String, String>.from(map['participantPhotos'] ?? {}),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
      unreadCount: map['unreadCount'] != null
          ? (map['unreadCount'] as Map).cast<String, int>()
          : {},
      isGroup: map['isGroup'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'participantNames': participantNames,
      'participantPhotos': participantPhotos,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isGroup': isGroup,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ChatModel copyWith({
    String? id,
    List<String>? participants,
    Map<String, String>? participantNames,
    Map<String, String>? participantPhotos,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    Map<String, int>? unreadCount,
    bool? isGroup,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      participantPhotos: participantPhotos ?? this.participantPhotos,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'ChatModel(id: $id, participants: ${participants.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

