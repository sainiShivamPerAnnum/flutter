import 'package:felloapp/main.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

void main() async{
  FlavorConfig(
      flavor: Flavor.PROD,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.PROD,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.PROD,
          signzyStage: SignzyStage.PROD));
  await mainInit();
  runApp(MyApp());
}
