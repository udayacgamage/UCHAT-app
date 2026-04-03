import 'package:cloud_firestore/cloud_firestore.dart';

/// Message type enumeration
enum MessageType { text, image, file, audio }

extension MessageTypeExt on MessageType {
  String get value => toString().split('.').last;

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageType.text,
    );
  }
}

/// Reply-to reference in a message
class ReplyTo {
  final String messageId;
  final String content;
  final String senderName;

  const ReplyTo({
    required this.messageId,
    required this.content,
    required this.senderName,
  });

  factory ReplyTo.fromMap(Map<String, dynamic> map) {
    return ReplyTo(
      messageId: map['messageId'] ?? '',
      content: map['content'] ?? '',
      senderName: map['senderName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'content': content,
      'senderName': senderName,
    };
  }
}

/// Message model
class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String content; // ENCRYPTED in Firestore, decrypted at app level
  final MessageType type;
  final String? mediaUrl;
  final String? mediaName;
  final int? mediaSize;
  final ReplyTo? replyTo;
  final List<String> readBy;
  final List<String> deliveredTo;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.type = MessageType.text,
    this.mediaUrl,
    this.mediaName,
    this.mediaSize,
    this.replyTo,
    this.readBy = const [],
    this.deliveredTo = const [],
    this.isDeleted = false,
    this.deletedAt,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      content: map['content'] ?? '',
      type: MessageTypeExt.fromString(map['type'] ?? 'text'),
      mediaUrl: map['mediaUrl'],
      mediaName: map['mediaName'],
      mediaSize: map['mediaSize'],
      replyTo: map['replyTo'] != null ? ReplyTo.fromMap(map['replyTo']) : null,
      readBy: List<String>.from(map['readBy'] ?? []),
      deliveredTo: List<String>.from(map['deliveredTo'] ?? []),
      isDeleted: map['isDeleted'] ?? false,
      deletedAt: (map['deletedAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'type': type.value,
      'mediaUrl': mediaUrl,
      'mediaName': mediaName,
      'mediaSize': mediaSize,
      'replyTo': replyTo?.toMap(),
      'readBy': readBy,
      'deliveredTo': deliveredTo,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? type,
    String? mediaUrl,
    String? mediaName,
    int? mediaSize,
    ReplyTo? replyTo,
    List<String>? readBy,
    List<String>? deliveredTo,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaName: mediaName ?? this.mediaName,
      mediaSize: mediaSize ?? this.mediaSize,
      replyTo: replyTo ?? this.replyTo,
      readBy: readBy ?? this.readBy,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'MessageModel(id: $id, senderId: $senderId, content: ${content.length} chars)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

