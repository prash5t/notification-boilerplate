import '../core/notifications/notification_manager.dart';
import '../core/notifications/fcm_service.dart';
import '../core/notifications/local_notification_service.dart';

class PushNotificationService {
  final NotificationManager _notificationManager = NotificationManager();
  final FCMService _fcmService = FCMService();
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  Future<void> initialize() async {
    await _notificationManager.initialize();
  }

  Future<String?> getFCMToken() async {
    return await _fcmService.getToken();
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationType? type,
  }) async {
    await _localNotificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      type: type ?? NotificationType.other,
    );
  }
}
