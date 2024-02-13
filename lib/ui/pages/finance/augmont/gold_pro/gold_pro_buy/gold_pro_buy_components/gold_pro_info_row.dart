import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.text, required this.child});
  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
      child: Row(
        children: [
          Text(
            text,
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
            child: Align(alignment: Alignment.bottomRight, child: child),
          )
        ],
      ),
    );
  }
}
