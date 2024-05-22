import 'dart:async';

import 'package:felloapp/boot_strap.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/crashlytics_widget.dart';
import 'package:felloapp/util/flavor_config.dart';

Future<void> main() async {
  await bootStrap(() {
    FlavorConfig.configureProd();
    return const CrashlyticsApp(
      child: MyApp(),
    );
  });
}
