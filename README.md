# Product Requirement Document (PRD): Flutter Notification Boilerplate

## Project Overview

### Scenario

A service-based tech company frequently develops mobile apps for multiple clients. One of the common features across these projects is push and local notifications. However, the development team spends significant time developing and implementing notification functionality from scratch for each project, despite the similarities across them. To streamline the process, the team aims to create a Flutter Notification Boilerplate that provides a reusable template for notification functionality, reducing development time and ensuring consistency across client projects.

### Objective

The objective of this project is to build a reusable Flutter boilerplate for managing notification functionalities such as push notifications, local notifications, FCM token handling, and managing app state during notification receipt. The boilerplate will standardize and simplify notification setup and management across projects, making it easy to integrate notification features into new or existing Flutter applications.

## Functional Requirements

### 1. Notification Initialization

#### Requirements

- Set up and configure notifications using Firebase Cloud Messaging (FCM)
- Ensure the correct Google Service file is configured for different environments (e.g., development, staging, production)
- Provide functionality to manage notification permissions across different platforms (Android, iOS)

#### Example Documentation

**FCM Setup:**

- Android: Requires Google Services JSON
- iOS: Requires Google Services PLIST and appropriate capabilities enabled (Push Notifications, Background Modes)

**Notification Permissions:**

- iOS: Request notification permission from the user and handle potential denial scenarios
- Android: Handle permissions automatically unless targeting newer versions that require runtime permissions

#### Example Code (Snippet for Permission Handling)

```dart
Future<void> requestNotificationPermissions() async {
  if (Platform.isIOS) {
    var settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // Handle permission denied
    }
  }
}
```

### 2. FCM Token Handling

#### Requirements

- Implement mechanisms to retrieve, handle, and send the FCM token to the backend
- Handle token updates and refreshes seamlessly, ensuring the app has the latest token for push notifications

#### Example Documentation

**Token Management:**

- Retrieve the FCM token on first app launch
- Listen for token updates using onTokenRefresh and send the new token to the backend

#### Example Code

```dart
FirebaseMessaging messaging = FirebaseMessaging.instance;
String? fcmToken = await messaging.getToken();

// Send token to backend
BackendService.sendTokenToServer(fcmToken);
```

### 3. Local Notification Setup

#### Requirements

- Provide functionality to configure and trigger local notifications within the app
- Local notifications should be triggered from the fcm when custom notifications are required

#### Example Documentation

- Use the flutter_local_notifications package for local notification scheduling and display
- Examples include reminders, timed notifications, or alerts triggered by user interactions

#### Example Code

```dart
void scheduleLocalNotification(DateTime scheduledTime, String message) {
  var androidDetails = AndroidNotificationDetails(...);
  var iOSDetails = IOSNotificationDetails(...);
  var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

  flutterLocalNotificationsPlugin.schedule(
    0, // Notification ID
    'Scheduled Notification',
    message,
    scheduledTime,
    platformDetails
  );
}
```

### 4. Handling Notifications in Different App States

#### Requirements

Define logic for handling notifications based on the app's state:

- App Open State: Manage whether to display notifications or handle them internally
- Background State: Ensure notifications are displayed and handled properly
- App Kill State: Handle notifications when the app is terminated and later opened

#### Example Documentation

- Foreground: Can choose to display an in-app alert, dismiss the notification silently, or handle it based on business logic
- Background & Killed State: Notifications should trigger the standard push behavior

#### Example Code

```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Handle notification when app is in the foreground
  print("Notification received while app is open: ${message.notification?.title}");
});

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Handle navigation on notification tap when the app is in the background
});
```

### 5. Notification Tap Actions

#### Requirements

- Centralize logic to handle tap actions on notifications
- Allow developers to configure the behavior when a notification is tapped, such as:
  - Simply opening the app
  - Navigating to specific screens with data from the notification
  - Passing notification data as arguments to the screen

#### Example Documentation

- Deep Linking: Use notification payload to determine which screen to open on tap

#### Example Code

```dart
void handleNotificationTap(RemoteMessage message) {
  if (message.data['screen'] == 'details') {
    // Navigate to details screen
    Navigator.pushNamed(context, '/details', arguments: message.data);
  } else {
    // Default to home screen
    Navigator.pushNamed(context, '/home');
  }
}
```

### 6. Structured Code for Easy Integration

#### Requirements

- Provide a modular code structure to make the notification logic easy to integrate into various app architectures
- Ensure that the code is well-organized and easy for developers to adapt for different projects

## Non-Functional Requirements

- **Maintainability**: The codebase must be well-documented and easy to modify for future notification-related changes
- **Performance**: Ensure that notification handling is optimized for both Android and iOS platforms
- **Security**: Handle FCM tokens securely, ensuring they are never exposed or misused
- **Adaptability**: The solution should be adaptable to different environments (dev, prod) with minimal configuration changes

## Expected Project Structure

```
lib/
├── main.dart  # Entry point of the Flutter app
├── core/
│   ├── notifications/
│   │   ├── notification_manager.dart  # Handles general notification logic and initialization
│   │   ├── fcm_service.dart  # Manages FCM-related operations like token handling
│   │   ├── local_notification_service.dart  # Handles local notification setup and management
│   │   ├── notification_handler.dart  # Logic for handling notifications in different app states
│   │   └── notification_actions.dart  # Handles tap actions and routing based on notification data
│   ├── platform/
│   │   ├── permissions_manager.dart  # Manages notification permissions on different platforms
│   └── api/
│       └── backend_service.dart  # Sends FCM tokens to the backend and manages API interactions
├── models/
│   └── notification_data_model.dart  # Data model to handle notification payloads
├── utils/
│   └── notification_helper.dart  # Utility functions related to notification processing
├── routes/
│   └── app_router.dart  # Handles navigation logic for notification tap actions
├── ui/
│   ├── screens/
│   │   ├── home_screen.dart  # Example home screen for app navigation
│   │   ├── notification_screen.dart  # Screen to display notification content based on tap action
│   └── widgets/
│       └── notification_widget.dart  # Widget to display notification content within the app
├── services/
│   └── push_notification_service.dart  # Service responsible for orchestrating notification logic
├── config/
│   ├── firebase_options.dart  # Firebase configuration file
│   ├── notification_config.dart  # Configurations for handling notification behavior
│   └── environment_config.dart  # Handles environment-specific configurations
└── data/
    └── repository/
        └── fcm_repository.dart  # Repository for managing FCM token storage and syncing
```

## Outcome

The Flutter Notification Boilerplate will streamline the process of integrating notifications into new and existing mobile applications. By providing a structured, reusable codebase, developers will save time, increase efficiency, and maintain consistency across projects, while reducing the likelihood of bugs or inconsistencies in notification implementations. The boilerplate should be easy to maintain, adaptable to various app architectures, and offer flexibility for future enhancements.
