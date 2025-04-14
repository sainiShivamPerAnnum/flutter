import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/model/sdui/sdui_parsers/animated_container/animated_container_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/animated_switcher/animated_switcher_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/app_image/app_image_wiget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/base_scaffold/base_scaffold_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/bloc_parser/bloc_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/cached_network_image/cached_network_image_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/carousel/carousel_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/clip_rrect/clip_rrect_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/divider/divider_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/dynamic_view/dynamic_view_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/fractional_translation/fractional_translation_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/gestureDetector/gesture_detector_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/responsiveContainer/resposive_container_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/spacer/spacer_widget_parser.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/transform/translate_widget_parser.dart';
import 'package:felloapp/core/service/fcm/background_fcm_handler.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/local_actions_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:stac/stac.dart';

typedef BootstrapCallBack = Widget Function();

Future<void> bootStrap(BootstrapCallBack bootStrapCallBack) async {
  runZoned<void>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterBranchSdk.init(
        useTestKey: FlavorConfig.isDevelopment() || FlavorConfig.isQA(),
      );
      if (FlavorConfig.isDevelopment() || FlavorConfig.isQA()) {
        FlutterBranchSdk.validateSDKIntegration();
      }
      try {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        );
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
        );
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
        );
      } catch (e) {
        log('Failed to bootstrap app, error: $e');
      }
      await Stac.initialize(
        parsers: [
          // const StacWebViewParser(),
          const AnimatedContainerWidgetParser(),
          const AnimatedSwitcherWidgetParser(),
          const AppImageWidgetParser(),
          const BaseScaffoldWidgetParser(),
          const BlocWidgetParser(),
          const CachedNetworkImageWidgetParser(),
          const CarouselWidgetParser(),
          const ClipRRectWidgetParser(),
          const DividerWidgetParser(),
          const CustomDynamicViewParser(),
          const FractionalTranslationWidgetParser(),
          const GestureDetectorParser(),
          const ResponsiveContainerParser(),
          const SpacerWidgetParser(),
          const TransformWidgetParser(),
        ],
        actionParsers: [],
      );

      await setupLocator();

      try {
        await PreferenceHelper.initiate();
        await LocalActionsState.cleanupCache();
        await Firebase.initializeApp();
      } catch (e) {
        log('Failed to bootstrap app, error: $e');
      }

      try {
        FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
      } catch (e) {
        log('Failed to bootstrap app, error: $e');
      }

      // For runApp and bootStrapCallBack is called inside the same zone.
      final Widget app = bootStrapCallBack();

      // Run app.
      return runApp(app);
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        // This assert block will be removed in release build due to tree-shaking.
        assert(() {
          zone.parent?.print(line);
          return true;
        }());
      },
    ),
  );
}
