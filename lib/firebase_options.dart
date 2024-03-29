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
    apiKey: 'AIzaSyDzzInxmZmVwoo0e9yeY7jgbsSJmKZyOZQ',
    appId: '1:321349819667:web:032d80b0f84ff9075ccee6',
    messagingSenderId: '321349819667',
    projectId: 'mechanix-26af9',
    authDomain: 'mechanix-26af9.firebaseapp.com',
    databaseURL: 'https://mechanix-26af9-default-rtdb.firebaseio.com',
    storageBucket: 'mechanix-26af9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAL4mGZHb_75vwhYn47e3DO0JeK0W-Erj0',
    appId: '1:321349819667:android:7d5d9c0ef91abcfa5ccee6',
    messagingSenderId: '321349819667',
    projectId: 'mechanix-26af9',
    databaseURL: 'https://mechanix-26af9-default-rtdb.firebaseio.com',
    storageBucket: 'mechanix-26af9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQyYdJAmx8EucLArCSlSe5QjSlC8IXmIw',
    appId: '1:321349819667:ios:f009e02e64299e585ccee6',
    messagingSenderId: '321349819667',
    projectId: 'mechanix-26af9',
    databaseURL: 'https://mechanix-26af9-default-rtdb.firebaseio.com',
    storageBucket: 'mechanix-26af9.appspot.com',
    iosClientId: '321349819667-l9tk0u7q97c9299kgnoo64fhm82m234h.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQyYdJAmx8EucLArCSlSe5QjSlC8IXmIw',
    appId: '1:321349819667:ios:ddd318b62f2892205ccee6',
    messagingSenderId: '321349819667',
    projectId: 'mechanix-26af9',
    databaseURL: 'https://mechanix-26af9-default-rtdb.firebaseio.com',
    storageBucket: 'mechanix-26af9.appspot.com',
    iosClientId: '321349819667-8d2ulvs737bcicd21bpgcv2r4r5861go.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientApp.RunnerTests',
  );
}
