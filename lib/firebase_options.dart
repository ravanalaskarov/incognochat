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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAhN5JbV-oEpUmbVe6zG8uYb6D1KhYib5k',
    appId: '1:638060826948:web:465dd57854e7e819570711',
    messagingSenderId: '638060826948',
    projectId: 'incognochat',
    authDomain: 'incognochat.firebaseapp.com',
    storageBucket: 'incognochat.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDua-h_grCbD1NvmzJGeBTrd0XCyENJ4EY',
    appId: '1:638060826948:android:0f2d43ce3bc993d4570711',
    messagingSenderId: '638060826948',
    projectId: 'incognochat',
    storageBucket: 'incognochat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3xFhtol0asq-LtSnZhJruWkpyj42Fnrg',
    appId: '1:638060826948:ios:52fab3b4c8e514e9570711',
    messagingSenderId: '638060826948',
    projectId: 'incognochat',
    storageBucket: 'incognochat.appspot.com',
    iosBundleId: 'com.example.incognochat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3xFhtol0asq-LtSnZhJruWkpyj42Fnrg',
    appId: '1:638060826948:ios:52fab3b4c8e514e9570711',
    messagingSenderId: '638060826948',
    projectId: 'incognochat',
    storageBucket: 'incognochat.appspot.com',
    iosBundleId: 'com.example.incognochat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhN5JbV-oEpUmbVe6zG8uYb6D1KhYib5k',
    appId: '1:638060826948:web:6ffc3615cbe52705570711',
    messagingSenderId: '638060826948',
    projectId: 'incognochat',
    authDomain: 'incognochat.firebaseapp.com',
    storageBucket: 'incognochat.appspot.com',
  );
}