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
    apiKey: 'AIzaSyC2wSiM1oHFKvqED-2XZImwH8CwxZVNz4k',
    appId: '1:672964775916:web:7c3ff0bc028b6b8a267ac9',
    messagingSenderId: '672964775916',
    projectId: 'expensesmanager-946b7',
    authDomain: 'expensesmanager-946b7.firebaseapp.com',
    storageBucket: 'expensesmanager-946b7.firebasestorage.app',
    measurementId: 'G-QEEY7HNBQZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMJYFaFa0WJIOFsyotYhEej9LyBCXxcfM',
    appId: '1:672964775916:android:eb92c7c7b7472d54267ac9',
    messagingSenderId: '672964775916',
    projectId: 'expensesmanager-946b7',
    storageBucket: 'expensesmanager-946b7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBC3YCk0H3QhUN18K7gOYGihLipx2cSxZQ',
    appId: '1:672964775916:ios:1526a312ef780ec0267ac9',
    messagingSenderId: '672964775916',
    projectId: 'expensesmanager-946b7',
    storageBucket: 'expensesmanager-946b7.firebasestorage.app',
    iosBundleId: 'com.shazlycode.expensesManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBC3YCk0H3QhUN18K7gOYGihLipx2cSxZQ',
    appId: '1:672964775916:ios:1526a312ef780ec0267ac9',
    messagingSenderId: '672964775916',
    projectId: 'expensesmanager-946b7',
    storageBucket: 'expensesmanager-946b7.firebasestorage.app',
    iosBundleId: 'com.shazlycode.expensesManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2wSiM1oHFKvqED-2XZImwH8CwxZVNz4k',
    appId: '1:672964775916:web:d4b6ba632e85c350267ac9',
    messagingSenderId: '672964775916',
    projectId: 'expensesmanager-946b7',
    authDomain: 'expensesmanager-946b7.firebaseapp.com',
    storageBucket: 'expensesmanager-946b7.firebasestorage.app',
    measurementId: 'G-NTR4S1B5NM',
  );
}
