import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../../util/constants.dart';

class ReInvestPrompt extends HookWidget {
  const ReInvestPrompt({
    required this.amount,
    required this.assetType,
    required this.model,
    Key? key,
  }) : super(key: key);

  final String amount;
  final String assetType;
  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    final subtitle = useMemoized(
      () =>
          "At the end of ${assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months (Maturity)",
      [assetType],
    );

    final maturityAmount = useMemoized(
      () => model.calculateAmountAfterMaturity(amount),
      [model, amount],
    );

    final selectedOption = useState(model.selectedOption);

    return Container(
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InvestmentForeseenWidget(
              amount: amount,
              assetType: assetType,
              isLendboxOldUser: model.isLendboxOldUser,
              onChanged: (value) {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        text: "Select what happens to your investment ",
                        style: TextStyles.sourceSans.body2,
                        children: [
                          TextSpan(
                            text:
                                "after ${assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months?",
                            style: TextStyles.sourceSansB.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding34,
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
            ),
            SizedBox(height: SizeConfig.padding20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness5),
                  topRight: Radius.circular(SizeConfig.roundness5),
                ),
                color: UiConstants.kSnackBarPositiveContentColor,
              ),
              child: Text(
                'Recommended',
                style: TextStyles.sourceSansSB.body4,
              ),
            ),
            OptionContainer(
              optionIndex: 1,
              title:
                  'Re-invest ₹$maturityAmount in ${assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "12" : "10"}% Flo',
              description: subtitle,
              isSelected: selectedOption.value == 1,
              onTap: () {
                model.maturityPref = "1";
                model.selectedOption = selectedOption.value = 1;
              },
            ),
            OptionContainer(
              optionIndex: 2,
              title:
                  "Move ₹$maturityAmount to ${assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "10" : "8"}% Flo",
              description: subtitle,
              isSelected: selectedOption.value == 2,
              onTap: () {
                model.maturityPref = "2";
                model.selectedOption = selectedOption.value = 2;
              },
            ),
            OptionContainer(
              optionIndex: 3,
              title: "Withdraw to Bank",
              description: subtitle,
              isSelected: selectedOption.value == 3,
              onTap: () {
                model.maturityPref = "0";
                model.selectedOption = selectedOption.value = 3;
              },
            ),
            SizedBox(height: SizeConfig.padding8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    minWidth: SizeConfig.screenWidth! * 0.4,
                    height: SizeConfig.padding40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.white),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    onPressed: () {
                      AppState.backButtonDispatcher?.didPopRoute();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      model.maturityPref = "NA";
                      model.selectedOption = selectedOption.value = -2;

                      BaseUtil.showPositiveAlert(
                        'Choose your action later',
                        'We will Confirm your preference once again before maturity!',
                      );

                      model.analyticsService.track(
                        eventName:
                            AnalyticsEvents.maturitySelectionContinueTapped,
                        properties: {
                          'Choice Tapped': 'decide later',
                          "asset": model.floAssetType,
                          "amount": model.buyAmount,
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        'Decide later'.toUpperCase(),
                        style: TextStyles.rajdhaniB.body1.colour(Colors.white),
                      ),
                    ),
                  ),
                  MaterialButton(
                    height: SizeConfig.padding40,
                    minWidth: SizeConfig.screenWidth! * 0.4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: selectedOption.value == -1
                        ? Colors.white.withOpacity(0.25)
                        : Colors.white,
                    onPressed: () {
                      if (selectedOption.value == -1) {
                        BaseUtil.showNegativeAlert(
                          "Please select an option",
                          "proceed by choosing an option",
                        );
                        return;
                      }

                      if (selectedOption.value == 3) {
                        BaseUtil.openModalBottomSheet(
                          isBarrierDismissible: true,
                          addToScreenStack: true,
                          backgroundColor: const Color(0xff1B262C),
                          content: WarningBottomSheet(model: model),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness24),
                            topRight: Radius.circular(SizeConfig.roundness24),
                          ),
                          hapticVibrate: true,
                          isScrollControlled: true,
                        );
                        return;
                      }

                      AppState.backButtonDispatcher?.didPopRoute();

                      SystemChannels.textInput.invokeMethod('TextInput.hide');

                      model.analyticsService.track(
                        eventName:
                            AnalyticsEvents.maturitySelectionContinueTapped,
                        properties: {
                          'Choice Tapped': model.getMaturityTitle(),
                          "asset": model.floAssetType,
                          "amount": model.buyAmount,
                        },
                      );

                      // if (!model.isBuyInProgress) {
                      //   FocusScope.of(context).unfocus();
                      //   model.initiateBuy();
                      // }
                    },
                    child: Center(
                      child: Text(
                        'Continue'.toUpperCase(),
                        style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionContainer extends StatelessWidget {
  final int optionIndex;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionContainer({
    required this.optionIndex,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: SizeConfig.padding16,
          left: SizeConfig.padding16,
          right: SizeConfig.padding16,
        ),
        padding: EdgeInsets.all(SizeConfig.padding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          border: Border.all(
            color: isSelected
                ? UiConstants.kTabBorderColor // Change color when selected
                : const Color(0xFFD3D3D3).withOpacity(0.2),
            width: SizeConfig.border1,
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
                        : const Color(0xFFD3D3D3).withOpacity(0.2),
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
            SizedBox(
              width: SizeConfig.padding16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.rajdhaniB.body1,
                ),
                SizedBox(
                  height: SizeConfig.padding2,
                ),
                Text(
                  description,
                  style: TextStyles.sourceSans.body3
                      .colour(const Color(0xffA9C6D6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WarningBottomSheet extends StatelessWidget {
  const WarningBottomSheet({required this.model, Key? key}) : super(key: key);

  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.padding24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to withdraw your investment after ${model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months (Maturity)?',
            style: TextStyles.sourceSans.body2,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Text(
            'You will miss out on extra returns for the next tenure!',
            style: TextStyles.sourceSans.body3
                .colour(Colors.white.withOpacity(0.8)),
            maxLines: 2,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: SizeConfig.screenWidth! * 0.4,
                  height: SizeConfig.padding40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  // color: Colors.white,
                  onPressed: () {
                    debugPrint("scrrenStack => ${AppState.screenStack}");

                    AppState.backButtonDispatcher!.didPopRoute();
                    AppState.backButtonDispatcher!.didPopRoute();

                    model.analyticsService.track(
                        eventName: AnalyticsEvents.maturityWithdrawPopupTapped,
                        properties: {'Option Selected': "Yes"});

                    // debugPrint("scrrenStack => ${AppState.screenStack}");
                    // model.forcedBuy = true;
                    //
                    // Future.delayed(const Duration(milliseconds: 100), () async {
                    //   if (!model.isBuyInProgress) {
                    //     debugPrint(
                    //         "Buy in progress => ${model.isBuyInProgress}");
                    //     FocusScope.of(context).unfocus();
                    //     await model.initiateBuy();
                    //   }
                    // });
                  },
                  child: Center(
                    child: Text(
                      'YES',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.white),
                    ),
                  ),
                ),
                MaterialButton(
                  height: SizeConfig.padding40,
                  minWidth: SizeConfig.screenWidth! * 0.4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  onPressed: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                    AppState.backButtonDispatcher!.didPopRoute();

                    model.analyticsService.track(
                        eventName: AnalyticsEvents.maturityWithdrawPopupTapped,
                        properties: {'Option Selected': "No"});
                  },
                  child: Center(
                    child: Text(
                      'NO',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InvestmentForeseenWidget extends StatelessWidget {
  const InvestmentForeseenWidget(
      {required this.amount,
      required this.assetType,
      required this.isLendboxOldUser,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final String amount;
  final String assetType;
  final bool isLendboxOldUser;
  final OnAmountChanged onChanged;

  String getTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "in 12% Flo";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "in 10% Flo";
    }
    return "";
  }

  String getSubTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "for 6 months";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "for 3 months";
    }
    return "";
  }

  String calculateAmountAfter6Months(String amount) {
    int interest = assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;
    int timeInMonths = assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 2 : 4;

    // 0.12 / 365 * amt * (365 / 2)
    //0.10 / 365 * amt * (365 / 4)

    double amountAfterMonths =
        rateOfInterest / 365 * principal * (365 / timeInMonths);

    onChanged(amountAfterMonths);

    return (principal + amountAfterMonths).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    if (assetType == Constants.ASSET_TYPE_FLO_FELXI) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.all(SizeConfig.padding16),
      margin: EdgeInsets.only(bottom: SizeConfig.padding24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You Invest",
                style: TextStyles.rajdhaniSB.body3,
              ),
              Text(
                "₹${double.tryParse(amount)?.toStringAsFixed(2)}",
                style: TextStyles.sourceSansB.title5,
              )
            ],
          ),
          Column(
            children: [
              Text(
                getTitle(),
                style: TextStyles.rajdhaniB.body2
                    .colour(UiConstants.kTabBorderColor),
              ),
              Text(
                getSubTitle(),
                style: TextStyles.sourceSansB.body3,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You get",
                style: TextStyles.rajdhaniSB.body3,
              ),
              Text(
                "₹${calculateAmountAfter6Months(amount)}",
                style: TextStyles.sourceSansB.title5,
              )
            ],
          )
        ],
      ),
    );
  }
}

class MaturityPrefModalSheet extends StatefulWidget {
  const MaturityPrefModalSheet({
    required this.amount,
    required this.assetType,
    required this.txnId,
    super.key,
    this.hasConfirmed = false,
  });

  final String amount;
  final String assetType;
  final String txnId;
  final bool hasConfirmed;

  @override
  State<MaturityPrefModalSheet> createState() => _MaturityPrefModalSheetState();
}

class _MaturityPrefModalSheetState extends State<MaturityPrefModalSheet> {
  String maturityPref = "NA";
  int _selectedOption = -1;
  bool _isLoading = false;
  bool isEnable = false;

  @override
  void initState() {
    super.initState();

    maturityAmount = calculateAmountAfterMaturity(widget.amount);
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  int get selectedOption => _selectedOption;

  set selectedOption(int value) {
    setState(() {
      _selectedOption = value;
      isEnable = true;
    });
  }

  String maturityAmount = "";

  String calculateAmountAfterMaturity(String amount) {
    int interest =
        widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;
    int timeInMonths =
        widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 2 : 4;

    // 0.12 / 365 * amt * (365 / 2)
    //0.10 / 365 * amt * (365 / 4)

    double amountAfterMonths =
        rateOfInterest / 365 * principal * (365 / timeInMonths);

    return (principal + amountAfterMonths).toStringAsFixed(2);
  }

  String get subtitle =>
      "At the end of ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months (Maturity)";

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeConfig.screenHeight! * 0.6,
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            InvestmentForeseenWidget(
                amount: widget.amount,
                assetType: widget.assetType,
                isLendboxOldUser: locator<UserService>()
                    .userSegments
                    .contains(Constants.US_FLO_OLD),
                onChanged: (value) {
                  // setState(() {
                  //   maturityAmount = value.toStringAsFixed(2);
                  // });
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "What do you want to do ",
                      style: TextStyles.sourceSans.body2,
                      children: [
                        TextSpan(
                          text:
                              "after ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months?",
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
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness5),
                  topRight: Radius.circular(SizeConfig.roundness5),
                ),
                color: UiConstants.kSnackBarPositiveContentColor,
              ),
              child: Text(
                'Recommended',
                style: TextStyles.sourceSansSB.body4,
              ),
            ),
            OptionContainer(
              optionIndex: 1,
              title:
                  'Re-invest ₹$maturityAmount in ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "12" : "10"}% Flo',
              description: subtitle,
              isSelected: selectedOption == 1,
              onTap: () {
                maturityPref = "1";
                selectedOption = 1;
              },
            ),
            OptionContainer(
              optionIndex: 2,
              title:
                  "Move ₹$maturityAmount to ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "10" : "8"}% Flo",
              description: subtitle,
              isSelected: selectedOption == 2,
              onTap: () {
                maturityPref = "2";
                selectedOption = 2;
              },
            ),
            OptionContainer(
              optionIndex: 3,
              title: "Withdraw to Bank",
              description: subtitle,
              isSelected: selectedOption == 3,
              onTap: () {
                maturityPref = "0";
                selectedOption = 3;
              },
            ),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: MaterialButton(
                height: SizeConfig.padding40,
                minWidth: SizeConfig.screenWidth!,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white.withOpacity(isEnable ? 1 : 0.5),
                onPressed: () async {
                  if (selectedOption == -1) {
                    BaseUtil.showNegativeAlert("Please select an option",
                        "proceed by choosing an option");
                    return;
                  }

                  if (!isLoading) {
                    isLoading = true;

                    final LendboxMaturityService maturityService =
                        locator<LendboxMaturityService>();

                    bool? hasConfirmed = maturityService.filteredDeposits
                        ?.any((element) => element.txnId == widget.txnId);

                    final res = await locator<LendboxRepo>()
                        .updateUserInvestmentPreference(
                            widget.txnId, maturityPref,
                            hasConfirmed: hasConfirmed ?? false);
                    if (res.isSuccess()) {
                      unawaited(AppState.backButtonDispatcher!.didPopRoute());
                      locator<LendboxMaturityService>().init();
                      BaseUtil.showPositiveAlert(
                          "You preference recorded successfully",
                          "We'll contact you if required");
                    } else {
                      BaseUtil.showNegativeAlert(
                          res.errorMessage, "Please try again");
                    }
                  }
                },
                child: Center(
                  child: isLoading
                      ? SpinKitThreeBounce(
                          color: Colors.black,
                          size: SizeConfig.padding24,
                        )
                      : Text(
                          'Proceed'.toUpperCase(),
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
