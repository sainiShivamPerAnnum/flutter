import 'package:device_preview/device_preview.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.QA,
    color: Color(0xffa32638),
    values: FlavorValues(
      awsAugmontStage: AWSAugmontStage.PROD,
      awsIciciStage: AWSIciciStage.PROD,
      freshchatStage: FreshchatStage.DEV,
      razorpayStage: RazorpayStage.DEV,
      signzyStage: SignzyStage.PROD,
      signzyPanStage: SignzyPanStage.PROD,
      baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
      baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net',
      dynamicLinkPrefix: 'https://fello.in',
    ),
  );
  await mainInit();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}
