import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/success_8_moved_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_option_decision_container.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReConfirmationSheet extends HookWidget {
  const ReConfirmationSheet({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you sure?',
                    style: TextStyles.rajdhaniSB.body0.colour(Colors.white))
              ],
            ),
            SizedBox(height: SizeConfig.padding8),
            Text(
              'You are missing out on earning 2% extra\nreturns on your investment',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body3.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding24),
            OptionDecisionContainer(
              optionIndex: 1,
              title: 'Re-invest ₹150 in 10% Flo',
              description: 'Becomes ₹160 on maturity',
              promoText: "Get *2X tickets* on saving",
              isSelected: selectedOption.value == 1,
              onTap: () {
                selectedOption.value = 1;
              },
              showRecomended: true,
            ),
            OptionDecisionContainer(
              optionIndex: 2,
              title: "Move ₹150 to 8% Flo",
              description: 'Becomes ₹160 on maturity',
              promoText: 'You are losing out on 30 tickets',
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
                  if (selectedOption.value == 1) {
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

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

                  if (selectedOption.value == 2) {
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

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
                }),
          ],
        ),
      ),
    );
  }
}
