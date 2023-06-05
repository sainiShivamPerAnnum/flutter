import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/flo_coupon.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class LendboxBuyInputView extends StatefulWidget {
  final int? amount;
  final bool? skipMl;
  final LendboxBuyViewModel model;

  // final String floAssetType;

  const LendboxBuyInputView({
    Key? key,
    this.amount,
    this.skipMl,
    required this.model,
    // required this.floAssetType,
  }) : super(key: key);

  @override
  State<LendboxBuyInputView> createState() => _LendboxBuyInputViewState();
}

class _LendboxBuyInputViewState extends State<LendboxBuyInputView> {
  @override
  void initState() {
    SpotLightController.instance.userFlow = UserFlow.floInputView;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("floAssetType ${widget.model.floAssetType}");

    S locale = S.of(context);
    final AnalyticsService _analyticsService = locator<AnalyticsService>();
    if (widget.model.state == ViewState.Busy) {
      return const Center(child: FullScreenLoader());
    }
    AppState.onTap = () {
      widget.model.initiateBuy();
      AppState.backButtonDispatcher!.didPopRoute();
    };
    AppState.type = InvestmentType.LENDBOXP2P;
    AppState.amt = double.tryParse(widget.model.amountController!.text) ?? 0;
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // SizedBox(height: SizeConfig.fToolBarHeight / 2),
                LendBoxAppBar(
                  isOldUser: widget.model.isLendboxOldUser,
                  assetType: widget.model.floAssetType,
                  isEnabled: !widget.model.isBuyInProgress,
                  trackClosingEvent: () {
                    _analyticsService!.track(
                        eventName: AnalyticsEvents.savePageClosed,
                        properties: {
                          "Amount entered": widget.model.amountController!.text,
                          "Asset": 'Flo',
                        });
                    if (locator<BackButtonActions>().isTransactionCancelled) {
                      if (AppState.delegate!.currentConfiguration!.key ==
                              'LendboxBuyViewPath' &&
                          (AppState.screenStack.last != ScreenItem.modalsheet ||
                              AppState.screenStack.last != ScreenItem.dialog) &&
                          !AppState.isRepeated) {
                        locator<BackButtonActions>()
                            .showWantToCloseTransactionBottomSheet(
                                double.parse(
                                        widget.model.amountController!.text)
                                    .round(),
                                InvestmentType.LENDBOXP2P, () {
                          widget.model.initiateBuy();
                          AppState.backButtonDispatcher!.didPopRoute();
                        });
                        AppState.isRepeated = true;
                        return;
                      } else {
                        AppState.backButtonDispatcher!.didPopRoute();
                      }
                    } else {
                      AppState.backButtonDispatcher!.didPopRoute();
                    }
                  },
                ),
                SizedBox(height: SizeConfig.padding32),
                BannerWidget(
                  model: widget.model.assetOptionsModel!.data.banner,
                  happyHourCampign: locator.isRegistered<HappyHourCampign>()
                      ? locator()
                      : null,
                ),
                AmountInputView(
                  amountController: widget.model.amountController,
                  focusNode: widget.model.buyFieldNode,
                  chipAmounts: widget.model.assetOptionsModel!.data.userOptions,
                  isEnabled:
                      !widget.model.isBuyInProgress || !widget.model.forcedBuy,
                  maxAmount: widget.model.maxAmount,
                  maxAmountMsg: widget.model.floAssetType ==
                          Constants.ASSET_TYPE_FLO_FIXED_6
                      ? 'Upto ₹ 99,999 can be invested at one go'
                      : locale.upto50000,
                  minAmount: widget.model.minAmount,
                  minAmountMsg:
                      "Minimum purchase amount is ₹ ${widget.model.minAmount.toInt()}",
                  notice: widget.model.buyNotice,
                  onAmountChange: (int amount) {},
                  bestChipIndex: 2,
                  readOnly: widget.model.readOnly,
                  onTap: () => widget.model.showKeyBoard(),
                  model: widget.model,
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  color: UiConstants.kModalSheetSecondaryBackgroundColor
                      .withOpacity(0.2),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                if (widget.model.showCoupons) ...[
                  FloCouponWidget(
                    widget.model.couponList,
                    widget.model,
                    onTap: (coupon) {
                      widget.model.applyCoupon(coupon.code, false);
                    },
                  ),
                  // const Spacer(),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                ],

                if (widget.model.floAssetType ==
                        Constants.ASSET_TYPE_FLO_FIXED_6 ||
                    widget.model.floAssetType ==
                        Constants.ASSET_TYPE_FLO_FIXED_3)
                  GestureDetector(
                    onTap: () {
                      if (!widget.model.isBuyInProgress) {
                        widget.model.openReinvestBottomSheet();
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                      ),
                      child: Text('What will happen at maturity?',
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTabBorderColor)),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Selector<BankAndPanService, bool>(
              selector: (p0, p1) => p1.isKYCVerified,
              builder: (ctx, isKYCVerified, child) {
                return (!isKYCVerified)
                    ? _kycWidget(widget.model, context)
                    : (widget.model.isBuyInProgress || widget.model.forcedBuy)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // if (widget.model.forcedBuy) ...[
                              //   Padding(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal:
                              //             SizeConfig.pageHorizontalMargins),
                              //     child: Text(
                              //       "We will contact you before the end of 6 months (Maturity) to confirm.",
                              //       style: TextStyles.sourceSans.body2
                              //           .colour(Colors.white.withOpacity(0.8)),
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              //   SizedBox(height: SizeConfig.padding24),
                              // ],
                              Container(
                                height: SizeConfig.screenWidth! * 0.1556,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.7,
                                child: const LinearProgressIndicator(
                                  color: UiConstants.primaryColor,
                                  backgroundColor:
                                      UiConstants.kDarkBackgroundColor,
                                ),
                              ),
                            ],
                          )
                        : FloBuyNavBar(
                            model: widget.model,
                            onTap: () {
                              if ((widget.model.buyAmount ?? 0) <
                                  widget.model.minAmount) {
                                BaseUtil.showNegativeAlert("Invalid Amount",
                                    "Please Enter Amount Greater than ${widget.model.minAmount}");
                                return;
                              }

                              // if (widget.model.floAssetType ==
                              //     Constants.ASSET_TYPE_FLO_FIXED_6) {
                              //   widget.model.openReinvestBottomSheet();
                              //   return;
                              // }
                              // if (widget.model.floAssetType ==
                              //         Constants.ASSET_TYPE_FLO_FIXED_3 &&
                              //     !widget.model.isLendboxOldUser) {
                              //   widget.model.openReinvestBottomSheet();
                              //   return;
                              // }

                              if (!widget.model.isBuyInProgress) {
                                FocusScope.of(context).unfocus();
                                widget.model.initiateBuy();
                              }
                            },
                          );
              },
            ),
          ),
          CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus(),
          )
        ],
      ),
    );
  }

  Widget _kycWidget(LendboxBuyViewModel model, BuildContext context) {
    S locale = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              locale.kycIncomplete,
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.kTextColor,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Showcase(
            key: ShowCaseKeys.floKYCKey,
            description:
                'Complete your KYC to start your journey towards 12% returns',
            child: AppNegativeBtn(
              btnText: locale.completeKYCText,
              onPressed: model.navigateToKycScreen,
              width: SizeConfig.screenWidth,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
        ],
      ),
    );
  }
}

class FloBuyNavBar extends StatelessWidget {
  const FloBuyNavBar({
    super.key,
    required this.model,
    required this.onTap,
  });

  final LendboxBuyViewModel model;
  final Function onTap;

  String getTitle() {
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        model.isLendboxOldUser) {
      return 'in Flo 10% P.A';
    } else if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        !model.isLendboxOldUser) {
      return 'in Flo 8% P.A';
    }

    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "in Flo 12% P.A";
    }
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "in Flo 10% P.A";
    }

    return "";
  }

  String getSubString() {
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI) {
      return 'Lock-in till ${DateFormat('d MMM yyyy').format(model.assetOptionsModel!.data.maturityAt!)}';
    }

    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ||
        model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "Maturity on ${DateFormat('d MMM yyyy').format(model.assetOptionsModel!.data.maturityAt!)}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding32,
        vertical: SizeConfig.padding16,
      ),
      color: UiConstants.kArrowButtonBackgroundColor,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${model.amountController?.text ?? '0'}",
                    style: TextStyles.sourceSansSB.title5
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  Text(
                    getTitle(),
                    style: TextStyles.rajdhaniB.body2
                        .copyWith(color: UiConstants.kTabBorderColor),
                  ),
                ],
              ),
              Text(getSubString(),
                  style: TextStyles.rajdhaniSB.body3
                      .colour(UiConstants.kTextFieldTextColor)),
              SizedBox(
                height: SizeConfig.padding10,
              ),
              GestureDetector(
                onTap: () {
                  BaseUtil.openModalBottomSheet(
                    isBarrierDismissible: true,
                    addToScreenStack: true,
                    backgroundColor: const Color(0xff1A1A1A),
                    content: ViewBreakdown(model: model),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness24),
                      topRight: Radius.circular(SizeConfig.roundness24),
                    ),
                    hapticVibrate: true,
                    isScrollControlled: true,
                  );
                },
                child: Text(
                  'View Breakdown',
                  style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.kTextFieldTextColor,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (model.appliedCoupon != null) ...[
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.35,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        Assets.ticketTilted,
                        width: SizeConfig.padding16,
                      ),
                      SizedBox(
                        width: SizeConfig.padding6,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${model.appliedCoupon?.code} coupon applied',
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTealTextColor),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding4,
                )
              ],
              AppPositiveBtn(
                width: SizeConfig.screenWidth! * 0.32,
                height: SizeConfig.screenWidth! * 0.12,
                onPressed: () => onTap(),
                btnText: 'SAVE',
                style: TextStyles.rajdhaniB.body1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewBreakdown extends StatelessWidget {
  const ViewBreakdown({
    Key? key,
    required this.model,
  }) : super(key: key);

  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // AppState.backButtonDispatcher?.didPopRoute();
        return true;
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.padding28,
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            InvestmentForeseenWidget(
              amount: model.amountController?.text ?? '0',
              assetType: model.floAssetType,
              isLendboxOldUser: model.isLendboxOldUser,
              onChanged: (_) {},
            ),
            Row(
              children: [
                Text("Fello Flo Amount", style: TextStyles.sourceSansSB.body1),
                const Spacer(),
                Text(
                  "₹${model.amountController?.text ?? '0'}",
                  style: TextStyles.sourceSansSB.body1,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Row(
              children: [
                Text(
                  "Investment date",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  // format today's date like this "3rd Mar 2023",
                  DateFormat('d MMM yyyy').format(DateTime.now()),
                  style: TextStyles.sourceSansSB.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Row(
              children: [
                Text(
                  model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI
                      ? "Lockin Period"
                      : "Maturity date",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  DateFormat('d MMM, yyyy')
                      .format(model.assetOptionsModel!.data.maturityAt!),
                  style: TextStyles.sourceSansSB.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            if ((model.totalTickets ?? 0) > 0) ...[
              Container(
                height: 1,
                color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                children: [
                  SizedBox(
                    height: SizeConfig.padding28,
                    width: SizeConfig.padding28,
                    child: SvgPicture.asset(
                      Assets.howToPlayAsset1Tambola,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                  Text(
                    "Total Tambola Tickets",
                    style: TextStyles.sourceSansSB.body1,
                  ),
                  const Spacer(),
                  Text(
                    "${model.totalTickets}",
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              if (model.showHappyHour) ...[
                Row(
                  children: [
                    Text(
                      "Happy Hour Tambola Tickets",
                      style: TextStyles.sourceSans.body2,
                    ),
                    const Spacer(),
                    Text(
                      "${model.happyHourTickets}",
                      style: TextStyles.sourceSans.body2,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Row(
                  children: [
                    Text(
                      "Lifetime Tambola Tickets",
                      style: TextStyles.sourceSans.body2,
                    ),
                    const Spacer(),
                    Text(
                      "${model.numberOfTambolaTickets}",
                      style: TextStyles.sourceSans.body2,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
              ],
            ],
            if (model.appliedCoupon != null) ...[
              Container(
                height: 1,
                color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.ticketTilted,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${model.appliedCoupon?.code} coupon applied',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTealTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding12,
              )
            ],
            AppPositiveBtn(
              width: SizeConfig.screenWidth!,
              onPressed: () async {
                if ((model.buyAmount ?? 0) < model.minAmount) {
                  BaseUtil.showNegativeAlert("Invalid Amount",
                      "Please Enter Amount Greater than ${model.minAmount}");
                  return;
                }

                AppState.backButtonDispatcher?.didPopRoute();

                // if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
                //   model.openReinvestBottomSheet();
                //   return;
                // }
                // if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3 &&
                //     !model.isLendboxOldUser) {
                //   model.openReinvestBottomSheet();
                //   return;
                // }

                if (!model.isBuyInProgress) {
                  FocusScope.of(context).unfocus();
                  await model.initiateBuy();
                }
              },
              btnText: 'Save'.toUpperCase(),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
          ],
        ),
      ),
    );
  }
}
