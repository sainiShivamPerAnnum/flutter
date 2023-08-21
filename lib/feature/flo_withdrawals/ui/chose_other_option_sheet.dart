import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/withdraw_feedback.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OtherOptionsModalSheet extends HookWidget {
  const OtherOptionsModalSheet({super.key});

  // final UserDecision decision;

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);

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
              'What do you want to do with the money?',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body2.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding24),
            OptionDecisionContainer(
              optionIndex: 1,
              title: 'Move ₹150 to 8% Flo',
              description: 'Becomes ₹155 on maturity',
              promoText: "You will lose out on *20 tickets*",
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
              title: "Withdraw to Bank",
              description: '5% less returns with savings accounts',
              promoText: 'You’ll lose *30 tickets* at withdrawal',
              promoContainerColor: const Color(0xFFA4371A).withOpacity(0.6),
              promoTextBoldColor: const Color(0xFFF79780),
              isSelected: selectedOption.value == 2,
              onTap: () {
                selectedOption.value = 2;
              },
            ),
            SizedBox(height: SizeConfig.padding16),
            MaterialButton(
                minWidth: SizeConfig.screenWidth,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.padding44,
                child: Text(
                  "Done",
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
                onPressed: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher?.didPopRoute();

                  if (selectedOption.value == 1) {
                    BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: true,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: Successful8MovedSheet(
                        investAmount: '140',
                        maturityAmount: '150',
                        maturityDate: '${DateTime.now()}',
                        reInvestmentDate: '${DateTime.now()}',
                        defaultMovedTo8: false,
                        // move8flo: decision == UserDecision.MOVETO8,
                      ),
                    );
                  }

                  if (selectedOption.value == 2) {
                    BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: true,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: const WithdrawalFeedback(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
