import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing a person in the app
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? status;
  final bool isOnline;
  final DateTime lastSeen;
  final String? fcmToken;
  final DateTime createdAt;
  final Map<String, dynamic> settings;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.status,
    this.isOnline = false,
    required this.lastSeen,
    this.fcmToken,
    required this.createdAt,
    this.settings = const {},
  });

  /// Convert from Firestore document snapshot
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      status: map['status'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmToken: map['fcmToken'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'settings': settings,
    };
  }

  /// Create a copy with modified fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? status,
    bool? isOnline,
    DateTime? lastSeen,
    String? fcmToken,
    DateTime? createdAt,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}

