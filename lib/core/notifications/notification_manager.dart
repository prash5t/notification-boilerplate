import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../platform/permissions_manager.dart';
import '../../config/firebase_options.dart';
import 'fcm_service.dart';
import 'local_notification_service.dart';
import '../../routes/app_router.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  late final FCMService _fcmService;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  Future<void> initialize() async {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Now that Firebase is initialized, we can create the FCMService
    _fcmService = FCMService();

    await PermissionsManager().requestNotificationPermissions();
    await _localNotificationService.initialize();

    // Set up foreground notification handling
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize FCM service
    await _fcmService.initialize();

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> getFCMToken() async {
    return await _fcmService.getToken();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Foreground Message received: ${message.notification?.title}");

    NotificationType type = _getNotificationType(message);

    _localNotificationService.showNotification(
      id: message.hashCode,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      type: type,
      imageUrl: message.data['imageUrl'],
      payload: message.data.toString(),
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Background Message opened: ${message.notification?.title}");
    AppRouter.handleNotificationNavigation(message.data);
  }

  NotificationType _getNotificationType(RemoteMessage message) {
    if (message.data['type'] == 'message') {
      return NotificationType.message;
    } else if (message.data['type'] == 'broadcast') {
      return NotificationType.broadcast;
    } else {
      return NotificationType.other;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // You can perform some background tasks here if needed
}
