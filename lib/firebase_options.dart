import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lipro_mobile/app/encryptString.dart';  // Import the encryptString.dart

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions android = FirebaseOptions(
    apiKey: decryptString(dotenv.env['FIREBASE_API_KEY']!, dotenv.env['AES_SECRET_KEY']!),  // Decrypt the API Key
    appId: decryptString(dotenv.env['FIREBASE_APP_ID']!, dotenv.env['AES_SECRET_KEY']!),  // Decrypt the App ID
    messagingSenderId: decryptString(dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!, dotenv.env['AES_SECRET_KEY']!),  // Decrypt the Messaging Sender ID
    projectId: decryptString(dotenv.env['FIREBASE_PROJECT_ID']!, dotenv.env['AES_SECRET_KEY']!),  // Decrypt the Project ID
    storageBucket: decryptString(dotenv.env['FIREBASE_STORAGE_BUCKET']!, dotenv.env['AES_SECRET_KEY']!),  // Decrypt the Storage Bucket
  );
}
