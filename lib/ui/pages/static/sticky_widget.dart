import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class StickyNote extends StatelessWidget {
  const StickyNote(
      {required this.trailingWidget, required this.amount, Key? key})
      : super(key: key);
  final Widget trailingWidget;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight! * 0.07,
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      decoration: BoxDecoration(
        border:
            Border.all(color: UiConstants.kModalSheetSecondaryBackgroundColor),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          tileMode: TileMode.mirror,
          end: Alignment.centerRight,
          stops: const [0, 0.5, 0.5, 1],
          colors: [
            UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.2),
            UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.2),
            Colors.transparent,
            Colors.transparent
          ],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth! * 0.41,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹$amount",
                  style: TextStyles.sourceSansB.title3,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Saved",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSansSB.body3,
                )
              ],
            ),
          ),
          Text('=', style: TextStyles.sourceSansB.title1),
          SizedBox(width: SizeConfig.screenWidth! * 0.41, child: trailingWidget)
        ],
      ),
    );
  }
}
