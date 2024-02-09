import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorField extends StatelessWidget {
  const CalculatorField({
    required this.requiresSlider,
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

  final Function(int)? changeFunction;
  final ValueChanged<int>? onChangeEnd;
  final bool requiresSlider;
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyles.sourceSansSB.body2
                  .colour(UiConstants.kTextFieldTextColor),
            ),
            Container(
              width: SizeConfig.padding100,
              padding: EdgeInsets.only(
                  top: SizeConfig.padding8,
                  left: SizeConfig.padding12,
                  right: SizeConfig.padding12,
                  bottom: SizeConfig.padding8),
              decoration: BoxDecoration(
                  border: Border.all(color: UiConstants.kDividerColor),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
              child: TextField(
                controller: TextEditingController(
                    text: isPercentage != null && isPercentage!
                        ? '${formatValue(value.toDouble())}%'
                        : formatValue(value.toDouble())),
                textDirection: prefixText != null ? TextDirection.rtl : null,
                keyboardType: TextInputType.number,
                style: TextStyles.sourceSansSB.body2
                    .colour(UiConstants.kTextColor),
                onSubmitted: (value) {
                  changeFunction!(int.parse(value));
                },
                inputFormatters: inputFormatters,
                textAlign: textAlign ?? TextAlign.start,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    prefixIcon: prefixText != null
                        ? Text(
                            prefixText!,
                            style: TextStyles.sourceSansSB.body2.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor),
                          )
                        : null,
                    suffixIcon: suffixText != null
                        ? Text(
                            suffixText!,
                            style: TextStyles.sourceSansSB.body2.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor),
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
        if (requiresSlider)
          SizedBox(
            height: SizeConfig.padding12,
          ),
        if (requiresSlider)
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 1,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: SizeConfig.roundness8,
                ),
                overlayShape: SliderComponentShape.noOverlay),
            child: Slider(
              value: value,
              max: maxValue ?? 30,
              min: minValue ?? 0,
              onChanged: (value) {
                changeFunction!(value.toInt());
              },
              onChangeEnd: (v) => onChangeEnd?.call(v.toInt()),
              thumbColor: Colors.white,
              activeColor: UiConstants.teal3,
              inactiveColor: Colors.white,
            ),
          )
      ],
    );
  }
}

String formatValue(double value) {
  return value == value.floor()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
}
