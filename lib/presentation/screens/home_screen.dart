import 'package:flutter/material.dart';
import '../../core/notifications/notification_manager.dart';
import '../../core/navigation/navigation_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Flutter Notification Boilerplate'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? token = await NotificationManager().getFCMToken();
                debugPrint('FCM Token: $token');
                if (NavigationService.context != null) {
                  ScaffoldMessenger.of(NavigationService.context!).showSnackBar(
                    SnackBar(content: Text('FCM Token: $token')),
                  );
                }
              },
              child: Text('Get FCM Token'),
            ),
          ],
        ),
      ),
    );
  }
}
