import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_scheme_model.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_balance_rows.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_choice_chips.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GoldProBuyInputView extends StatelessWidget {
  const GoldProBuyInputView(
      {required this.model, required this.txnService, super.key});

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;

  Widget _buildButtonLabel(bool isKycVerified, bool hasEnoughBalance) {
    final style = TextStyles.rajdhaniB.body1.colour(
      Colors.white,
    );

    if (!isKycVerified) {
      return Text(
        'COMPLETE KYC TO SAVE',
        style: style,
      );
    }

    if (isKycVerified && hasEnoughBalance) {
      return Text(
        'PROCEED',
        style: style,
      );
    }

    if (isKycVerified && !hasEnoughBalance) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
              '₹ ${model.totalGoldAmount}',
              style: TextStyles.sourceSansSB.title4.colour(
                Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              'SAVE',
              style: style,
            ),
            SizedBox(
              width: SizeConfig.padding16,
            ),
            Transform.rotate(
              angle: pi / 2,
              child: SvgPicture.asset(
                Assets.arrow,
                color: Colors.white,
                height: 8,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.digitalGoldBar,
                    width: SizeConfig.padding54,
                    height: SizeConfig.padding54,
                  ),
                  // SizedBox(width: SizeConfig.padding8),
                  Text(
                    Constants.ASSET_GOLD_STAKE,
                    style: TextStyles.rajdhaniSB.title5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.padding16),
                  Text(
                    "Select value to save in ${Constants.ASSET_GOLD_STAKE}",
                    style: TextStyles.rajdhani.body1.colour(Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    padding: EdgeInsets.all(SizeConfig.padding16),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                      color: UiConstants.kBackgroundColor2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Gold Value",
                          style:
                              TextStyles.rajdhaniM.body2.colour(Colors.white54),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  model.decrementGoldBalance();
                                },
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    width: (SizeConfig.padding22 +
                                                SizeConfig.padding1) *
                                            model.goldFieldController.text
                                                .replaceAll('.', "")
                                                .length +
                                        (model.goldFieldController.text
                                                .contains('.')
                                            ? SizeConfig.padding6
                                            : 0),
                                    duration: const Duration(seconds: 0),
                                    curve: Curves.easeIn,
                                    child: TextField(
                                      maxLength: 3,
                                      controller: model.goldFieldController,
                                      keyboardType: TextInputType.number,
                                      onChanged: model.onTextFieldValueChanged,
                                      inputFormatters: [
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          var decimalSeparator = NumberFormat()
                                              .symbols
                                              .DECIMAL_SEP;
                                          var r = RegExp(r'^\d*(\' +
                                              decimalSeparator +
                                              r'\d*)?$');
                                          return r.hasMatch(newValue.text)
                                              ? newValue
                                              : oldValue;
                                        })
                                      ],
                                      decoration: const InputDecoration(
                                        counter: Offstage(),
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
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  model.incrementGoldBalance();
                                },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              model.chipsList.length,
                              (index) => GoldProChoiceChip(
                                index: index,
                                chipValue: "${model.chipsList[index].value}g",
                                isBest: model.chipsList[index].isBest,
                                isSelected: index == model.selectedChipIndex,
                                onTap: () => model.onChipSelected(index),
                              ),
                            )),
                        SizedBox(
                          width: SizeConfig.screenWidth!,
                          child: Slider(
                            value: model.sliderValue,
                            onChanged: model.updateSliderValue,
                            // divisions: 4,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding16,
                      horizontal: SizeConfig.padding16,
                    ),
                    color: UiConstants.kBackgroundColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        SizeConfig.padding10,
                        SizeConfig.padding14,
                        SizeConfig.padding14,
                        SizeConfig.padding14,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.goldAsset,
                            width: SizeConfig.padding50,
                          ),
                          SizedBox(
                            width: SizeConfig.padding4,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Expected Returns in 5Y",
                                      style:
                                          TextStyles.body2.colour(Colors.white),
                                    ),
                                    Text(
                                      "₹${"${model.expectedGoldReturns.toInt()}".formatToIndianNumberSystem()}*",
                                      style: TextStyles.sourceSansB.body1
                                          .colour(Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.padding4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "with Gold Pro",
                                      style:
                                          TextStyles.body4.colour(Colors.grey),
                                    ),
                                    Text(
                                      "  with extra ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% returns",
                                      style:
                                          TextStyles.body4.colour(Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.roundness16),
                          topRight: Radius.circular(SizeConfig.roundness16)),
                      color: UiConstants.grey5,
                    ),
                    child: model.state == ViewState.Busy
                        ? FullScreenLoader(
                            size: SizeConfig.screenWidth! * 0.3,
                          )
                        : model.unavailabilityText.isNotEmpty
                            ? SizedBox(
                                width: SizeConfig.screenWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Alert!",
                                      style: TextStyles.rajdhaniB.body0
                                          .colour(Colors.white),
                                    ),
                                    SizedBox(height: SizeConfig.padding10),
                                    model.unavailabilityText.beautify(
                                      style: TextStyles.sourceSans.body2
                                          .colour(Colors.white70),
                                      boldStyle: TextStyles.sourceSansB.body2
                                          .colour(Colors.white),
                                      alignment: TextAlign.center,
                                    )
                                  ],
                                ),
                              )
                            : Column(mainAxisSize: MainAxisSize.min, children: [
                                LeaseAmount(
                                  model: model,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Current Gold Balance",
                                      style: TextStyles.sourceSans.body3.colour(
                                        UiConstants.grey1,
                                      ),
                                    ),
                                    Text(
                                      "${BaseUtil.digitPrecision(model.currentGoldBalance, 4, true)}gms",
                                      style: TextStyles.sourceSansSB.body2,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.padding8,
                                ),
                                const GoldProLeaseCompanyDetailsStrip(),
                                SizedBox(height: SizeConfig.padding10),
                                Consumer<BankAndPanService>(
                                  builder: (context, panService, child) =>
                                      ReactivePositiveAppButton(
                                    onPressed: () {
                                      panService.isKYCVerified
                                          ? model.onProceedTapped()
                                          : model.onCompleteKycTapped();
                                    },
                                    child: _buildButtonLabel(
                                      panService.isKYCVerified,
                                      model.additionalGoldBalance == 0,
                                    ),
                                  ),
                                ),
                              ]),
                  )
                ],
              ),
            )
          ],
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () {
            FocusScope.of(context).unfocus();
          },
        )
      ],
    );
  }
}

class GoldProLeaseCompanyDetailsStrip extends StatelessWidget {
  const GoldProLeaseCompanyDetailsStrip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AugmontTransactionService, GoldProSchemeModel?>(
      selector: (p0, p1) => p1.goldProScheme,
      builder: (ctx, scheme, child) => GestureDetector(
        onTap: () {
          if (scheme != null) {
            BaseUtil.openModalBottomSheet(
                isBarrierDismissible: true,
                addToScreenStack: true,
                backgroundColor: UiConstants.kBackgroundColor2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness16),
                  topRight: Radius.circular(SizeConfig.roundness16),
                ),
                hapticVibrate: true,
                content: WillPopScope(
                  onWillPop: () async {
                    AppState.removeOverlay();
                    return Future.value(true);
                  },
                  child: Container(
                    margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    child: scheme != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12),
                                    image: DecorationImage(
                                      image: NetworkImage(scheme.logo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: SizeConfig.padding54,
                                  width: SizeConfig.padding54,
                                ),
                                title: Text(
                                  scheme.jewellerUserAccountName,
                                  style: TextStyles.sourceSansB.body1
                                      .colour(Colors.white),
                                ),
                                subtitle: Text(
                                  "Estd. ${scheme.yearOfOperation}",
                                  style: TextStyles.body3
                                      .colour(UiConstants.kFAQsAnswerColor),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Business Type:",
                                  style:
                                      TextStyles.body3.colour(Colors.white60),
                                ),
                                trailing: Text(
                                  "Wholesaler, Manufacturer",
                                  style: TextStyles.body3
                                      .colour(UiConstants.kFAQsAnswerColor),
                                ),
                              ),
                              if (scheme.description.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding12),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Description:",
                                        style: TextStyles.body3
                                            .colour(Colors.white60),
                                      ),
                                      SizedBox(width: SizeConfig.padding20),
                                      Expanded(
                                        child: Text(
                                          scheme.description
                                              .checkOverFlow(maxLength: 100),
                                          style: TextStyles.body3.colour(
                                              UiConstants.kFAQsAnswerColor),
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator.adaptive()),
                  ),
                ));
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
          child: Row(
            children: [
              Text(
                "Leasing to ",
                style: TextStyles.sourceSans.body3.copyWith(
                  color: UiConstants.grey1,
                  height: 1,
                ),
              ),
              const Icon(
                Icons.info_outline,
                color: UiConstants.kFAQsAnswerColor,
                size: 14,
              ),
              Expanded(
                child: Text(
                  (scheme?.jewellerUserAccountName ?? "-").toUpperCase(),
                  textAlign: TextAlign.end,
                  style: TextStyles.sourceSans.body2.copyWith(
                    color: UiConstants.textGray70,
                    height: 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
