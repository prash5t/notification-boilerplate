import 'package:flutter/material.dart';
import 'core/notifications/notification_manager.dart';
import 'routes/app_router.dart';
import 'routes/route_constants.dart';
import 'core/navigation/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationManager().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Boilerplate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: RouteConstants.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
