import 'package:flutter/material.dart';
import 'route_constants.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/details_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../core/navigation/navigation_service.dart';

class AppRouter {
  static void handleNotificationNavigation(Map<String, dynamic> data) {
    final String? screenName = data['screen'] as String?;
    if (screenName != null && _routes.containsKey(screenName)) {
      NavigationService.navigateTo(_routes[screenName]!, arguments: data);
    } else {
      // Default to home if no valid screen name is provided
      NavigationService.navigateTo(RouteConstants.home);
    }
  }

  static final Map<String, String> _routes = {
    'home': RouteConstants.home,
    'details': RouteConstants.details,
    'settings': RouteConstants.settings,
    'profile': RouteConstants.profile,
    // Add more mappings as needed
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteConstants.details:
        return MaterialPageRoute(
            builder: (_) => DetailsScreen(
                args: settings.arguments as Map<String, dynamic>?));
      case RouteConstants.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case RouteConstants.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
