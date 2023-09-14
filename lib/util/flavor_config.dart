import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:flutter/material.dart';

enum Flavor { DEV, QA, PROD }

class FlavorValues {
  FlavorValues({
    required this.awsIciciStage,
    required this.awsAugmontStage,
    required this.freshchatStage,
    required this.signzyStage,
    required this.signzyPanStage,
    required this.razorpayStage,
    required this.paytmStage,
    required this.baseUriAsia,
    required this.baseUriUS,
    required this.dynamicLinkPrefix,
    required this.mixpanelToken,
    required this.gameApiTokenSecret,
    required this.dummyMobileNo,
  });

  final AWSIciciStage awsIciciStage;
  final FreshchatStage freshchatStage;
  final AWSAugmontStage awsAugmontStage;
  final SignzyStage signzyStage;
  final SignzyPanStage signzyPanStage;
  final RazorpayStage razorpayStage;
  final PaytmStage paytmStage;
  final String baseUriAsia;
  final String baseUriUS;
  final String dynamicLinkPrefix;
  final String mixpanelToken;
  final String gameApiTokenSecret;
  final String dummyMobileNo;
//Add other flavor specific values, e.g database name
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      required FlavorValues values,
      Color color = Colors.blue}) {
    _instance ??=
        FlavorConfig._internal(flavor, flavor.toString(), color, values);
    return _instance!;
  }

  factory FlavorConfig.configureQa() {
    return FlavorConfig(
      flavor: Flavor.QA,
      color: const Color(0xffa32638),
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
        dummyMobileNo: '8888800002',
      ),
    );
  }
  factory FlavorConfig.configureProd() {
    return FlavorConfig(
      flavor: Flavor.PROD,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
        awsAugmontStage: AWSAugmontStage.PROD,
        awsIciciStage: AWSIciciStage.PROD,
        freshchatStage: FreshchatStage.DEV,
        razorpayStage: RazorpayStage.PROD,
        signzyStage: SignzyStage.PROD,
        signzyPanStage: SignzyPanStage.PROD,
        paytmStage: PaytmStage.PROD,
        baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
        baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net',
        mixpanelToken: MixpanelAnalytics.PROD_TOKEN,
        dynamicLinkPrefix: 'https://fello.in',
        gameApiTokenSecret:
            "bb34f35f0a0f7424fb8a25708b58ec142df5216ff05ffbb186108744cd340c85",
        dummyMobileNo: '9999900002',
      ),
    );
  }
  factory FlavorConfig.configureDev() {
    return FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.green,
      values: FlavorValues(
        awsAugmontStage: AWSAugmontStage.DEV,
        awsIciciStage: AWSIciciStage.PROD,
        freshchatStage: FreshchatStage.DEV,
        razorpayStage: RazorpayStage.DEV,
        signzyStage: SignzyStage.PROD,
        signzyPanStage: SignzyPanStage.DEV,
        paytmStage: PaytmStage.DEV,
        baseUriUS: 'us-central1-fello-dev-station.cloudfunctions.net',
        baseUriAsia: 'asia-south1-fello-dev-station.cloudfunctions.net',
        mixpanelToken: MixpanelAnalytics.DEV_TOKEN,
        dynamicLinkPrefix: 'https://dev.fello.in/test',
        gameApiTokenSecret:
            "3565d165c367a0f1c615c27eb957dddfef33565b3f5ad1dda3fe2efd07326c1f",
        dummyMobileNo: '8888800002',
      ),
    );
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig? get instance {
    return _instance;
  }

  static bool isProduction() => _instance!.flavor == Flavor.PROD;

  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;

  static bool isQA() => _instance!.flavor == Flavor.QA;

  static String getStage() {
    switch (_instance!.flavor) {
      case Flavor.PROD:
        return 'prod';
      case Flavor.QA:
        return 'qa';
      case Flavor.DEV:
        return 'dev';
      default:
        return 'dev';
    }
  }
}
