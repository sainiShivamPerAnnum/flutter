import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/success_8_moved_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_option_decision_container.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/withdraw_feedback.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class OtherOptionsModalSheet extends HookWidget {
  const OtherOptionsModalSheet(
      {required this.depositData,
      required this.isLendboxOldUser,
      required this.decision,
      super.key});

  final Deposit depositData;
  final bool isLendboxOldUser;
  final UserDecision decision;

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);
    final showLoading = useState(false);
    final val = useState(decision == UserDecision.WITHDRAW ? 0 : 1);
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
            SizedBox(height: SizeConfig.padding8),
            Text(
              'What do you want to do with your investment?',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body2.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding24),
            OptionDecisionContainer(
              optionIndex: 1,
              title: depositData.decisionsAvailable![val.value].title!,
              description: depositData.decisionsAvailable![val.value].subtitle!,
              promoText:
                  depositData.decisionsAvailable![val.value].footer!.text!,
              promotAsset:
                  depositData.decisionsAvailable![val.value].footer!.icon!,
              promoTextBoldColor: const Color(0xFF61E3C4),
              promoContainerColor: const Color(0xFF1ADAB7).withOpacity(0.35),
              isSelected: selectedOption.value == 1,
              onTap: () {
                selectedOption.value = 1;
              },
              showRecomended: false,
            ),
            OptionDecisionContainer(
              optionIndex: 2,
              title: depositData.decisionsAvailable![val.value + 1].title!,
              description:
                  depositData.decisionsAvailable![val.value + 1].subtitle!,
              promoText:
                  depositData.decisionsAvailable![val.value + 1].footer!.text!,
              promotAsset:
                  depositData.decisionsAvailable![val.value + 1].footer!.icon!,
              promoContainerColor: const Color(0xFFA4371A).withOpacity(0.6),
              promoTextBoldColor: const Color(0xFFF79780),
              isSelected: selectedOption.value == 2,
              onTap: () {
                selectedOption.value = 2;
              },
            ),
            SizedBox(height: SizeConfig.padding16),
            showLoading.value
                ? SpinKitThreeBounce(
                    size: SizeConfig.title5,
                    color: Colors.white,
                  )
                : MaterialButton(
                    minWidth: SizeConfig.screenWidth,
                    color: Colors.white.withOpacity(isEnable.value ? 1 : 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    height: SizeConfig.padding44,
                    child: Text(
                      "CONFIRM DECISION",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                    onPressed: () async {
                      Haptic.vibrate();

                      if (selectedOption.value == -1) {
                        BaseUtil.showNegativeAlert("Please select an option",
                            "proceed by choosing an option");
                        return;
                      }

                      showLoading.value = true;

                      if (selectedOption.value == 1) {
                        await locator<LendboxMaturityService>()
                            .updateInvestmentPref(
                                depositData.decisionsAvailable![0].pref!);

                        // add delay of 1 sec
                        await Future.delayed(const Duration(seconds: 1));

                        AppState.backButtonDispatcher?.didPopRoute();

                        unawaited(BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          enableDrag: false,
                          hapticVibrate: true,
                          isBarrierDismissible: false,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          content: Successful8MovedSheet(
                            investAmount: depositData.decisionsAvailable![0]
                                .onDecisionMade!.investedAmt
                                .toString(),
                            maturityAmount: depositData.decisionsAvailable![0]
                                .onDecisionMade!.maturityAmt
                                .toString(),
                            maturityDate: formatDate(depositData
                                .decisionsAvailable![0]
                                .onDecisionMade!
                                .maturityOn!),
                            reInvestmentDate: formatDate(depositData
                                .decisionsAvailable![0]
                                .onDecisionMade!
                                .investedOn!),
                            defaultMovedTo8: false,
                            fdDuration: depositData.decisionsAvailable![0]
                                .onDecisionMade!.fdDuration!,
                            roiPerc: depositData.decisionsAvailable![0]
                                .onDecisionMade!.roiPerc!,
                            title: depositData
                                .decisionsAvailable![0].onDecisionMade!.title!,
                            topChipText: depositData.decisionsAvailable![0]
                                .onDecisionMade!.topChipText!,
                            footer: depositData
                                .decisionsAvailable![0].onDecisionMade!.footer!,
                            isLendboxOldUser: isLendboxOldUser,
                          ),
                        ));
                      }

                      if (selectedOption.value == 2) {
                        AppState.backButtonDispatcher?.didPopRoute();
                        BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          enableDrag: false,
                          hapticVibrate: true,
                          isBarrierDismissible: false,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          content: const WithdrawalFeedback(),
                        );
                      }

                      showLoading.value = false;

                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.otherOptionsConfirmation,
                        properties: {
                          "Maturity Date": formatDate(depositData.maturityOn!),
                          "Maturity Amount": depositData.maturityAmt,
                          "principal amount": depositData.investedAmt,
                          'asset': depositData.fundType,
                          'Decision': selectedOption.value == 1
                              ? 'move to flexi'
                              : 'Withdraw'
                        },
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
