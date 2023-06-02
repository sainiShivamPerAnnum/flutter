import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/list_utils.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../util/show_case_key.dart';
import 'lendbox/deposit/lendbox_buy_input_view.dart';

class AmountInputView extends StatefulWidget {
  final TextEditingController? amountController;
  final List<UserOption> chipAmounts;

  final int bestChipIndex;
  final String? notice;
  final bool isEnabled;
  final double maxAmount;
  final double minAmount;
  final String maxAmountMsg;
  final String minAmountMsg;
  final FocusNode focusNode;
  final Function(int val) onAmountChange;
  final bool readOnly;
  final void Function() onTap;
  final LendboxBuyViewModel? model;
  final bool isbuyView;
  const AmountInputView(
      {Key? key,
      required this.chipAmounts,
      required this.onAmountChange,
      required this.amountController,
      required this.isEnabled,
      required this.maxAmount,
      required this.minAmount,
      required this.maxAmountMsg,
      required this.minAmountMsg,
      required this.focusNode,
      this.bestChipIndex = 1,
      this.notice,
      required this.readOnly,
      required this.onTap,
      this.isbuyView = true,
      this.model})
      : super(key: key);

  @override
  State<AmountInputView> createState() => _AmountInputViewState();
}

class _AmountInputViewState extends State<AmountInputView> {
  // double _fieldWidth = 0;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // if (widget.chipAmounts.isNotEmpty) {
    //   _selectedIndex = widget.chipAmounts.indexWhere(
    //     (e) => e.value.toString() == (widget.amountController?.text ?? ''),
    //   );
    // } else {
    //   widget.amountController!.text = '1';
    // }
    widget.model?.updateFieldWidth();
  }

  String getString() {
    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        (widget.model?.isLendboxOldUser ?? false)) {
      return 'Min- ₹100';
    } else if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        (widget.model?.isLendboxOldUser ?? true) == false) {
      return 'Min- ₹100';
    }

    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "Min- ₹25,000";
    }
    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "Min- ₹1000";
    }

    return "";
  }

  String getSubString() {
    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        (widget.model?.isLendboxOldUser ?? false)) {
      return '1 Month Maturity';
    } else if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        (widget.model?.isLendboxOldUser ?? true) == false) {
      return '1 Week Lock-in';
    }

    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "6 Month Maturity";
    }
    if (widget.model?.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "3 Month Maturity";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final currentAmt = double.tryParse(widget.amountController!.text) ?? 0;
    if (currentAmt == null) widget.amountController!.text = "0.0";
    // final AnalyticsService analyticsService = locator<AnalyticsService>();
    return Column(
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
              if (widget.notice != null && widget.notice!.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryLight,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: Text(
                    widget.notice!,
                    textAlign: TextAlign.center,
                    style: TextStyles.body3.light,
                  ),
                ),
              Showcase(
                key: ShowCaseKeys.floAmountKey,
                description:
                    'Edit or change the amount to deposit in Fello Flo',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "₹",
                        style: TextStyles.rajdhaniB.title50.colour(
                          widget.amountController!.text == "0"
                              ? UiConstants.kTextColor2
                              : UiConstants.kTextColor,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 0),
                      curve: Curves.easeIn,
                      width: widget.model?.fieldWidth ?? 0.0,
                      child: TextFormField(
                        autofocus: true,
                        showCursor: true,
                        readOnly: widget.readOnly,
                        onTap: () {
                          widget.onTap();
                        },
                        controller: widget.amountController,
                        focusNode: widget.focusNode,
                        enabled: widget.isEnabled,
                        validator: (val) {
                          return null;
                        },
                        maxLength: widget.maxAmount.toString().length,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (String val) {
                          widget.model?.onValueChanged(val);

                          // setState(updateFieldWidth);
                        },
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          // isCollapse: true,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          counter: Offstage(),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyles.rajdhaniB.title50.colour(
                          widget.amountController!.text == "0"
                              ? UiConstants.kTextColor2
                              : UiConstants.kTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.model != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.model?.showHappyHourSubtitle() ?? "",
                        style: TextStyles.sourceSans.body3.bold
                            .colour(UiConstants.primaryColor),
                      ),
                      SizedBox(
                        width: SizeConfig.padding4,
                      ),
                      if (widget.model?.showInfoIcon ?? false)
                        GestureDetector(
                          onTap: () => BaseUtil.openModalBottomSheet(
                            isBarrierDismissible: true,
                            addToScreenStack: true,
                            backgroundColor: const Color(0xff1A1A1A),
                            content: ViewBreakdown(model: widget.model!),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness24),
                              topRight: Radius.circular(SizeConfig.roundness24),
                            ),
                            hapticVibrate: true,
                            isScrollControlled: true,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Color(0xff62E3C4),
                          ),
                        ),
                    ],
                  ),
                ),
              if (widget.model?.showMaxCapText)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: Text(
                    widget.maxAmountMsg,
                    style: TextStyles.sourceSans.body4.bold
                        .colour(UiConstants.primaryColor),
                  ),
                ),
              if (currentAmt < widget.minAmount)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: Text(
                    widget.minAmountMsg,
                    style: TextStyles.sourceSans.body4.bold
                        .colour(Colors.red[400]),
                  ),
                ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.chipAmounts
              .mapIndexed(
                (item, i) => AmountChipV2(
                  isActive: widget.model?.lastTappedChipIndex == i,
                  index: i,
                  amt: item.value,
                  isBest: item.best,
                  onClick: (index) {
                    widget.model?.onChipClick(index);
                  },
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        if (widget.isbuyView)
          Container(
            // width: SizeConfig.screenWidth! * 0.72,
            decoration: BoxDecoration(
              color: UiConstants.kArrowButtonBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            // margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding64),
            height: SizeConfig.padding38,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.padding20),
                  child: Text(
                    getString(),
                    style: TextStyles.sourceSans.body3,
                  ),
                ),
                VerticalDivider(
                  color: UiConstants.kModalSheetSecondaryBackgroundColor
                      .withOpacity(0.2),
                  width: 4,
                ),
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.padding20),
                  child: Text(
                    getSubString(),
                    style: TextStyles.sourceSans.body3,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
