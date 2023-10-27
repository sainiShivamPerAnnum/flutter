import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/widget/lendbox_amount_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LendboxWithdrawalInputView extends StatelessWidget {
  final LendboxWithdrawalViewModel model;

  const LendboxWithdrawalInputView({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: SizeConfig.padding16),
            LendBoxAppBar(
              isEnabled: !model.inProgress,
              trackClosingEvent: () =>
                  AppState.backButtonDispatcher!.didPopRoute(),
              assetType: Constants.ASSET_TYPE_FLO_FELXI,
              isOldUser: locator<UserService>()
                  .userSegments
                  .contains(Constants.US_FLO_OLD),
            ),
            SizedBox(height: SizeConfig.padding32),
            if (model.state == ViewState.Idle &&
                (model.withdrawableQuantity?.lockedAmount ?? 0) > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                child: SellCardInfoStrips(
                  content: model.withdrawableQuantity!.lockedMessage,
                ),
              ),
            SizedBox(height: SizeConfig.padding32),
            LendboxAmountInputView(
              amountController: model.amountController,
              focusNode: model.fieldNode,
              chipAmounts: const [],
              isEnabled: !model.inProgress,
              readOnly: model.readOnly,
              onTap: () => model.readOnly = false,
              maxAmount: model.withdrawableQuantity?.amount ?? 2,
              maxAmountMsg: locale.txnWithDrawLimit,
              minAmount: model.minAmount,
              minAmountMsg: locale.txnWithDrawMin,
              notice: model.buyNotice,
              bestChipIndex: 1,
              onAmountChange: (int amount) {},
              // isbuyView: false,
            ),
            const Spacer(),
            model.withdrawableResponseMessage.isNotEmpty
                ? Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                        vertical: SizeConfig.padding10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness24),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding16,
                      vertical: SizeConfig.padding24,
                    ),
                    child: Text(
                      model.withdrawableResponseMessage,
                      style: TextStyles.body2.colour(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding38),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.txnWithdrawablebalance,
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            ),
                            Text(
                              '₹ ${model.withdrawableQuantity?.amount.toStringAsFixed(2) ?? 0}',
                              style: TextStyles.sourceSansSB.body0.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      model.state == ViewState.Busy || model.inProgress
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
                          : AppPositiveBtn(
                              btnText: locale.btnWithDraw.toUpperCase(),
                              onPressed: () async {
                                if (!model.inProgress) {
                                  FocusScope.of(context).unfocus();
                                  model.initiateWithdraw();
                                }
                              },
                              width: SizeConfig.screenWidth! * 0.813,
                            ),
                    ],
                  ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
          ],
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () => model.fieldNode.unfocus(),
        )
      ],
    );
  }
}
