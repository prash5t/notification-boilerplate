import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum NotificationType { message, broadcast, other }

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Dio _dio = Dio();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationType type,
    String? imageUrl,
    String? payload,
  }) async {
    switch (type) {
      case NotificationType.message:
        await _showMessageNotification(id, title, body, imageUrl, payload);
        break;
      case NotificationType.broadcast:
        await _showBroadcastNotification(id, title, body, payload);
        break;
      case NotificationType.other:
        await _showDefaultNotification(id, title, body, payload);
        break;
    }
  }

  Future<void> _showMessageNotification(
    int id,
    String title,
    String body,
    String? imageUrl,
    String? payload,
  ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'message_channel',
      'Message Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    if (imageUrl != null) {
      final String largeIconPath =
          await _downloadAndSaveFile(imageUrl, 'largeIcon');
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        androidPlatformChannelSpecifics.channelId,
        androidPlatformChannelSpecifics.channelName,
        channelDescription: androidPlatformChannelSpecifics.channelDescription,
        importance: androidPlatformChannelSpecifics.importance,
        priority: androidPlatformChannelSpecifics.priority,
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(largeIconPath),
          hideExpandedLargeIcon: true,
        ),
      );
    }

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> _showBroadcastNotification(
    int id,
    String title,
    String body,
    String? payload,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'broadcast_channel',
      'Broadcast Notifications',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF4CAF50), // Green color for broadcast
      ledColor: Color(0xFF4CAF50),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> _showDefaultNotification(
    int id,
    String title,
    String body,
    String? payload,
  ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await _dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }
}
