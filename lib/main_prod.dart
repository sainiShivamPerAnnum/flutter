import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.PROD,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.PROD,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.PROD,
          signzyStage: SignzyStage.PROD,
          baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
          baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net'));
  await mainInit();
  runApp(MyApp());
}
