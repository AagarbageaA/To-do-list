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
    apiKey: 'AIzaSyBTszw-VKGf0AoDzumYKApJUEsAHxHcNUE',
    appId: '1:133698693745:web:7510514626589d9ba389d0',
    messagingSenderId: '133698693745',
    projectId: 'to-do-list-53020',
    authDomain: 'to-do-list-53020.firebaseapp.com',
    databaseURL: 'https://to-do-list-53020-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'to-do-list-53020.appspot.com',
    measurementId: 'G-TW6V547XNQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrMeuKrVAmG-nWAdXw83RyiUGw4MeQy8g',
    appId: '1:133698693745:android:439a803df074085ea389d0',
    messagingSenderId: '133698693745',
    projectId: 'to-do-list-53020',
    databaseURL: 'https://to-do-list-53020-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'to-do-list-53020.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAql1H4IwfTnf40X8pRN6gwcNtzSwg2dMI',
    appId: '1:133698693745:ios:2059035304320b0ca389d0',
    messagingSenderId: '133698693745',
    projectId: 'to-do-list-53020',
    databaseURL: 'https://to-do-list-53020-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'to-do-list-53020.appspot.com',
    iosClientId: '133698693745-r0t4vtsnii0jtjdlj3t1hthutovf4350.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplicationTemplate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAql1H4IwfTnf40X8pRN6gwcNtzSwg2dMI',
    appId: '1:133698693745:ios:ff08841b6c44c631a389d0',
    messagingSenderId: '133698693745',
    projectId: 'to-do-list-53020',
    databaseURL: 'https://to-do-list-53020-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'to-do-list-53020.appspot.com',
    iosClientId: '133698693745-amo2uj5clmb8fhi0of0nj369h8a2ehdf.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplicationTemplate.RunnerTests',
  );
}
