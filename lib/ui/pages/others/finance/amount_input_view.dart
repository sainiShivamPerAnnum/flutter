import 'package:felloapp/ui/pages/others/finance/amount_chip.dart';
import 'package:felloapp/util/list_utils.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputView extends StatefulWidget {
  final TextEditingController amountController;
  final List<int> chipAmounts;
  final int bestChipIndex;
  final String notice;
  final bool isEnabled;
  final double maxAmount;
  final double minAmount;
  final String maxAmountMsg;
  final String minAmountMsg;
  final FocusNode focusNode;
  final Function(int val) onAmountChange;

  const AmountInputView({
    Key key,
    @required this.chipAmounts,
    @required this.onAmountChange,
    @required this.amountController,
    @required this.isEnabled,
    @required this.maxAmount,
    @required this.minAmount,
    @required this.maxAmountMsg,
    @required this.minAmountMsg,
    @required this.focusNode,
    this.bestChipIndex = 1,
    this.notice,
  }) : super(key: key);

  @override
  State<AmountInputView> createState() => _AmountInputViewState();
}

class _AmountInputViewState extends State<AmountInputView> {
  double _fieldWidth = 0;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    updateFieldWidth();
  }

  void updateFieldWidth() {
    int n = widget.amountController.text.length;
    if (n == 0) n++;
    _fieldWidth = (SizeConfig.padding40 * n.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final currentAmt = double.tryParse(widget.amountController.text) ?? 0;
    if (currentAmt == null) widget.amountController.text = "0.0";
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
              if (widget.notice != null && widget.notice.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryLight,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: Text(
                    widget.notice,
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
                      widget.amountController.text == "0"
                          ? UiConstants.kTextColor2
                          : UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  AnimatedContainer(
                    duration: Duration(seconds: 0),
                    curve: Curves.easeIn,
                    width: _fieldWidth,
                    child: TextFormField(
                      controller: widget.amountController,
                      focusNode: widget.focusNode,
                      enabled: widget.isEnabled,
                      validator: (val) {
                        return null;
                      },
                      maxLength: widget.maxAmount.toString().length,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (String val) {
                        setState(() {
                          this.updateFieldWidth();
                        });
                      },
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        // isCollapsed: true,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        counter: Offstage(),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyles.rajdhaniB.title68.colour(
                        widget.amountController.text == "0"
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
                  amt: item,
                  isBest: widget.bestChipIndex == i,
                  onClick: (amt) {
                    setState(() {
                      _selectedIndex = i;
                      widget.amountController.text = amt.toString();
                      this.updateFieldWidth();
                    });
                  }))
              .toList(),
        ),
      ],
    );
  }
}
