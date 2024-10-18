import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6T532bVZsUjw1SwDQQH97ZLJedUZwzMU',
    appId: '1:657055111475:android:aa49093ef4aa6378240646',
    messagingSenderId: '657055111475',
    projectId: 'postreal-2b7dd',
    storageBucket: 'postreal-2b7dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQhFNzoYDbPXK6NzDSfuTqAsDXHQ3T20I',
    appId: '1:657055111475:ios:eb924e09beb51c5e240646',
    messagingSenderId: '657055111475',
    projectId: 'postreal-2b7dd',
    storageBucket: 'postreal-2b7dd.appspot.com',
    iosClientId:
        '657055111475-ou5kc2kafv5n3jdq2r108pk4lk5egceg.apps.googleusercontent.com',
    iosBundleId: 'com.awarself.postreal',
  );
}
