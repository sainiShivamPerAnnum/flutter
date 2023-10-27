import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WithdrawalFeedback extends HookWidget {
  const WithdrawalFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);
    final isEnable = useState(false);

    useEffect(() {
      if (selectedOption.value != -1) {
        isEnable.value = true;
      } else {
        isEnable.value = false;
      }
    }, [selectedOption.value]);

    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding22,
          vertical: SizeConfig.padding18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff023C40),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    AppState.backButtonDispatcher?.didPopRoute();
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.crossTappedOnPendingActions,
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: SizeConfig.padding24,
                  ),
                ),
              ],
            ),
            // SizedBox(height: SizeConfig.padding8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/fello_flo.svg',
                  height: SizeConfig.padding64,
                  // width: SizeConfig.padding4,
                  // fit: BoxFit.cover,
                ),
                SizedBox(width: SizeConfig.padding8),
                Expanded(
                  child: Text('Your investment could have\ngrown by 10%',
                      style: TextStyles.rajdhaniSB.body0.colour(Colors.white)),
                )
              ],
            ),
            SizedBox(height: SizeConfig.padding26),
            Text(
              'What makes you want to withdraw?',
              style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding30),

            WithdrawalOptionContainer(
              title: 'Will re-invest money in 12%',
              isSelected: selectedOption.value == 0,
              onTap: () {
                selectedOption.value = 0;
              },
            ),
            SizedBox(height: SizeConfig.padding26),
            WithdrawalOptionContainer(
              title: 'Returns aren’t good enough',
              isSelected: selectedOption.value == 1,
              onTap: () {
                selectedOption.value = 1;
              },
            ),
            SizedBox(height: SizeConfig.padding26),
            WithdrawalOptionContainer(
              title: 'Maturity period is very long',
              isSelected: selectedOption.value == 2,
              onTap: () {
                selectedOption.value = 2;
              },
            ),
            SizedBox(height: SizeConfig.padding26),
            WithdrawalOptionContainer(
              title: 'Others',
              isSelected: selectedOption.value == 3,
              onTap: () {
                selectedOption.value = 3;
              },
            ),
            SizedBox(height: SizeConfig.padding64),
            MaterialButton(
                minWidth: SizeConfig.screenWidth,
                color: Colors.white.withOpacity(isEnable.value ? 1 : 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.padding44,
                child: Text(
                  "NEXT",
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
                onPressed: () {
                  Haptic.vibrate();

                  if (selectedOption.value == -1) {
                    BaseUtil.showNegativeAlert("Please select an option",
                        "proceed by choosing an option");
                    return;
                  }

                  AppState.backButtonDispatcher!.didPopRoute();
                  if (locator<BankAndPanService>().isBankDetailsAdded) {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: BalloonLottieScreenViewConfig,
                    );
                  } else {
                    AppState.delegate!.parseRoute(Uri.parse("bankDetails"));
                    locator<BankAndPanService>().isFromFloWithdrawFlow = true;
                  }

                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.reasonSelectedFixedWithdrawal,
                    properties: {
                      'Decision': selectedOption.value == 0
                          ? 'Will re-invest money in 12%'
                          : selectedOption.value == 1
                              ? 'Returns aren’t good enough'
                              : selectedOption.value == 2
                                  ? 'Maturity period is very long'
                                  : 'Others',
                    },
                  );
                }),
            SizedBox(height: SizeConfig.padding12),
          ],
        ),
      ),
    );
  }
}

class WithdrawalOptionContainer extends StatelessWidget {
  const WithdrawalOptionContainer(
      {required this.isSelected,
      required this.onTap,
      required this.title,
      super.key});

  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                      : const Color(0xFFD3D3D3).withOpacity(0.6),
                  width: SizeConfig.border1,
                ),
                // color: isSelected ? Colors.white : null,
              ),
              child: Container(
                margin: EdgeInsets.all(SizeConfig.padding4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? UiConstants.kTabBorderColor : null,
                ),
              )),
          SizedBox(width: SizeConfig.padding16),
          Text(
            title,
            style: TextStyles.sourceSans.body3.colour(
              Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
