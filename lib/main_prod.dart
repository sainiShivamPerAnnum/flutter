import 'dart:async';
import 'dart:developer';

import 'package:felloapp/main.dart';
import 'package:felloapp/util/crashlytics_widget.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/service/analytics/mixpanel_analytics.dart';

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
        signzyPanStage: SignzyPanStage.PROD,
        paytmStage: PaytmStage.PROD,
        baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
        baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net',
        mixpanelToken: MixpanelAnalytics.PROD_TOKEN,
        dynamicLinkPrefix: 'https://fello.in',
        gameApiTokenSecret:
            "bb34f35f0a0f7424fb8a25708b58ec142df5216ff05ffbb186108744cd340c85",
        dummyMobileNo: '9999900002'),
  );

  await mainInit();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runZonedGuarded(
        () => runApp(
              const CrashlyticsApp(
                child: MyApp(),
              ),
            ), (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      log(error.toString(), stackTrace: stackTrace);
    });
  });
}
