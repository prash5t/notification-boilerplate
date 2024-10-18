import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/repository/fcm_repository.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FCMRepository _fcmRepository = FCMRepository();

  Future<void> initialize() async {
    // Get the token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _handleToken(token);
    }

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen(_handleToken);
  }

  Future<void> _handleToken(String token) async {
    // Save the token locally
    await _fcmRepository.saveToken(token);

    // Send the token to your backend
    await _fcmRepository.sendTokenToServer(token);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
