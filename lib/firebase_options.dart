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
    apiKey: 'AIzaSyA-MLTiNdwKy5yp62RBzKkZh1z0k1jGa8Y',
    appId: '1:290743157058:web:506b8a4cae5900178708db',
    messagingSenderId: '290743157058',
    projectId: 'cartscan-7ef23',
    authDomain: 'cartscan-7ef23.firebaseapp.com',
    databaseURL: 'https://cartscan-7ef23-default-rtdb.firebaseio.com',
    storageBucket: 'cartscan-7ef23.appspot.com',
    measurementId: 'G-1Q0YFPV4TL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJppevBqYOAwr5FPdi2sXbfrdUuxwD4_g',
    appId: '1:290743157058:android:7e71751e2fad772e8708db',
    messagingSenderId: '290743157058',
    projectId: 'cartscan-7ef23',
    databaseURL: 'https://cartscan-7ef23-default-rtdb.firebaseio.com',
    storageBucket: 'cartscan-7ef23.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5b8qNNISph5hIX6x8ojfsefN9upby5xA',
    appId: '1:290743157058:ios:c83356b2e5cc5a248708db',
    messagingSenderId: '290743157058',
    projectId: 'cartscan-7ef23',
    databaseURL: 'https://cartscan-7ef23-default-rtdb.firebaseio.com',
    storageBucket: 'cartscan-7ef23.appspot.com',
    iosClientId: '290743157058-prr6rns4en22ec0ib9lf2i15p3m3rpjp.apps.googleusercontent.com',
    iosBundleId: 'com.example.cartScan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5b8qNNISph5hIX6x8ojfsefN9upby5xA',
    appId: '1:290743157058:ios:7d0ee3ffbf5d77d68708db',
    messagingSenderId: '290743157058',
    projectId: 'cartscan-7ef23',
    databaseURL: 'https://cartscan-7ef23-default-rtdb.firebaseio.com',
    storageBucket: 'cartscan-7ef23.appspot.com',
    iosClientId: '290743157058-brkg0ik3vo5u952c92mj4gucleka1pe7.apps.googleusercontent.com',
    iosBundleId: 'com.example.cartScan.RunnerTests',
  );
}
