import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/NotDecidedSheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/chose_other_option_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reconfirmation_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvest_slider.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class ReInvestmentBottomWidget extends StatelessWidget {
  const ReInvestmentBottomWidget(
      {required this.decision, required this.remainingDay, super.key});

  final UserDecision decision;
  final int remainingDay;

  String getTitle() {
    switch (decision) {
      case UserDecision.MOVETO8:
        return 'SLIDE TO GET 10% RETURNS';
      case UserDecision.WITHDRAW:
        return 'SLIDE TO RE-INVEST IN 10%';
      case UserDecision.NOTDECIDED:
        return 'MAKE DECISION NOW';
      case UserDecision.REINVEST:
        return 'SLIDE TO Re-Invest';
    }
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
          if (decision == UserDecision.MOVETO8 ||
              decision == UserDecision.WITHDRAW) ...[
            Text(
              decision == UserDecision.MOVETO8
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
                    'MAKE DECISION NOW',
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                  onPressed: () {
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

                    BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: true,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: const NotDecidedModalSheet(),
                    );
                  })
              : SlideAction(
                  text: getTitle(),
                  textStyle: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  borderRadius: SizeConfig.padding60,
                  height: SizeConfig.padding56,
                  sliderButtonIconSize: SizeConfig.padding24,
                  sliderButtonIconPadding: SizeConfig.padding12,
                  outerColor: Colors.white,
                  // innerColor: const Color(0xFF00EAC2),
                  sliderRotate: false,
                  onSubmit: () {
                    log("unlocked");
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

                    if (decision == UserDecision.NOTDECIDED) {
                      BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissible: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: const NotDecidedModalSheet(
                            // investAmount: '140',
                            // maturityAmount: '150',
                            // maturityDate: '${DateTime.now()}',
                            // reInvestmentDate: '${DateTime.now()}',
                            ),
                      );
                    } else {
                      BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissible: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: SuccessfulDepositSheet(
                          investAmount: '140',
                          maturityAmount: '150',
                          maturityDate: '${DateTime.now()}',
                          reInvestmentDate: '${DateTime.now()}',
                        ),
                      );
                    }
                  },
                ),
          SizedBox(height: SizeConfig.padding18),
          if (decision == UserDecision.MOVETO8 ||
              decision == UserDecision.WITHDRAW) ...[
            SizedBox(height: SizeConfig.padding8),
            GestureDetector(
              onTap: () {
                Haptic.vibrate();
                AppState.backButtonDispatcher?.didPopRoute();

                if (decision == UserDecision.MOVETO8) {
                  BaseUtil.openModalBottomSheet(
                    addToScreenStack: true,
                    enableDrag: false,
                    hapticVibrate: true,
                    isBarrierDismissible: true,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    content: const ReConfirmationSheet(),
                  );
                } else {
                  BaseUtil.openModalBottomSheet(
                    addToScreenStack: true,
                    enableDrag: false,
                    hapticVibrate: true,
                    isBarrierDismissible: true,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    content: const OtherOptionsModalSheet(),
                  );
                }
              },
              child: Text(
                decision == UserDecision.MOVETO8
                    ? 'I AM HAPPY WITH 8% RETURNS ONLY'
                    : 'VIEW OTHER OPTIONS',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniB.body1
                    .colour(const Color(0xFFBDBDBE))
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
          if (decision == UserDecision.NOTDECIDED) ...[
            'Your investment will shift to 8% Flo if you\ndon’t decide in the next *$remainingDay days*'
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
