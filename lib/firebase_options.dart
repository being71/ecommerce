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
    apiKey: 'AIzaSyCMDVmz8KxDPp5G82FmqG_BpU4gVSjHOlo',
    appId: '1:55408493936:web:be30d9c269b4f81fbb7bb5',
    messagingSenderId: '55408493936',
    projectId: 'tokomu-ecee9',
    authDomain: 'tokomu-ecee9.firebaseapp.com',
    storageBucket: 'tokomu-ecee9.firebasestorage.app',
    measurementId: 'G-T1CG3JFMTQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCq-SXHkI5qyhj5nzY0lm3eZcMClvfnWkM',
    appId: '1:55408493936:android:069e542b1288d5c7bb7bb5',
    messagingSenderId: '55408493936',
    projectId: 'tokomu-ecee9',
    storageBucket: 'tokomu-ecee9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYyshc74qPCAhf3sruSngWCX5jxx4cd1U',
    appId: '1:55408493936:ios:f31aeca5f306f542bb7bb5',
    messagingSenderId: '55408493936',
    projectId: 'tokomu-ecee9',
    storageBucket: 'tokomu-ecee9.firebasestorage.app',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYyshc74qPCAhf3sruSngWCX5jxx4cd1U',
    appId: '1:55408493936:ios:f31aeca5f306f542bb7bb5',
    messagingSenderId: '55408493936',
    projectId: 'tokomu-ecee9',
    storageBucket: 'tokomu-ecee9.firebasestorage.app',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCMDVmz8KxDPp5G82FmqG_BpU4gVSjHOlo',
    appId: '1:55408493936:web:1b69a9697501363ebb7bb5',
    messagingSenderId: '55408493936',
    projectId: 'tokomu-ecee9',
    authDomain: 'tokomu-ecee9.firebaseapp.com',
    storageBucket: 'tokomu-ecee9.firebasestorage.app',
    measurementId: 'G-PS2WHL0DMC',
  );
}