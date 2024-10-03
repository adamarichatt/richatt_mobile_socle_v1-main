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
    apiKey: 'AIzaSyDaRVkNMBNd5TIIXJ14KXHLao2Ez_hVShQ',
    appId: '1:209528276305:web:523ee5acd0573f2624ff70',
    messagingSenderId: '209528276305',
    projectId: 'remeet-f50dc',
    authDomain: 'remeet-f50dc.firebaseapp.com',
    storageBucket: 'remeet-f50dc.appspot.com',
    measurementId: 'G-NKYM1Y4QJH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDh1lEauKZcC2h9lsMsJqqDH4FS_s4CWCU',
    appId: '1:209528276305:android:12150e5ed2927b5d24ff70',
    messagingSenderId: '209528276305',
    projectId: 'remeet-f50dc',
    storageBucket: 'remeet-f50dc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCL2AtUkhr2rjDFF2Z_jz7FlaYIw6nclMU',
    appId: '1:209528276305:ios:412d6881607316ce24ff70',
    messagingSenderId: '209528276305',
    projectId: 'remeet-f50dc',
    storageBucket: 'remeet-f50dc.appspot.com',
    iosBundleId: 'com.example.richattMobileSocleV1',
  );
}
