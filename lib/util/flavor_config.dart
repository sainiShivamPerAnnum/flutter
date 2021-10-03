import 'package:felloapp/util/credentials_stage.dart';
import 'package:flutter/material.dart';

enum Flavor { DEV, QA, PROD }

class FlavorValues {
  FlavorValues(
      {@required this.awsIciciStage,
      @required this.awsAugmontStage,
      @required this.freshchatStage,
      @required this.signzyStage,
      @required this.signzyPanStage,
      @required this.razorpayStage,
      @required this.baseUriAsia,
      @required this.baseUriUS,
      @required this.dynamicLinkPrefix});

  final AWSIciciStage awsIciciStage;
  final FreshchatStage freshchatStage;
  final AWSAugmontStage awsAugmontStage;
  final SignzyStage signzyStage;
  final SignzyPanStage signzyPanStage;
  final RazorpayStage razorpayStage;
  final String baseUriAsia;
  final String baseUriUS;
  final String dynamicLinkPrefix;
//Add other flavor specific values, e.g database name
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig(
      {@required Flavor flavor,
      Color color: Colors.blue,
      @required FlavorValues values}) {
    _instance ??=
        FlavorConfig._internal(flavor, flavor.toString(), color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PROD;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;

  static bool isQA() => _instance.flavor == Flavor.QA;
}
