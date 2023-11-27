import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/success_8_moved_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_option_decision_container.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class MoneyAfterMaturityWidget extends HookWidget {
  const MoneyAfterMaturityWidget(
      {required this.depositData,
      required this.decision,
      required this.isLendboxOldUser,
      super.key});

  final Deposit depositData;
  final UserDecision decision;
  final bool isLendboxOldUser;

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);
    final showLoading = useState(false);
    int optionIndex1 = decision == UserDecision.WITHDRAW ? 2 : 0;
    int optionIndex2 = decision == UserDecision.WITHDRAW ? 0 : 1;
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
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: SizeConfig.padding24,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: "What do you want to do ",
                    style: TextStyles.sourceSans.body2,
                    children: [
                      TextSpan(
                        text: "after maturity",
                        style: TextStyles.sourceSansB.body2,
                      ),
                    ],
                  ),
                ),
                // const Icon(
                //   Icons.info_outline,
                //   color: Colors.white,
                //   size: 15,
                // ),
              ],
            ),
            SizedBox(height: SizeConfig.padding24),
            OptionDecisionContainer(
              optionIndex: 1,
              title: depositData.decisionsAvailable![optionIndex1].title!,
              description:
                  depositData.decisionsAvailable![optionIndex1].subtitle!,
              promoText:
                  depositData.decisionsAvailable![optionIndex1].footer!.text!,
              promotAsset:
                  depositData.decisionsAvailable![optionIndex1].footer!.icon!,
              recommendedText:
                  depositData.decisionsAvailable![optionIndex1].topChip,
              promoTextBoldColor: const Color(0xFF61E3C4),
              promoContainerColor: const Color(0xFF1ADAB7).withOpacity(0.35),
              isSelected: selectedOption.value == 1,
              onTap: () {
                selectedOption.value = 1;
              },
              showRecomended: true,
            ),
            OptionDecisionContainer(
              optionIndex: 2,
              title: depositData.decisionsAvailable![optionIndex2].title!,
              description:
                  depositData.decisionsAvailable![optionIndex2].subtitle!,
              promoText:
                  depositData.decisionsAvailable![optionIndex2].footer!.text!,
              promotAsset:
                  depositData.decisionsAvailable![optionIndex2].footer!.icon!,
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
                      "Done",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                    onPressed: () async {
                      if (selectedOption.value == -1) {
                        BaseUtil.showNegativeAlert("Please select an option",
                            "proceed by choosing an option");
                        return;
                      }
                      showLoading.value = true;

                      if (selectedOption.value == 1) {
                        Haptic.vibrate();

                        await locator<LendboxMaturityService>()
                            .updateInvestmentPref(depositData
                                .decisionsAvailable![optionIndex1].pref!);

                        // add delay
                        await Future.delayed(const Duration(milliseconds: 700));

                        unawaited(AppState.backButtonDispatcher?.didPopRoute());

                        unawaited(BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          enableDrag: false,
                          hapticVibrate: true,
                          isBarrierDismissible: false,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          content: SuccessfulDepositSheet(
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
                            fundType: depositData.fundType!,
                          ),
                        ));
                      }

                      if (selectedOption.value == 2) {
                        Haptic.vibrate();

                        await locator<LendboxMaturityService>()
                            .updateInvestmentPref(
                                depositData.decisionsAvailable![0].pref!);

                        AppState.backButtonDispatcher?.didPopRoute();

                        BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          enableDrag: false,
                          hapticVibrate: true,
                          isBarrierDismissible: false,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          content: Successful8MovedSheet(
                            investAmount: depositData.decisionsAvailable![1]
                                .onDecisionMade!.investedAmt
                                .toString(),
                            maturityAmount: depositData.decisionsAvailable![1]
                                .onDecisionMade!.maturityAmt
                                .toString(),
                            maturityDate: formatDate(depositData
                                .decisionsAvailable![1]
                                .onDecisionMade!
                                .maturityOn!),
                            reInvestmentDate: formatDate(depositData
                                .decisionsAvailable![1]
                                .onDecisionMade!
                                .investedOn!),
                            defaultMovedTo8: false,
                            fdDuration: depositData.decisionsAvailable![1]
                                .onDecisionMade!.fdDuration!,
                            roiPerc: depositData.decisionsAvailable![1]
                                .onDecisionMade!.roiPerc!,
                            title: depositData
                                .decisionsAvailable![1].onDecisionMade!.title!,
                            topChipText: depositData.decisionsAvailable![1]
                                .onDecisionMade!.topChipText!,
                            footer: depositData
                                .decisionsAvailable![1].onDecisionMade!.footer!,
                            isLendboxOldUser: isLendboxOldUser,
                          ),
                        );
                        return;
                      }
                    }),
          ],
        ),
      ),
    );
  }
}
