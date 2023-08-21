import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/chose_other_option_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotDecidedModalSheet extends HookWidget {
  const NotDecidedModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);

    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff023C40),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: SizeConfig.padding16),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding22,
                  vertical: SizeConfig.padding18,
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
                        SvgPicture.asset(
                          'assets/svg/fello_flo.svg',
                          height: SizeConfig.padding44,
                          width: SizeConfig.padding44,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: SizeConfig.padding8),
                        Text('Your 10% Deposit is maturing',
                            style: TextStyles.rajdhaniSB.body0
                                .colour(Colors.white))
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding40),
                    FloAssetInfoWidget(
                      investedAmount: '140',
                      investedDate: '3rd June 2023',
                      maturityAmount: '150',
                      maturityDate: '3rd Sept 2023',
                      decision: UserDecision.NOTDECIDED,
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    OptionDecisionContainer(
                      optionIndex: 1,
                      title: 'Re-invest ₹150 in 10% Flo',
                      description: 'Becomes ₹160 on maturity',
                      promoText: 'You don’t lose any of your tickets',
                      recommendedText: '1L+ users chose this',
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
                      promoText: 'You will lose out on *20 tickets*',
                      isSelected: selectedOption.value == 2,
                      onTap: () {
                        selectedOption.value = 2;
                      },
                    ),
                    OptionDecisionContainer(
                      optionIndex: 3,
                      title: "Withdraw to Bank",
                      description: '5% less returns with savings accounts',
                      promoText: 'You’ll lose *30 tickets* at withdrawal',
                      promoContainerColor:
                          const Color(0xffA5381B).withOpacity(0.6),
                      isSelected: selectedOption.value == 3,
                      onTap: () {
                        selectedOption.value = 3;
                      },
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    'This decision will reflect after maturity in *7 Days*'
                        .beautify(
                      boldStyle: TextStyles.sourceSansB.body3.colour(
                        const Color(0xFFA9C5D5),
                      ),
                      style: TextStyles.sourceSans.body3.colour(
                        const Color(0xFFA9C5D5),
                      ),
                      alignment: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    MaterialButton(
                        minWidth: SizeConfig.screenWidth,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                        height: SizeConfig.padding44,
                        child: Text(
                          "CONFIRM DECISION",
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
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
                              content: SuccessfulDepositSheet(
                                investAmount: '150',
                                maturityAmount: '160',
                                maturityDate: '${DateTime.now()}',
                                reInvestmentDate: '${DateTime.now()}',
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
                              content: const ReConfirmationSheet(),
                            );
                          }

                          if (selectedOption.value == 3) {
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
                        }),
                    SizedBox(height: SizeConfig.padding12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
