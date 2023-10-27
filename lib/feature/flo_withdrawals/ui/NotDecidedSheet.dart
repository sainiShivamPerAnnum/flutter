import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/chose_other_option_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reconfirmation_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_asset_info_widget.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_option_decision_container.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NotDecidedModalSheet extends HookWidget {
  const NotDecidedModalSheet(
      {required this.depositData,
      required this.isLendboxOldUser,
      required this.decision,
      super.key});

  final Deposit depositData;
  final UserDecision decision;
  final bool isLendboxOldUser;

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  String getTitle() {
    if (depositData.fundType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return 'Your 12% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return 'Your 10% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FELXI &&
        isLendboxOldUser) {
      return 'Your 10% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FELXI &&
        !isLendboxOldUser) {
      return 'Your 8% Deposit is maturing';
    }
    return 'Your 10% Deposit is maturing';
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState(-1);
    final showLoading = useState(false);
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
                            locator<AnalyticsService>().track(
                              eventName:
                                  AnalyticsEvents.crossTappedOnPendingActions,
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
                        Text(getTitle(),
                            style: TextStyles.rajdhaniSB.body0
                                .colour(Colors.white))
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding40),
                    FloAssetInfoWidget(
                      investedAmount: (depositData.investedAmt!).toString(),
                      investedDate: formatDate(depositData.investedOn!),
                      maturityAmount: (depositData.maturityAmt!).toString(),
                      maturityDate: formatDate(depositData.maturityOn!),
                      decision: decision,
                      maturesInDays: depositData.maturesInDays ?? 0,
                      fdDuration: depositData.fdDuration!,
                      roiPerc: depositData.roiPerc!,
                      fundType: depositData.fundType!,
                      isLendboxOldUser: isLendboxOldUser,
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "What do you want to do ",
                            style: TextStyles.sourceSans.body2,
                            children: [
                              TextSpan(
                                text: "after maturity?",
                                style: TextStyles.sourceSansB.body2,
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          triggerMode: TooltipTriggerMode.tap,
                          preferBelow: false,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins,
                              vertical: SizeConfig.pageHorizontalMargins),
                          showDuration: const Duration(seconds: 10),
                          message:
                              "Fello Flo Premium plans allow you to decide what happens to your money after maturity. You can choose what you want to do with your money while you invest. If you do not select a preference, we will contact you and confirm what you want to do with the corpus post maturity.",
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    OptionDecisionContainer(
                      optionIndex: 1,
                      title: depositData.decisionsAvailable![0].title!,
                      description: depositData.decisionsAvailable![0].subtitle!,
                      promoText:
                          depositData.decisionsAvailable![0].footer!.text!,
                      promotAsset:
                          depositData.decisionsAvailable![0].footer!.icon!,
                      recommendedText:
                          depositData.decisionsAvailable![0].topChip,
                      promoContainerColor:
                          const Color(0xFF1ADAB7).withOpacity(0.35),
                      isSelected: selectedOption.value == 1,
                      onTap: () {
                        selectedOption.value = 1;
                      },
                      showRecomended: true,
                    ),
                    OptionDecisionContainer(
                      optionIndex: 2,
                      title: depositData.decisionsAvailable![1].title!,
                      description: depositData.decisionsAvailable![1].subtitle!,
                      promoText:
                          depositData.decisionsAvailable![1].footer!.text!,
                      promotAsset:
                          depositData.decisionsAvailable![1].footer!.icon!,
                      promoTextBoldColor: const Color(0xFF61E3C4),
                      promoContainerColor:
                          const Color(0xFF1ADAB7).withOpacity(0.35),
                      isSelected: selectedOption.value == 2,
                      onTap: () {
                        selectedOption.value = 2;
                      },
                    ),
                    OptionDecisionContainer(
                      optionIndex: 3,
                      title: depositData.decisionsAvailable![2].title!,
                      description: depositData.decisionsAvailable![2].subtitle!,
                      promoText:
                          depositData.decisionsAvailable![2].footer!.text!,
                      promotAsset:
                          depositData.decisionsAvailable![2].footer!.icon!,
                      promoContainerColor:
                          const Color(0xffA5381B).withOpacity(0.6),
                      promoTextBoldColor: const Color(0xFFF79780),
                      isSelected: selectedOption.value == 3,
                      onTap: () {
                        selectedOption.value = 3;
                      },
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    'This decision will reflect after maturity in *${(depositData.maturesInDays ?? 0) <= 0 ? "few hours" : '${depositData.maturesInDays} days'}*'
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
                    showLoading.value
                        ? SpinKitThreeBounce(
                            size: SizeConfig.title5,
                            color: Colors.white,
                          )
                        : MaterialButton(
                            minWidth: SizeConfig.screenWidth,
                            color: Colors.white
                                .withOpacity(isEnable.value ? 1 : 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness5),
                            ),
                            height: SizeConfig.padding44,
                            child: Text(
                              "CONFIRM DECISION",
                              style: TextStyles.rajdhaniB.body1
                                  .colour(Colors.black),
                            ),
                            onPressed: () async {
                              Haptic.vibrate();

                              if (selectedOption.value == -1) {
                                BaseUtil.showNegativeAlert(
                                    "Please select an option",
                                    "proceed by choosing an option");
                                return;
                              }

                              if (selectedOption.value == 1) {
                                showLoading.value = true;
                                await locator<LendboxMaturityService>()
                                    .updateInvestmentPref(depositData
                                        .decisionsAvailable![0].pref!);

                                AppState.backButtonDispatcher?.didPopRoute();

                                unawaited(BaseUtil.openModalBottomSheet(
                                  addToScreenStack: true,
                                  enableDrag: false,
                                  hapticVibrate: true,
                                  isBarrierDismissible: false,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  content: SuccessfulDepositSheet(
                                    investAmount: depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .investedAmt
                                        .toString(),
                                    maturityAmount: depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .maturityAmt
                                        .toString(),
                                    maturityDate: formatDate(depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .maturityOn!),
                                    reInvestmentDate: formatDate(depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .investedOn!),
                                    fdDuration: depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .fdDuration!,
                                    roiPerc: depositData.decisionsAvailable![0]
                                        .onDecisionMade!.roiPerc!,
                                    title: depositData.decisionsAvailable![0]
                                        .onDecisionMade!.title!,
                                    topChipText: depositData
                                        .decisionsAvailable![0]
                                        .onDecisionMade!
                                        .topChipText!,
                                    footer: depositData.decisionsAvailable![0]
                                        .onDecisionMade!.footer!,
                                    fundType: depositData.fundType!,
                                  ),
                                ));
                              }

                              if (selectedOption.value == 2) {
                                AppState.backButtonDispatcher?.didPopRoute();
                                unawaited(BaseUtil.openModalBottomSheet(
                                  addToScreenStack: true,
                                  enableDrag: false,
                                  hapticVibrate: true,
                                  isBarrierDismissible: false,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  content: ReConfirmationSheet(
                                    depositData: depositData,
                                    isLendboxOldUser: isLendboxOldUser,
                                    decision: decision,
                                  ),
                                ));
                              }

                              if (selectedOption.value == 3) {
                                AppState.backButtonDispatcher?.didPopRoute();
                                unawaited(BaseUtil.openModalBottomSheet(
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
                                ));
                              }

                              locator<AnalyticsService>().track(
                                eventName:
                                    AnalyticsEvents.confirmDecisionTapped,
                                properties: {
                                  'decision taken': selectedOption.value == 1
                                      ? "reinvest"
                                      : selectedOption.value == 2
                                          ? "move to flexi"
                                          : "withdraw",
                                },
                              );
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
