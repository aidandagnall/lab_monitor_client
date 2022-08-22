// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtZYDiYNZCS9jeq_Y-00tQomNRuo7nbcE',
    appId: '1:814424762393:web:179c7972f46bb1a1be6288',
    messagingSenderId: '814424762393',
    projectId: 'lab-availability',
    authDomain: 'lab-availability.firebaseapp.com',
    databaseURL:
        'https://lab-availability-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'lab-availability.appspot.com',
    measurementId: 'G-C6S4CM0GQQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7gD76ty6gyVPutEY60xK09zwguA0f8I4',
    appId: '1:814424762393:android:31a51efe152808bfbe6288',
    messagingSenderId: '814424762393',
    projectId: 'lab-availability',
    databaseURL:
        'https://lab-availability-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'lab-availability.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZTnDcliQBjlH4KoiXECKm3kttb0ppOV4',
    appId: '1:814424762393:ios:6d2ff84f1accc373be6288',
    messagingSenderId: '814424762393',
    projectId: 'lab-availability',
    databaseURL:
        'https://lab-availability-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'lab-availability.appspot.com',
    iosClientId:
        '814424762393-g452elsq6m75876h950dj4c561tvcbci.apps.googleusercontent.com',
    iosBundleId: 'com.dagnall.labchecker',
  );
}
