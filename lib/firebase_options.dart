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
    apiKey: 'AIzaSyABkXupmOBXJSzXqVXykk_49pKPBqXwcHc',
    appId: '1:1073456693110:web:1f694faa70b522d5930457',
    messagingSenderId: '1073456693110',
    projectId: 'patient-b3934',
    authDomain: 'patient-b3934.firebaseapp.com',
    storageBucket: 'patient-b3934.appspot.com',
    measurementId: 'G-SWWLSS5P5T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANQy9RN5v1gRQyDHcbrdicekKbxHbhRck',
    appId: '1:1073456693110:android:fd61c987a4efd267930457',
    messagingSenderId: '1073456693110',
    projectId: 'patient-b3934',
    storageBucket: 'patient-b3934.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpKJXhqO2CoAESzIwyygCPvS-jIE_lQTg',
    appId: '1:1073456693110:ios:963d477627a1a20a930457',
    messagingSenderId: '1073456693110',
    projectId: 'patient-b3934',
    storageBucket: 'patient-b3934.appspot.com',
    androidClientId: '1073456693110-kf4591sph8jj52k0e238bnk6jeg65oad.apps.googleusercontent.com',
    iosClientId: '1073456693110-pgn1l31q5ohuor9sio19750gl664qrns.apps.googleusercontent.com',
    iosBundleId: 'com.example.patientAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpKJXhqO2CoAESzIwyygCPvS-jIE_lQTg',
    appId: '1:1073456693110:ios:963d477627a1a20a930457',
    messagingSenderId: '1073456693110',
    projectId: 'patient-b3934',
    storageBucket: 'patient-b3934.appspot.com',
    androidClientId: '1073456693110-kf4591sph8jj52k0e238bnk6jeg65oad.apps.googleusercontent.com',
    iosClientId: '1073456693110-pgn1l31q5ohuor9sio19750gl664qrns.apps.googleusercontent.com',
    iosBundleId: 'com.example.patientAdmin',
  );
}