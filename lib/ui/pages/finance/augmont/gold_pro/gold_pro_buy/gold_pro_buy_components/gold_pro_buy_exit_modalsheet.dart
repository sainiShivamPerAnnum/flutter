import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProBuyExitModalSheet extends StatefulWidget {
  const GoldProBuyExitModalSheet({Key? key}) : super(key: key);

  @override
  State<GoldProBuyExitModalSheet> createState() =>
      _GoldProBuyExitModalSheetState();
}

class _GoldProBuyExitModalSheetState extends State<GoldProBuyExitModalSheet> {
  final List<String> _sellingReasons = [];

  @override
  void initState() {
    _sellingReasons.addAll([
      "Need more information about ${Constants.ASSET_GOLD_STAKE}",
      "I want to change the lease amount",
      "Getting more returns elsewhere",
      "Not interested in the asset",
    ]);
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.backTappedOnGoldProOverView,
      properties: {"location": "Gold Pro Buy Over view"},
    );
    super.initState();
  }

  String selectedReasonForSelling = '';
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    setState(() {});
  }

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.padding32,
            ),
            TitleSubtitleContainer(
              title:
                  "You'll miss out on ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% extra returns",
              subTitle:
                  "Select any one option to help us improve your experience",
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              children: List.generate(
                  _sellingReasons.length,
                  (index) => RadioListTile(
                        toggleable: true,
                        activeColor: UiConstants.primaryColor,
                        tileColor: UiConstants.kTextColor,
                        selected: true,
                        value: index,
                        groupValue: _selectedIndex,
                        onChanged: (value) {
                          print(value);
                          selectedIndex = index;
                          selectedReasonForSelling = _sellingReasons[index];
                        },
                        title: Text(
                          _sellingReasons[index],
                          style: TextStyles.rajdhani.body2,
                        ),
                      )),
            ),
            MaterialButton(
              onPressed: () {
                AppState.isGoldProBuyInProgress = false;
                AppState.backButtonDispatcher!.didPopRoute();
                locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.backSurveyContinueTappedGoldPro,
                  properties: {
                    "option selected": _sellingReasons[selectedIndex]
                  },
                );
              },
              minWidth: SizeConfig.screenWidth! * 0.88,
              height: SizeConfig.padding44,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Text(
                "CONTINUE TO ${Constants.ASSET_GOLD_STAKE.toUpperCase()}",
                style: TextStyles.rajdhaniB.body1.colour(Colors.black),
              ),
            ),
            SizedBox(height: SizeConfig.padding12),
            TextButton(
              onPressed: () {
                AppState.isGoldProBuyInProgress = false;
                // AppState.backButtonDispatcher!.didPopRoute();
                AppState.backButtonDispatcher!.didPopRoute();
                AppState.backButtonDispatcher!.didPopRoute();
                locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.backSurveyGoBackTappedGoldPro,
                  properties: {
                    "option selected": _sellingReasons[selectedIndex]
                  },
                );
              },
              child: Text(
                "GO BACK",
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
