// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBAF7W0DGoK0TcY9US_6rmLtpS-Oce2Obc',
    appId: '1:670622265379:web:efbae4cabc4dfd3291c196',
    messagingSenderId: '670622265379',
    projectId: 'firebase-notes-freecodecamp',
    authDomain: 'fir-notes-freecodecamp.firebaseapp.com',
    storageBucket: 'firebase-notes-freecodecamp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBc6pRAYVI-vBLPrfi07b8Nvn2-9DM5ysY',
    appId: '1:670622265379:android:de2fb7cffea7e6cb91c196',
    messagingSenderId: '670622265379',
    projectId: 'firebase-notes-freecodecamp',
    storageBucket: 'firebase-notes-freecodecamp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJRKBRZmU7_GnxLblPz7jQrkthW5hfUew',
    appId: '1:670622265379:ios:5762a850b54aa50491c196',
    messagingSenderId: '670622265379',
    projectId: 'firebase-notes-freecodecamp',
    storageBucket: 'firebase-notes-freecodecamp.appspot.com',
    iosBundleId: 'com.example.mynotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJRKBRZmU7_GnxLblPz7jQrkthW5hfUew',
    appId: '1:670622265379:ios:5762a850b54aa50491c196',
    messagingSenderId: '670622265379',
    projectId: 'firebase-notes-freecodecamp',
    storageBucket: 'firebase-notes-freecodecamp.appspot.com',
    iosBundleId: 'com.example.mynotes',
  );
}
