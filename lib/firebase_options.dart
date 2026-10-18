// File generated for Velix Firebase configuration
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with Velix Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyBoDLECliAESAQGtkXONx_vABe70xtAyj0',
          appId: '1:1049388593625:android:98872e5426c344a0de29c8',
          messagingSenderId: '1049388593625',
          projectId: 'velix-f3831',
          storageBucket: 'velix-f3831.firebasestorage.app',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDn7VUCB5GrzZoaQJOPBUo9n7eMDPck2Mc',
    appId: '1:1049388593625:ios:a12fe7247bc55d1dde29c8',
    messagingSenderId: '1049388593625',
    projectId: 'velix-f3831',
    storageBucket: 'velix-f3831.firebasestorage.app',
    iosBundleId: 'app.getvelix.velix',
  );
}
