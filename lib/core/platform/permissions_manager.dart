import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionsManager {
  Future<void> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        // Handle permission denied
        print('Notification permissions denied');
      }
    }
    // For Android, permissions are handled in the manifest
  }
}
