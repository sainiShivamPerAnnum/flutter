import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProCard extends StatelessWidget {
  const GoldProCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth! * 0.4,
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          color: UiConstants.kGoldProBgColor,
          border: Border.all(color: UiConstants.kGoldProBorder),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Earn 4.5% Extra Returns with Gold Pro",
                  style: TextStyles.rajdhaniM.body2
                      .colour(UiConstants.kGoldProPrimary),
                ),
              ],
            ),
          ],
        )
        // Stack(
        //   clipBehavior: Clip.none,
        //   children: [
        //     Align(
        //       alignment: Alignment.center,
        //       child: Transform.rotate(
        //         angle: 13,
        //         child: Container(
        //           width: 50,
        //           height: 1000,
        //           color: const Color(0xff383735),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
