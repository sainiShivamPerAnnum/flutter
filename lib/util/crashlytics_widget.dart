import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

const _kTestingCrashlytics = false;
const _isCrashlyticsEnabled = true;

class CrashlyticsApp extends StatefulWidget {
  final Widget child;

  const CrashlyticsApp({required this.child, Key? key}) : super(key: key);

  @override
  _CrashlyticsAppState createState() => _CrashlyticsAppState();
}

class _CrashlyticsAppState extends State<CrashlyticsApp> {
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    //await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(_isCrashlyticsEnabled);
    }

    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError!(errorDetails);
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFire();
  }
}
