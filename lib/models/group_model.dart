import 'package:cloud_firestore/cloud_firestore.dart';

/// Group model for group chats
class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? photoUrl;
  final List<String> adminIds;
  final List<String> members;
  final Map<String, String> memberNames;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String createdBy;
  final DateTime createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    this.description,
    this.photoUrl,
    this.adminIds = const [],
    this.members = const [],
    this.memberNames = const {},
    this.lastMessage = '',
    required this.lastMessageTime,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      photoUrl: map['photoUrl'],
      adminIds: List<String>.from(map['adminIds'] ?? []),
      members: List<String>.from(map['members'] ?? []),
      memberNames: Map<String, String>.from(map['memberNames'] ?? {}),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'adminIds': adminIds,
      'members': members,
      'memberNames': memberNames,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    List<String>? adminIds,
    List<String>? members,
    Map<String, String>? memberNames,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      adminIds: adminIds ?? this.adminIds,
      members: members ?? this.members,
      memberNames: memberNames ?? this.memberNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'GroupModel(id: $id, name: $name, members: ${members.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

