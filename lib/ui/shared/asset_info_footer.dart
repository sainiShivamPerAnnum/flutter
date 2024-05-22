import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AssetInfoFooter extends StatelessWidget {
  const AssetInfoFooter({
    required this.isGold,
    super.key,
    this.toShowText = true,
  });
  final bool isGold;
  final bool toShowText;

  @override
  Widget build(BuildContext context) {
    const String goldTitle = "11% Returns gained from\nDigital Gold in 2022";
    const String felloTitle = "₹1000 invested every \nminute on Fello Flo";
    final title = isGold ? goldTitle : felloTitle;
    final list = title.split(" ");
    final highlightedText = list.first;
    list.removeAt(0);
    final remaining = list.join(" ");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding32,
                ),
                Image.asset(
                  isGold ? Assets.goldConveyor : Assets.floConveyor,
                  fit: BoxFit.fill,
                  width: SizeConfig.screenHeight! * 0.4,
                ),
              ],
            ),
          ),
          if (toShowText)
            Positioned(
              left: SizeConfig.padding44,
              child: RichText(
                text: TextSpan(
                  text: "$highlightedText ",
                  style: TextStyles.sourceSansSB.title5.colour(
                    UiConstants.grey1.withOpacity(0.7),
                  ),
                  children: [
                    TextSpan(
                      text: remaining,
                      style: TextStyles.sourceSansSB.title5.colour(
                        UiConstants.kTextColor2,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
