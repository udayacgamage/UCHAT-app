import 'package:firebase_messaging/firebase_messaging.dart';
import '../core/utils/logger.dart';

/// FCM notification service
class NotificationService {
  FirebaseMessaging? _messaging;

  /// Initialize FCM
  Future<void> initFCM() async {
    try {
      AppLogger.info('Initializing FCM');
      _messaging = FirebaseMessaging.instance;

      // Request notification permission
      final settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.info('FCM permission status: ${settings.authorizationStatus}');

      // Get FCM token
      if (_messaging != null) {
        final token = await _messaging!.getToken();
        AppLogger.info('FCM Token: ${token?.substring(0, 20)}...');
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message tap
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      AppLogger.success('FCM initialized');
    } catch (e, st) {
      AppLogger.error('FCM initialization failed: $e', st);
    }
  }

  /// Handle foreground notification
  void _handleForegroundMessage(RemoteMessage message) {
    try {
      AppLogger.info('Foreground message received: ${message.notification?.title}');

      final data = message.data;
      final chatId = data['chatId'];
      final senderName = data['senderName'];
      final messageBody = message.notification?.body ?? 'New message';

      // You can trigger navigation here if needed
      // For now, just log it
      AppLogger.debug('Message from: $senderName, Chat: $chatId');
    } catch (e, st) {
      AppLogger.error('Error handling foreground message: $e', st);
    }
  }

  /// Handle notification tap (app in background)
  void _handleMessageTap(RemoteMessage message) {
    try {
      AppLogger.info('Notification tapped: ${message.notification?.title}');

      final data = message.data;
      final chatId = data['chatId'];

      // Navigate to chat screen
      // This will be handled by GoRouter via deep linking
      AppLogger.debug('Navigate to chat: $chatId');
    } catch (e, st) {
      AppLogger.error('Error handling message tap: $e', st);
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      if (_messaging == null) return null;
      return await _messaging!.getToken();
    } catch (e, st) {
      AppLogger.error('Failed to get FCM token: $e', st);
      return null;
    }
  }

  /// Subscribe to a topic (for group notifications)
  Future<void> subscribeToTopic(String topic) async {
    try {
      if (_messaging == null) return;
      await _messaging!.subscribeToTopic(topic);
      AppLogger.success('Subscribed to topic: $topic');
    } catch (e, st) {
      AppLogger.error('Failed to subscribe to topic: $e', st);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      if (_messaging == null) return;
      await _messaging!.unsubscribeFromTopic(topic);
      AppLogger.success('Unsubscribed from topic: $topic');
    } catch (e, st) {
      AppLogger.error('Failed to unsubscribe from topic: $e', st);
    }
  }
}

