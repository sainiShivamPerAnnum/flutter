import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorField extends StatefulWidget {
  CalculatorField({
    required this.label,
    required this.value,
    required this.requiresQuickButtons,
    this.isPercentage,
    this.onChangeEnd,
    super.key,
    this.prefixText,
    this.suffixText,
    this.changeFunction,
    this.inputFormatters,
    this.maxValue,
    this.textAlign,
    this.minValue,
    this.increment,
    this.decrement,
  });

  final Function(String)? changeFunction;
  final ValueChanged<int>? onChangeEnd;
  final bool requiresQuickButtons;
  final bool? isPercentage;
  final String label;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;
  final double? maxValue;
  final double? minValue;
  final TextAlign? textAlign;
  final double value;
  final VoidCallback? increment;
  final VoidCallback? decrement;

  @override
  State<CalculatorField> createState() => _CalculatorFieldState();
}

class _CalculatorFieldState extends State<CalculatorField> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.value.round().toString());
  }

  @override
  void didUpdateWidget(covariant CalculatorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _amountController.value = TextEditingValue(
        text: widget.value.round().toString(),
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: widget.value.round().toString().length,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: TextStyles.sourceSansSB.body2
                  .colour(UiConstants.kTextFieldTextColor),
            ),
            SizedBox(
              width: SizeConfig.padding100,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                controller: _amountController,
                textDirection:
                    widget.prefixText != null ? TextDirection.rtl : null,
                keyboardType: TextInputType.number,
                style: TextStyles.sourceSansSB.body2
                    .colour(UiConstants.kTextColor),
                onChanged: (value) {
                  widget.changeFunction!(value);
                },
                inputFormatters: widget.inputFormatters,
                textAlign: widget.textAlign ?? TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: UiConstants.kDividerColor),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: UiConstants.kDividerColor),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: UiConstants.kDividerColor),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: UiConstants.errorText),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: UiConstants.kErrorBorderColor),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: SizeConfig.padding8,
                        left: SizeConfig.padding12,
                        right: SizeConfig.padding12,
                        bottom: SizeConfig.padding8),
                    isDense: true,
                    errorStyle: const TextStyle(
                      fontSize: 0,
                      height: 0,
                    ),
                    prefixIcon: widget.prefixText != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding12,
                            ),
                            child: Text(
                              widget.prefixText!,
                              style: TextStyles.sourceSansSB.body2.colour(
                                  UiConstants
                                      .kModalSheetMutedTextBackgroundColor),
                            ),
                          )
                        : null,
                    suffixIcon: widget.suffixText != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding12,
                            ),
                            child: Text(
                              widget.suffixText!,
                              style: TextStyles.sourceSansSB.body2.colour(
                                  UiConstants
                                      .kModalSheetMutedTextBackgroundColor),
                            ),
                          )
                        : null,
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    prefixStyle:
                        TextStyles.sourceSansSB.body2.colour(Colors.white)),
              ),
            )
          ],
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        SliderTheme(
          data: SliderThemeData(
              trackHeight: 1,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: SizeConfig.roundness8,
              ),
              overlayShape: SliderComponentShape.noOverlay),
          child: Slider(
            value: widget.value < widget.minValue!
                ? widget.minValue!
                : widget.value,
            max: widget.maxValue!,
            min: widget.minValue!,
            onChanged: (value) {
              widget.changeFunction!(value.toInt().toString());
            },
            onChangeEnd: (v) => widget.onChangeEnd?.call(v.toInt()),
            thumbColor: Colors.white,
            activeColor: UiConstants.teal3,
            inactiveColor: Colors.white,
          ),
        )
      ],
    );
  }
}
