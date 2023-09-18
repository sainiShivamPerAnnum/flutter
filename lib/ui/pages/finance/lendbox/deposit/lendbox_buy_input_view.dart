import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/flo_coupon.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
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
    // SpotLightController.instance.userFlow = UserFlow.floInputView;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("floAssetType ${widget.model.floAssetType}");

    S locale = S.of(context);
    final AnalyticsService analyticsService = locator<AnalyticsService>();
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
                    analyticsService.track(
                        eventName: AnalyticsEvents.savePageClosed,
                        properties: {
                          "Amount entered": widget.model.amountController!.text,
                          "Asset": widget.model.floAssetType,
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
                  minAmount: widget.model.minAmount.toDouble(),
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
                if (widget.model.showCoupons) ...[
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
                  FloCouponWidget(
                    widget.model.couponList,
                    widget.model,
                    onTap: (coupon) {
                      widget.model.applyCoupon(coupon.code, false);
                    },
                  ),
                  SizedBox(height: SizeConfig.padding24),
                ],

                MaturityDetailsWidget(model: widget.model),
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
                          ? Container(
                              height: SizeConfig.screenWidth! * 0.1556,
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth! * 0.7,
                              child: const LinearProgressIndicator(
                                color: UiConstants.primaryColor,
                                backgroundColor:
                                    UiConstants.kDarkBackgroundColor,
                              ),
                            )
                          : FloBuyNavBar(
                              model: widget.model,
                              onTap: () {
                                locator<AnalyticsService>().track(
                                    eventName: AnalyticsEvents.saveInitiate,
                                    properties: {
                                      "investmentType":
                                          InvestmentType.LENDBOXP2P.name,
                                    });
                                if ((widget.model.buyAmount ?? 0) <
                                    widget.model.minAmount) {
                                  BaseUtil.showNegativeAlert("Invalid Amount",
                                      "Please Enter Amount Greater than ${widget.model.minAmount}");
                                  return;
                                }

                                if (!widget.model.isBuyInProgress) {
                                  FocusScope.of(context).unfocus();
                                  widget.model.initiateBuy();
                                }
                              },
                            );
                },
              )),
          CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus(),
          ),
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
          AppNegativeBtn(
            btnText: locale.completeKYCText,
            onPressed: model.navigateToKycScreen,
            width: SizeConfig.screenWidth,
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
      return '10% Returns p.a.';
    } else if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        !model.isLendboxOldUser) {
      return '8% Returns p.a.';
    }

    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "12% Returns p.a.";
    }
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "10% Returns p.a.";
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
          GestureDetector(
            onTap: () {
              BaseUtil.openModalBottomSheet(
                isBarrierDismissible: true,
                addToScreenStack: true,
                content: FloBreakdownView(
                  model: model,
                  showPsp: false,
                ),
                hapticVibrate: true,
                isScrollControlled: true,
              );
              locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.viewBreakdownTapped,
                  properties: {
                    'Amount Filled': model.amountController?.text ?? '0',
                    'Asset': model.floAssetType,
                    'coupon': model.appliedCoupon
                  });
            },
            child: Column(
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
                Text(
                  'View Breakdown',
                  style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.kTextFieldTextColor,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
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
                onPressed: () {
                  if (model.isIntentFlow) {
                    BaseUtil.openModalBottomSheet(
                      isBarrierDismissible: true,
                      addToScreenStack: true,
                      content: FloBreakdownView(
                        model: model,
                        showBreakDown:
                            AppConfig.getValue(AppConfigKey.payment_brief_view),
                      ),
                      hapticVibrate: true,
                      isScrollControlled: true,
                    );
                  } else {
                    onTap();
                  }
                },
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

class MaturityDetailsWidget extends StatelessWidget {
  const MaturityDetailsWidget({Key? key, required this.model})
      : super(key: key);

  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Selector<BankAndPanService, bool>(
      selector: (p0, p1) => p1.isKYCVerified,
      builder: (ctx, isKYCVerified, child) {
        return (!isKYCVerified)
            ? const SizedBox()
            : (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ||
                    model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3)
                ? GestureDetector(
                    onTap: () {
                      if (!model.isBuyInProgress) {
                        model.openReinvestBottomSheet();
                      }

                      model.analyticsService.track(
                          eventName: AnalyticsEvents.maturityChoiceTapped,
                          properties: {
                            'amount': model.buyAmount,
                            "asset": model.floAssetType,
                          });
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: SizeConfig.pageHorizontalMargins),
                            color: UiConstants
                                .kModalSheetSecondaryBackgroundColor
                                .withOpacity(0.2),
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                          Text(
                            'Maturity Details',
                            style: TextStyles.sourceSansSB.body1,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              model.showReinvestSubTitle(),
                              Text(
                                model.selectedOption == -1
                                    ? 'Choose Now'
                                    : "Change",
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTabBorderColor)
                                    .underline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
      },
    );
  }
}
