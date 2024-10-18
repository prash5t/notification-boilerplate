import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/backend_service.dart';

class FCMRepository {
  static const String _tokenKey = 'fcm_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> sendTokenToServer(String token) async {
    await BackendService.sendTokenToServer(token);
  }
}
