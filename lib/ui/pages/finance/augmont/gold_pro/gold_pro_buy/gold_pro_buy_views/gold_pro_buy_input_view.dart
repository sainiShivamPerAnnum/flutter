import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_balance_rows.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_choice_chips.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProBuyInputView extends StatelessWidget {
  const GoldProBuyInputView(
      {required this.model, required this.txnService, super.key});

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                Assets.digitalGoldBar,
                width: SizeConfig.padding54,
                height: SizeConfig.padding54,
              ),
              // SizedBox(width: SizeConfig.padding8),
              Text(
                'Digital Gold Pro',
                style: TextStyles.rajdhaniSB.title5,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.padding20),
              Text(
                "Select value to save in Gold Pro",
                style: TextStyles.rajdhani.body1.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                padding: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  color: UiConstants.kBackgroundColor2,
                ),
                child: Column(
                  children: [
                    Text(
                      "Gold Value",
                      style: TextStyles.rajdhaniM.body2.colour(Colors.white54),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.remove),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                width: SizeConfig.title3 * 2,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                                child: TextField(
                                  controller: model.goldFieldController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: TextStyles.rajdhaniBL.title1
                                      .colour(Colors.white),
                                ),
                              ),
                              Text(
                                "gms",
                                style: TextStyles.sourceSansB.body0
                                    .colour(Colors.white),
                              )
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GoldProChoiceChip(
                          chipValue: "0.5g",
                          isBest: false,
                          isSelected: 0 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(0),
                        ),
                        GoldProChoiceChip(
                          chipValue: "2.5g",
                          isBest: true,
                          isSelected: 1 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(1),
                        ),
                        GoldProChoiceChip(
                          chipValue: "7.5g",
                          isBest: false,
                          isSelected: 2 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(2),
                        ),
                        GoldProChoiceChip(
                          chipValue: "10g",
                          isBest: false,
                          isSelected: 3 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(3),
                        ),
                      ],
                    ),
                    // SizedBox(height: SizeConfig.padding8),
                    SizedBox(
                      width: SizeConfig.screenWidth! * 0.82,
                      child: Slider(
                        value: model.sliderValue,
                        onChanged: model.updateSliderValue,
                        divisions: 3,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness16),
                      topRight: Radius.circular(SizeConfig.roundness16)),
                  color: Colors.black,
                ),
                child: Column(children: [
                  GoldBalanceRow(
                    lead: "You are adding",
                    trail: model.totalGoldBalance,
                    isBold: true,
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  GoldBalanceRow(
                    lead: "Current Gold Balance",
                    trail: model.currentGoldBalance,
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  ExpectedGoldProReturnsRow(model: model),
                  SizedBox(height: SizeConfig.padding18),
                  ReactivePositiveAppButton(
                    btnText: "PROCEED",
                    onPressed: () {
                      txnService.currentTransactionState =
                          TransactionState.overView;
                    },
                  )
                ]),
              )
            ],
          ),
        )
      ],
    );
  }
}
