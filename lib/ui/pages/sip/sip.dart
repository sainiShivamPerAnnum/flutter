import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/sip/edit_sip_bottomsheet.dart';
import 'package:felloapp/ui/pages/sip/select_sip.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class CalculatorField extends StatelessWidget {
  const CalculatorField(
      {required this.requiresSlider,
      required this.label,
      required this.value,
      required this.requiresQuickButtons,
      super.key,
      this.prefixText,
      this.suffixText,
      this.changeFunction,
      this.maxValue,
      this.minValue,
      this.increment,
      this.decrement});
  final Function(int)? changeFunction;
  final bool requiresSlider;
  final bool requiresQuickButtons;
  final String label;
  final String? prefixText;
  final String? suffixText;
  final double? maxValue;
  final double? minValue;
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
              style:
                  TextStyles.sourceSansSB.body2.colour(UiConstants.textGray70),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: SizeConfig.padding100,
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding8,
                      left: SizeConfig.padding12,
                      right: SizeConfig.padding12,
                      bottom: SizeConfig.padding8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12)),
                  child: TextField(
                    controller: TextEditingController(
                      text: '',
                    ),
                    //  requiresQuickButtons
                    //     ? SipViewModel.formatValue(value.toDouble()) + '%'
                    //     : SipViewModel.formatValue(value.toDouble())),
                    textDirection:
                        prefixText != null ? TextDirection.rtl : null,
                    keyboardType: TextInputType.number,
                    style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    onSubmitted: (value) {
                      changeFunction!(int.parse(value));
                    },
                    textAlign: requiresQuickButtons
                        ? TextAlign.center
                        : TextAlign.start,
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
                ),
                if (requiresQuickButtons)
                  Positioned(
                    left: -10,
                    top: 10,
                    child: InkWell(
                      onTap: decrement,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: UiConstants.grey5),
                        child: Icon(
                          Icons.remove,
                          color: UiConstants.kTextColor,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                if (requiresQuickButtons)
                  Positioned(
                    left: 92,
                    top: 10,
                    // offset: Offset(92, 10),
                    child: InkWell(
                      onTap: increment,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: UiConstants.grey5),
                        child: Icon(
                          Icons.add,
                          color: UiConstants.kTextColor,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
        // SizedBox(
        //   height: SizeConfig.padding16,
        // ),
        if (requiresSlider)
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: SizeConfig.roundness8,
              ),
              trackShape: CustomTrackShape(),
            ),
            child: Slider(
              value: value,
              max: maxValue ?? 1,
              min: minValue ?? 0,
              onChanged: (value) {
                changeFunction!(value.toInt());
              },
              thumbColor: Colors.white,
              activeColor: UiConstants.teal3,
              inactiveColor: Colors.white,
            ),
          )
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 1.3;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
