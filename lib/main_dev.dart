import 'package:device_preview/device_preview.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.green,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.DEV,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.DEV,
          signzyStage: SignzyStage.PROD,
          signzyPanStage: SignzyPanStage.DEV,
          baseUriUS: 'us-central1-fello-dev-station.cloudfunctions.net',
          baseUriAsia: 'asia-south1-fello-dev-station.cloudfunctions.net',
           mixpanelToken: MixpanelService.DEV_TOKEN,
          dynamicLinkPrefix: 'https://dev.fello.in/test'));
  await mainInit();
  runApp(MyApp());
}
