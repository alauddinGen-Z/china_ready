// This is a placeholder. 
// The user needs to run `flutterfire configure` or manually replace this file.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Return dummy options to prevent compilation errors if the file is missing
    // In a real scenario, these would be populated by the CLI
    return const FirebaseOptions(
      apiKey: 'DUMMY_API_KEY',
      appId: 'DUMMY_APP_ID',
      messagingSenderId: 'DUMMY_SENDER_ID',
      projectId: 'DUMMY_PROJECT_ID',
    );
  }
}
