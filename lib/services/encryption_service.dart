import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import '../core/utils/logger.dart';
import '../core/errors/app_exception.dart';

/// Encryption service for AES-256 message encryption/decryption
class EncryptionService {
  final _secureStorage = const FlutterSecureStorage();

  /// Generate a deterministic encryption key from two user IDs
  /// Both users will derive the same key from their user IDs
  String _generateKeyFromUserIds(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    final combined = sortedIds.join('|');
    return sha256.convert(utf8.encode(combined)).toString().substring(0, 32);
  }

  /// Generate and store encryption key for a chat
  /// This should be called once when a chat is created
  Future<void> generateAndStoreChatKey(String chatId, String userId1, String userId2) async {
    try {
      // Check if key already exists
      final existing = await getChatKey(chatId);
      if (existing != null) {
        AppLogger.debug('Key already exists for chat $chatId');
        return;
      }

      // Generate deterministic key from user IDs
      final keyString = _generateKeyFromUserIds(userId1, userId2);
      
      // Store in secure storage
      await _secureStorage.write(
        key: 'chat_key_$chatId',
        value: keyString,
      );
      
      AppLogger.success('Generated and stored key for chat $chatId');
    } catch (e, st) {
      AppLogger.error('Failed to generate chat key: $e', st);
      throw AppException(
        message: 'Failed to generate encryption key',
        originalException: e,
      );
    }
  }

  /// Retrieve encryption key for a chat from secure storage
  Future<String?> getChatKey(String chatId) async {
    try {
      final key = await _secureStorage.read(key: 'chat_key_$chatId');
      return key;
    } catch (e, st) {
      AppLogger.error('Failed to retrieve chat key: $e', st);
      return null;
    }
  }

  /// Encrypt message content using AES-256-CBC
  /// Returns base64-encoded string with IV prepended
  Future<String> encryptMessage(String plainText, String chatId) async {
    try {
      final keyString = await getChatKey(chatId);
      if (keyString == null) {
        throw AppException(
          message: 'Encryption key not found for chat $chatId',
        );
      }

      // Create key from string
      final key = encrypt.Key.fromUtf8(keyString);
      
      // Generate random IV
      final iv = encrypt.IV.fromSecureRandom(16);
      
      // Create encrypter
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );
      
      // Encrypt
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      
      // Prepend IV to ciphertext and encode as base64
      // Format: base64(iv + ciphertext)
      final combined = iv.bytes + encrypted.bytes;
      final result = base64.encode(combined);
      
      AppLogger.debug('Encrypted message for chat $chatId');
      return result;
    } catch (e, st) {
      AppLogger.error('Encryption failed: $e', st);
      rethrow;
    }
  }

  /// Decrypt message content
  /// Expects base64-encoded string with IV prepended
  Future<String> decryptMessage(String cipherText, String chatId) async {
    try {
      final keyString = await getChatKey(chatId);
      if (keyString == null) {
        throw AppException(
          message: 'Encryption key not found for chat $chatId',
        );
      }

      // Create key from string
      final key = encrypt.Key.fromUtf8(keyString);
      
      // Decode from base64
      final combined = base64.decode(cipherText);
      
      // Extract IV (first 16 bytes) and ciphertext (remaining bytes)
      final iv = encrypt.IV(combined.sublist(0, 16));
      final encrypted = combined.sublist(16);
      
      // Create encrypter
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );
      
      // Decrypt
      final decrypted = encrypter.decrypt(
        encrypt.Encrypted(encrypted),
        iv: iv,
      );
      
      AppLogger.debug('Decrypted message for chat $chatId');
      return decrypted;
    } catch (e, st) {
      AppLogger.error('Decryption failed: $e', st);
      rethrow;
    }
  }

  /// Clear all stored keys (for logout, etc.)
  Future<void> clearAllKeys() async {
    try {
      // Get all keys and filter chat keys
      final allKeys = await _secureStorage.readAll();
      for (final key in allKeys.keys) {
        if (key.startsWith('chat_key_')) {
          await _secureStorage.delete(key: key);
        }
      }
      AppLogger.success('Cleared all encryption keys');
    } catch (e, st) {
      AppLogger.error('Failed to clear keys: $e', st);
    }
  }
}

