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
    apiKey: 'AIzaSyCblndUBPO0x1FtPlmhMwOoEi05A8rMv8Q',
    appId: '1:522578711627:web:5f0b68405c2149fec729ce',
    messagingSenderId: '522578711627',
    projectId: 'your-place-v1',
    authDomain: 'your-place-v1.firebaseapp.com',
    storageBucket: 'your-place-v1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVjoiQ7-xD7a7iCQMzavzyQ5pnmOR2tEE',
    appId: '1:522578711627:android:f3d3c1432aa90ccfc729ce',
    messagingSenderId: '522578711627',
    projectId: 'your-place-v1',
    storageBucket: 'your-place-v1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbk1BMk8y-vcPFNvLn12ISxz-JNWzRwCM',
    appId: '1:522578711627:ios:db6441d94cb04123c729ce',
    messagingSenderId: '522578711627',
    projectId: 'your-place-v1',
    storageBucket: 'your-place-v1.appspot.com',
    iosBundleId: 'com.example.yourplace',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbk1BMk8y-vcPFNvLn12ISxz-JNWzRwCM',
    appId: '1:522578711627:ios:db6441d94cb04123c729ce',
    messagingSenderId: '522578711627',
    projectId: 'your-place-v1',
    storageBucket: 'your-place-v1.appspot.com',
    iosBundleId: 'com.example.yourplace',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCblndUBPO0x1FtPlmhMwOoEi05A8rMv8Q',
    appId: '1:522578711627:web:58ea61c0a79c1a44c729ce',
    messagingSenderId: '522578711627',
    projectId: 'your-place-v1',
    authDomain: 'your-place-v1.firebaseapp.com',
    storageBucket: 'your-place-v1.appspot.com',
  );
}
