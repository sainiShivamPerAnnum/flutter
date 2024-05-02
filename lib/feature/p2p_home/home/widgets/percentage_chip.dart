import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class PercentageChip extends StatelessWidget {
  const PercentageChip({required this.value, this.size, super.key});
  final double value;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(value >= 0 ? '▲' : '▼',
            style: TextStyles.sourceSans.body3.colour(
                value >= 0 ? UiConstants.teal3 : UiConstants.errorText)),
        Text("${value.toStringAsFixed(2)}%",
            style: TextStyles.sourceSans.body3
                .colour(value >= 0 ? UiConstants.teal3 : UiConstants.errorText))
      ],
    );
  }
}
