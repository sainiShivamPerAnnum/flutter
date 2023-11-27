import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AutoSaveSurvey extends HookWidget {
  const AutoSaveSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);
    final reason = useMemoized(
      () {
        switch (selectedOption.value) {
          case 1:
            return "Wanted to edit the amount for the autosave";
          case 2:
            return "Wanted to change the asset";
          case 3:
            return "Changed my mind";
          case 4:
            return "Just came here to explore";
          default:
            return "";
        }
      },
      [selectedOption.value],
    );
    return WillPopScope(
      onWillPop: () async {
        if (AppState.screenStack.last == ScreenItem.dialog) {
          AppState.screenStack.removeLast();
        }
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.asSurveyGoBackTapped,
            properties: {
              'reason': reason,
            });
        return Future.value(true);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.padding16),
                topRight: Radius.circular(SizeConfig.padding16),
              ),
            ),
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
                vertical: SizeConfig.padding24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Why did you not setup your Autosave?",
                  style: TextStyles.rajdhaniSB.body1,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.padding4),
                Text("Select any of the below options",
                    style: TextStyles.sourceSans.body4
                        .colour(Colors.white.withOpacity(0.6))),
                SizedBox(height: SizeConfig.padding32),
                _OptionContainer(
                  title: "Wanted to edit the amount for the autosave",
                  isSelected: selectedOption.value == 1,
                  onTap: () {
                    selectedOption.value = 1;
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                _OptionContainer(
                  title: "Wanted to change the asset",
                  isSelected: selectedOption.value == 2,
                  onTap: () {
                    selectedOption.value = 2;
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                _OptionContainer(
                  title: "Changed my mind",
                  isSelected: selectedOption.value == 3,
                  onTap: () {
                    selectedOption.value = 3;
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                _OptionContainer(
                  title: "Just came here to explore",
                  isSelected: selectedOption.value == 4,
                  onTap: () {
                    selectedOption.value = 4;
                  },
                ),
                SizedBox(height: SizeConfig.padding24),
                MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
                  minWidth: SizeConfig.screenWidth,
                  onPressed: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                    locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.asSurveyContinueTapped,
                        properties: {
                          'reason': reason,
                        });
                  },
                  child: Text(
                    "CONTINUE WITH AUTOSAVE",
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                        AppState.backButtonDispatcher!.didPopRoute();
                        locator<AnalyticsService>().track(
                            eventName: AnalyticsEvents.asSurveyGoBackTapped,
                            properties: {
                              'reason': reason,
                            });
                      },
                      child: Text('GO BACK', style: TextStyles.rajdhaniB.body1),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              onTap: () {
                AppState.backButtonDispatcher!.didPopRoute();
                locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.asSurveyGoBackTapped,
                    properties: {
                      'reason': reason,
                    });
              },
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionContainer extends StatelessWidget {
  const _OptionContainer(
      {required this.title, required this.isSelected, required this.onTap});

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12, vertical: SizeConfig.padding18),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.50,
                color: isSelected
                    ? UiConstants.kTabBorderColor
                    : const Color(0xFFD3D3D3).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: SizeConfig.padding24,
              height: SizeConfig.padding24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? UiConstants.kTabBorderColor
                      : const Color(0xFF617E8E),
                  width: SizeConfig.border2,
                ),
                // color: isSelected ? Colors.white : null,
              ),
              child: Container(
                margin: EdgeInsets.all(SizeConfig.padding4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? UiConstants.kTabBorderColor : null,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.padding16),
            Text(title, style: TextStyles.sourceSans.body3),
          ],
        ),
      ),
    );
  }
}
