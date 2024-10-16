// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCA-gRa8_wx8yVgneTQFqak9sMdp-vgwOU',
    appId: '1:981464993936:web:3e93bcf037775353fec815',
    messagingSenderId: '981464993936',
    projectId: 'html-f0305',
    authDomain: 'html-f0305.firebaseapp.com',
    storageBucket: 'html-f0305.appspot.com',
    measurementId: 'G-B5EZWZT193',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQHO3LPa5faPlX2MufBMhs6L3b25SsNPU',
    appId: '1:981464993936:android:bc2fe5f8609e2345fec815',
    messagingSenderId: '981464993936',
    projectId: 'html-f0305',
    storageBucket: 'html-f0305.appspot.com',
  );

}