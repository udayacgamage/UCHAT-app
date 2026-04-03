/// Firestore collection and document path constants
class FirestorePaths {
  // Collections
  static const String users = 'users';
  static const String chats = 'chats';
  static const String messages = 'messages';
  static const String groups = 'groups';
  static const String typing = 'typing';

  // Build document paths
  static String userDoc(String uid) => '$users/$uid';
  
  static String chatDoc(String chatId) => '$chats/$chatId';
  
  static String messagesCollection(String chatId) => '$chats/$chatId/$messages';
  
  static String messageDoc(String chatId, String messageId) => 
      '$chats/$chatId/$messages/$messageId';
  
  static String typingCollection(String chatId) => '$chats/$chatId/$typing';
  
  static String typingDoc(String chatId, String uid) => 
      '$chats/$chatId/$typing/$uid';
  
  static String groupDoc(String groupId) => '$groups/$groupId';
  
  static String groupMessagesCollection(String groupId) => 
      '$groups/$groupId/$messages';
  
  static String groupMessageDoc(String groupId, String messageId) => 
      '$groups/$groupId/$messages/$messageId';
}

