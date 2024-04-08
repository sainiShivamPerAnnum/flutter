import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/list_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputView extends StatefulWidget {
  final TextEditingController? amountController;
  final List<UserOption> chipAmounts;
  final int bestChipIndex;
  final String? notice;
  final bool isEnabled;
  final num maxAmount;
  final num minAmount;
  final String maxAmountMsg;
  final String minAmountMsg;
  final FocusNode focusNode;
  final bool readOnly;
  final VoidCallback onTap;
  final LendboxBuyViewModel model;
  final bool isBuyView;

  const AmountInputView({
    required this.chipAmounts,
    required this.amountController,
    required this.isEnabled,
    required this.maxAmount,
    required this.minAmount,
    required this.maxAmountMsg,
    required this.minAmountMsg,
    required this.focusNode,
    required this.readOnly,
    required this.onTap,
    required this.model,
    super.key,
    this.bestChipIndex = 1,
    this.notice,
    this.isBuyView = true,
  });

  @override
  State<AmountInputView> createState() => _AmountInputViewState();
}

class _AmountInputViewState extends State<AmountInputView> {
  @override
  void initState() {
    super.initState();
    widget.model.updateFieldWidth();
  }

  @override
  Widget build(BuildContext context) {
    final currentAmt = double.tryParse(widget.amountController!.text) ?? 0;
    final AnalyticsService analyticsService = locator<AnalyticsService>();

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
              Row(
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
                    width: widget.model.fieldWidth,
                    child: TextFormField(
                      key: const ValueKey('floAmountInput'),
                      autofocus: true,
                      showCursor: true,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                      controller: widget.amountController,
                      focusNode: widget.focusNode,
                      enabled: widget.isEnabled,
                      maxLength: widget.maxAmount.toString().length,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: widget.model.onValueChanged,
                      decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model.showHappyHourSubtitle(),
                    style: TextStyles.sourceSans.body3.bold.copyWith(
                      color: UiConstants.grey1,
                      height: 1,
                    ),
                  ),
                  if (widget.model.showInfoIcon) ...[
                    SizedBox(
                      width: SizeConfig.padding8,
                    ),
                    GestureDetector(
                      onTap: () {
                        analyticsService.track(
                          eventName: AnalyticsEvents.tambolaTicketInfoTapped,
                          properties: {
                            'Ticket count': widget.model.numberOfTambolaTickets,
                            'happy hour ticket count':
                                widget.model.happyHourTickets,
                          },
                        );

                        BaseUtil.openModalBottomSheet(
                          isBarrierDismissible: true,
                          addToScreenStack: true,
                          content: FloBreakdownView(
                            model: widget.model,
                            showPaymentOption: false,
                          ),
                          hapticVibrate: true,
                          isScrollControlled: true,
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: UiConstants.grey1,
                      ),
                    ),
                  ]
                ],
              ),
              if (widget.model.showMaxCapText)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding1),
                  child: Text(
                    widget.maxAmountMsg,
                    style: TextStyles.sourceSans.body4.bold.colour(
                      UiConstants.grey1,
                    ),
                  ),
                ),
              if (currentAmt < widget.minAmount)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding1),
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
                  isActive: widget.model.lastTappedChipIndex == i,
                  index: i,
                  amt: item.value,
                  isBest: item.best,
                  onClick: (index) {
                    widget.model.onChipClick(index);
                  },
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
      ],
    );
  }
}
