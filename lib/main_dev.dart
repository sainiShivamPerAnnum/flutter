import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.DEV,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.DEV,
          signzyStage: SignzyStage.PROD));
  mainInit();
  runApp(MyApp());
}
