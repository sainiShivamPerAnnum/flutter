import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/NotDecidedSheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/chose_other_option_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reconfirmation_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvest_slider.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReInvestmentBottomWidget extends StatelessWidget {
  const ReInvestmentBottomWidget(
      {required this.decision,
      required this.remainingDay,
      required this.depositData,
      required this.isLendboxOldUser,
      super.key});

  final UserDecision decision;
  final Deposit depositData;
  final int remainingDay;
  final bool isLendboxOldUser;

  String getTitle() {
    switch (decision) {
      case UserDecision.MOVETOFLEXI:
        return 'SLIDE TO GET 10% RETURNS';
      case UserDecision.WITHDRAW:
        return 'SLIDE TO RE-INVEST IN 10%';
      case UserDecision.NOTDECIDED:
        return 'MAKE DECISION NOW';
      case UserDecision.REINVEST:
        return 'SLIDE TO Re-Invest';
    }
  }

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding16,
      ),
      color: (decision == UserDecision.NOTDECIDED ||
              decision == UserDecision.REINVEST)
          ? null
          : Colors.black.withOpacity(0.37),
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          if (decision == UserDecision.MOVETOFLEXI ||
              decision == UserDecision.WITHDRAW) ...[
            Text(
              decision == UserDecision.MOVETOFLEXI
                  ? 'Get extra 2% on your Investment'
                  : 'Get more returns on your investment',
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding16),
          ],
          decision == UserDecision.NOTDECIDED
              ? MaterialButton(
                  minWidth: SizeConfig.screenWidth,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  height: SizeConfig.padding44,
                  child: Text(
                    'DECIDE NOW',
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                  onPressed: () {
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

                    BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: false,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: NotDecidedModalSheet(
                        depositData: depositData,
                        isLendboxOldUser: isLendboxOldUser,
                        decision: decision,
                      ),
                    );

                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.makeDecisionNowTapped,
                      properties: {
                        "Maturity Date": formatDate(depositData.maturityOn!),
                        "Maturity Amount": depositData.maturityAmt,
                        "principal amount": depositData.investedAmt
                      },
                    );
                  })
              : SlideAction(
                  text: depositData.sliderText,
                  textStyle: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  borderRadius: SizeConfig.padding60,
                  height: SizeConfig.padding56,
                  sliderButtonIconSize: SizeConfig.padding24,
                  sliderButtonIconPadding: SizeConfig.padding12,
                  outerColor: Colors.white,
                  // innerColor: const Color(0xFF00EAC2),
                  sliderRotate: false,
                  onSubmit: () async {
                    int val = decision == UserDecision.WITHDRAW ? 2 : 0;
                    Haptic.vibrate();

                    await locator<LendboxMaturityService>()
                        .updateInvestmentPref("1");

                    AppState.backButtonDispatcher?.didPopRoute();
                    unawaited(BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: false,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: SuccessfulDepositSheet(
                        investAmount: depositData.decisionsAvailable![val]
                            .onDecisionMade!.investedAmt
                            .toString(),
                        maturityAmount: depositData.decisionsAvailable![val]
                            .onDecisionMade!.maturityAmt
                            .toString(),
                        maturityDate: formatDate(depositData
                            .decisionsAvailable![val]
                            .onDecisionMade!
                            .maturityOn!),
                        reInvestmentDate: formatDate(depositData
                            .decisionsAvailable![val]
                            .onDecisionMade!
                            .investedOn!),
                        fdDuration: depositData.decisionsAvailable![val]
                            .onDecisionMade!.fdDuration!,
                        roiPerc: depositData
                            .decisionsAvailable![val].onDecisionMade!.roiPerc!,
                        title: depositData
                            .decisionsAvailable![val].onDecisionMade!.title!,
                        topChipText: depositData.decisionsAvailable![val]
                            .onDecisionMade!.topChipText!,
                        footer: depositData
                            .decisionsAvailable![val].onDecisionMade!.footer!,
                        fundType: depositData.fundType!,
                      ),
                    ));

                    if (decision == UserDecision.MOVETOFLEXI) {
                      locator<AnalyticsService>().track(
                        eventName:
                            AnalyticsEvents.slideToReinvestInFlexiWithdrawal10,
                        properties: {
                          "Maturity Date": formatDate(depositData.maturityOn!),
                          "Maturity Amount": depositData.maturityAmt,
                          "principal amount": depositData.investedAmt,
                          'asset': depositData.fundType
                        },
                      );
                    } else {
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.slideToReinvestInFixed,
                        properties: {
                          "Maturity Date": formatDate(depositData.maturityOn!),
                          "Maturity Amount": depositData.maturityAmt,
                          "principal amount": depositData.investedAmt,
                          'asset': depositData.fundType
                        },
                      );
                    }
                  },
                ),
          SizedBox(height: SizeConfig.padding18),
          if (decision == UserDecision.MOVETOFLEXI ||
              decision == UserDecision.WITHDRAW) ...[
            SizedBox(height: SizeConfig.padding8),
            GestureDetector(
              onTap: () {
                Haptic.vibrate();
                AppState.backButtonDispatcher?.didPopRoute();

                if (decision == UserDecision.MOVETOFLEXI) {
                  BaseUtil.openModalBottomSheet(
                    addToScreenStack: true,
                    enableDrag: false,
                    hapticVibrate: true,
                    isBarrierDismissible: false,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    content: ReConfirmationSheet(
                      depositData: depositData,
                      decision: decision,
                      isLendboxOldUser: isLendboxOldUser,
                    ),
                  );

                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.iAmHappyWithFlexiTapped,
                    properties: {
                      "Maturity Date": formatDate(depositData.maturityOn!),
                      "Maturity Amount": depositData.maturityAmt,
                      "principal amount": depositData.investedAmt,
                      'asset': depositData.fundType
                    },
                  );
                } else {
                  BaseUtil.openModalBottomSheet(
                    addToScreenStack: true,
                    enableDrag: false,
                    hapticVibrate: true,
                    isBarrierDismissible: false,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    content: OtherOptionsModalSheet(
                      depositData: depositData,
                      isLendboxOldUser: isLendboxOldUser,
                      decision: decision,
                    ),
                  );

                  locator<AnalyticsService>().track(
                    eventName:
                        AnalyticsEvents.viewOtherOptionsInFlexiWithdrawal,
                    properties: {
                      "Maturity Date": formatDate(depositData.maturityOn!),
                      "Maturity Amount": depositData.maturityAmt,
                      "principal amount": depositData.investedAmt,
                      'asset': depositData.fundType
                    },
                  );
                }
              },
              child: Text(
                decision == UserDecision.MOVETOFLEXI
                    ? 'I AM HAPPY WITH ${isLendboxOldUser ? 10 : 8}% RETURNS ONLY'
                    : 'VIEW OTHER OPTIONS',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniB.body1
                    .colour(const Color(0xFFBDBDBE))
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
          if (decision == UserDecision.NOTDECIDED) ...[
            'Your investment will shift to ${isLendboxOldUser ? 10 : 8}% Flo if you\ndon’t decide in the next *${remainingDay <= 0 ? "few hours" : '$remainingDay days'}*'
                .beautify(
              boldStyle: TextStyles.sourceSansB.body3.colour(
                const Color(0xFFA9C5D5),
              ),
              style: TextStyles.sourceSans.body3.colour(
                const Color(0xFFA9C5D5),
              ),
              alignment: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.padding8),
          ]
        ],
      ),
    );
  }
}
