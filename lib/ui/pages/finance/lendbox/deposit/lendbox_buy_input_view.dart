import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LendboxBuyInputView extends StatelessWidget {
  final int? amount;
  final bool? skipMl;
  final LendboxBuyViewModel model;

  const LendboxBuyInputView({
    Key? key,
    this.amount,
    this.skipMl,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    final AnalyticsService? _analyticsService = locator<AnalyticsService>();
    if (model.state == ViewState.Busy) return Center(child: FullScreenLoader());

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: SizeConfig.padding16),
            LendboxAppBar(
              isEnabled: !model.isBuyInProgress,
              trackClosingEvent: () {
                _analyticsService!.track(
                    eventName: AnalyticsEvents.savePageClosed,
                    properties: {
                      "Amount entered": model.amountController!.text,
                      "Asset": 'Flo',
                    });
                if (locator<BackButtonActions>().isTransactionCancelled) {
                  locator<BackButtonActions>()
                      .showWantToCloseTransactionBottomSheet(
                          double.parse(model.amountController!.text)
                              .round(),
                          InvestmentType.LENDBOXP2P, () {
                    model.initiateBuy();
                    AppState.backButtonDispatcher!.didPopRoute();
                  });
                  return;
                }
              },
            ),
            SizedBox(height: SizeConfig.padding32),
            BannerWidget(
              model: model.assetOptionsModel!.data.banner,
              happyHourCampign:
                  locator.isRegistered<HappyHourCampign>() ? locator() : null,
            ),
            AmountInputView(
              amountController: model.amountController,
              focusNode: model.buyFieldNode,
              chipAmounts: model.assetOptionsModel!.data.userOptions,
              isEnabled: !model.isBuyInProgress,
              maxAmount: model.maxAmount,
              maxAmountMsg: locale.upto50000,
              minAmount: model.minAmount,
              minAmountMsg: locale.minPurchaseText1,
              notice: model.buyNotice,
              onAmountChange: (int amount) {},
              bestChipIndex: 2,
              readOnly: model.readOnly,
              onTap: () => model.showKeyBoard(),
            ),
            Spacer(),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            PropertyChangeConsumer<BankAndPanService,
                BankAndPanServiceProperties>(
              properties: [
                BankAndPanServiceProperties.kycVerified,
              ],
              builder: (ctx, service, child) {
                return (!service!.isKYCVerified)
                    ? _kycWidget(model, context)
                    : model.isBuyInProgress
                        ? Container(
                            height: SizeConfig.screenWidth! * 0.1556,
                            alignment: Alignment.center,
                            width: SizeConfig.screenWidth! * 0.7,
                            child: LinearProgressIndicator(
                              color: UiConstants.primaryColor,
                              backgroundColor: UiConstants.kDarkBackgroundColor,
                            ),
                          )
                        : AppPositiveBtn(
                            btnText: locale.btnSave,
                            onPressed: () async {
                              if (!model.isBuyInProgress) {
                                FocusScope.of(context).unfocus();
                                model.initiateBuy();
                              }
                            },
                            width: SizeConfig.screenWidth! * 0.813,
                          );
              },
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
          ],
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () => model.buyFieldNode.unfocus(),
        )
      ],
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
        ],
      ),
    );
  }
}
