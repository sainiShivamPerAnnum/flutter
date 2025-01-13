// import 'package:device_preview/device_preview.dart';
import 'package:felloapp/boot_strap.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'util/crashlytics_widget.dart';

Future<void> main() async {
  FlavorConfig.configureDev();
  await bootStrap(() {
    return const CrashlyticsApp(
      child: MyApp(),
    );
  });
}
