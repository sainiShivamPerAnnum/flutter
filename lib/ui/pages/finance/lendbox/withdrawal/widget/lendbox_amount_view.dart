import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/util/list_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LendboxAmountInputView extends StatefulWidget {
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

  const LendboxAmountInputView(
      {required this.chipAmounts,
      required this.onAmountChange,
      required this.amountController,
      required this.isEnabled,
      required this.maxAmount,
      required this.minAmount,
      required this.maxAmountMsg,
      required this.minAmountMsg,
      required this.focusNode,
      required this.readOnly,
      required this.onTap,
      Key? key,
      this.bestChipIndex = 1,
      this.notice})
      : super(key: key);

  @override
  State<LendboxAmountInputView> createState() => _LendboxAmountInputViewState();
}

class _LendboxAmountInputViewState extends State<LendboxAmountInputView> {
  double _fieldWidth = 0;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    if (widget.chipAmounts.isNotEmpty) {
      _selectedIndex = widget.chipAmounts.indexWhere(
        (e) => e.value.toString() == (widget.amountController?.text ?? ''),
      );
    } else {
      widget.amountController!.text = '1';
    }
    updateFieldWidth();
  }

  void updateFieldWidth() {
    int n = widget.amountController!.text.length;
    if (n == 0) n++;
    _fieldWidth = (SizeConfig.padding40 * n.toDouble());
    widget.amountController!.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.amountController!.text.length));
  }

  @override
  Widget build(BuildContext context) {
    final currentAmt = double.tryParse(widget.amountController!.text) ?? 0;
    if (currentAmt == null) widget.amountController!.text = "0.0";
    final AnalyticsService _analyticsService = locator<AnalyticsService>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
            vertical: SizeConfig.padding20,
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
                  Text(
                    "₹",
                    style: TextStyles.rajdhaniB.title0.colour(
                      widget.amountController!.text == "0"
                          ? UiConstants.kTextColor2
                          : UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  AnimatedContainer(
                    duration: const Duration(seconds: 0),
                    curve: Curves.easeIn,
                    width: _fieldWidth,
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
                        setState(() {
                          updateFieldWidth();
                        });
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
                      style: TextStyles.rajdhaniB.title68.colour(
                        widget.amountController!.text == "0"
                            ? UiConstants.kTextColor2
                            : UiConstants.kTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (currentAmt > widget.maxAmount)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: Text(
                    widget.maxAmountMsg,
                    style: TextStyles.sourceSans.body4.bold
                        .colour(Colors.red[400]),
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
              .mapIndexed((item, i) => AmountChip(
                  isActive: _selectedIndex == i,
                  index: i,
                  amt: item.value,
                  isBest: item.best,
                  onClick: (amt) {
                    _analyticsService!.track(
                        eventName: AnalyticsEvents.suggestedAmountTapped,
                        properties: {
                          'order': i,
                          'Amount': amt,
                          'Best flag': item.best
                        });
                    setState(() {
                      _selectedIndex = i;
                      widget.amountController!.text =
                          widget.chipAmounts[i].value.toString();
                      updateFieldWidth();
                    });
                  }))
              .toList(),
        ),
      ],
    );
  }
}
