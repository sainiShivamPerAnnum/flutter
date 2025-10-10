import 'package:felloapp/boot_strap.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/flavor_config.dart';

Future<void> main() async {
  FlavorConfig.configureQa();
  await bootStrap(() {
    return const MyApp();
  });
}
