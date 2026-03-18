import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level handler for background FCM messages (must be a top-level function).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are processed here without Flutter context.
  // Heavy initialization is deferred to the foreground handler.
  debugPrint('[FCM] Background message: ${message.messageId}');
}

/// Service that initialises Firebase Cloud Messaging (FCM) and local
/// notifications, and provides a stream of deep-link destinations when the
/// user taps a notification (NOTIF-03).
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  /// Android high-importance notification channel.
  static const _androidChannel = AndroidNotificationChannel(
    'relay_messages',
    'Relay Messages',
    description: 'Notifications for new messages and mentions',
    importance: Importance.high,
  );

  /// Callback invoked when a notification tap results in a route destination
  /// (e.g. '/app/workspace-id/channel-id').
  ValueChanged<String>? onNavigate;

  Future<void> init() async {
    // Register background handler before anything else.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission (iOS/macOS).
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Create Android channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Initialise local notifications.
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Handle foreground FCM messages by showing a local notification.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Handle notification tap when app is in background (resumed).
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Handle notification tap that launched the app from terminated state.
    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      _handleNavigationPayload(initial.data);
    }

    // Register the FCM token with our backend.
    final token = await _fcm.getToken();
    if (token != null) {
      debugPrint('[FCM] Token: $token');
      _registerToken(token);
    }
    _fcm.onTokenRefresh.listen(_registerToken);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: _payloadFrom(message.data),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleNavigationPayload(message.data);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && onNavigate != null) {
      onNavigate!(payload);
    }
  }

  void _handleNavigationPayload(Map<String, dynamic> data) {
    final route = _routeFromData(data);
    if (route != null && onNavigate != null) {
      onNavigate!(route);
    }
  }

  String? _routeFromData(Map<String, dynamic> data) {
    final workspaceId = data['workspaceId'] as String?;
    final channelId = data['channelId'] as String?;
    final dmChannelId = data['dmChannelId'] as String?;
    final threadId = data['threadId'] as String?;

    if (dmChannelId != null) return '/app/dm/$dmChannelId';
    if (workspaceId != null && channelId != null && threadId != null) {
      return '/app/thread/$threadId';
    }
    if (workspaceId != null && channelId != null) {
      return '/app/$workspaceId/$channelId';
    }
    return null;
  }

  String _payloadFrom(Map<String, dynamic> data) {
    return _routeFromData(data) ?? '';
  }

  void _registerToken(String token) {
    // Fire-and-forget: POST the device token to the backend.
    // The HTTP client is not available here (no BuildContext), so we rely on
    // the app shell to call registerDeviceToken() on startup.
    debugPrint('[FCM] Token registered: $token (pending backend sync)');
  }

  /// Called from the app shell after the HTTP client is available to register
  /// the current device FCM token with the backend.
  Future<String?> getToken() => _fcm.getToken();
}
