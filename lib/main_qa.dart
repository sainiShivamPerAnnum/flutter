import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';

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
        paytmStage: PaytmStage.DEV,
        baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
        baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net',
        mixpanelToken: MixpanelAnalytics.PROD_TOKEN,
        dynamicLinkPrefix: 'https://fello.in',
        gameApiTokenSecret:
            "3565d165c367a0f1c615c27eb957dddfef33565b3f5ad1dda3fe2efd07326c1f",
        dummyMobileNo: '8888800002'),
  );
  await mainInit();
  runApp(
    // DevicePreview(
    // enabled: !kReleaseMode,
    // builder: (context) =>
    MyApp(), // Wrap your app
    // )
  );
}
