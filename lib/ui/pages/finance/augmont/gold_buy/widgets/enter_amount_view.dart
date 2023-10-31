import "dart:math" as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EnterAmountView extends StatelessWidget {
  const EnterAmountView({
    required this.model,
    required this.txnService,
    super.key,
  });

  final GoldBuyViewModel model;
  final AugmontTransactionService txnService;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (model.buyNotice != null && model.buyNotice!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryLight,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                    ),
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(SizeConfig.padding16),
                    child: Text(
                      model.buyNotice!,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.light,
                    ),
                  ),
                AnimatedBuilder(
                    animation: model.animationController!,
                    builder: (context, _) {
                      final sineValue = math.sin(
                          3 * 2 * math.pi * model.animationController!.value);
                      return Transform.translate(
                        offset: Offset(sineValue * 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹",
                              style: TextStyles.rajdhaniB.title0.colour(
                                  model.goldAmountController!.text == "0"
                                      ? UiConstants.kTextColor2
                                      : UiConstants.kTextColor),
                            ),
                            // SizedBox(width: SizeConfig.padding10),
                            AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              curve: Curves.easeIn,
                              width: model.fieldWidth,
                              child: TextFormField(
                                autofocus: true,
                                readOnly: model.readOnly,
                                showCursor: true,
                                controller: model.goldAmountController,
                                focusNode: model.buyFieldNode,
                                enabled: !txnService.isGoldBuyInProgress &&
                                    !model.couponApplyInProgress,
                                validator: (val) {
                                  return null;
                                },
                                onChanged: model.onBuyValueChanged,
                                onTap: model.showKeyBoard,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  // isCollapse: true,
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyles.rajdhaniB.title0.colour(
                                  model.goldAmountController!.text == "0"
                                      ? UiConstants.kTextColor2
                                      : UiConstants.kTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.showHappyHourSubtitle(),
                      style: TextStyles.sourceSans.body3.copyWith(
                        color: UiConstants.grey1,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    if (model.showInfoIcon)
                      GestureDetector(
                        onTap: () => locator<BaseUtil>().showHappyHourDialog(
                            locator<HappyHourCampign>(),
                            isComingFromSave: true),
                        child: const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: UiConstants.grey1,
                        ),
                      ),
                  ],
                ),
                if (model.showMaxCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      locale.maxAmountMessage(model.maxAmount),
                      style: TextStyles.sourceSans.body4.bold
                          .colour(UiConstants.grey1),
                    ),
                  ),
                if (model.showMinCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      locale.minAmountMessage(model.minAmount),
                      style: TextStyles.sourceSans.body4.bold
                          .colour(Colors.red[400]),
                    ),
                  ),
              ],
            ),
          ),
          if (model.assetOptionsModel != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                model.assetOptionsModel!.data.userOptions.length,
                (index) => AmountChipV2(
                  index: index,
                  isActive: model.lastTappedChipIndex == index,
                  amt: model.assetOptionsModel!.data.userOptions[index].value,
                  onClick: model.onChipClick,
                  isBest: model.assetOptionsModel!.data.userOptions[index].best,
                ),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            decoration: BoxDecoration(
              color: UiConstants.kArrowButtonBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            // margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding64),
            height: SizeConfig.padding38,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  model.isGoldRateFetching
                      ? SpinKitThreeBounce(
                          size: SizeConfig.body2,
                          color: UiConstants.primaryColor,
                        )
                      : Text(
                          "₹ ${(model.goldRates != null ? model.goldRates!.goldBuyPrice : 0.0)?.toStringAsFixed(2)}/gm",
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.grey1),
                        ),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: Text(
                      "${model.goldAmountInGrams} ${locale.gms}",
                      style: TextStyles.sourceSans.body3,
                    ),
                  ),
                  VerticalDivider(
                    color: UiConstants.kModalSheetSecondaryBackgroundColor
                        .withOpacity(0.2),
                    width: 36,
                  ),
                  NewCurrentGoldPriceWidget(
                    fetchGoldRates: model.fetchGoldRates,
                    goldprice: model.goldRates != null
                        ? model.goldRates!.goldBuyPrice
                        : 0.0,
                    isFetching: model.isGoldRateFetching,
                    mini: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
