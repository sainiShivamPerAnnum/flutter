import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.DEV,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.DEV,
          signzyStage: SignzyStage.PROD,
          baseUriUS: 'us-central1-fello-dev-station.cloudfunctions.net',
          baseUriAsia: 'asia-south1-fello-dev-station.cloudfunctions.net'));
  await mainInit();
  runApp(MyApp());
}
