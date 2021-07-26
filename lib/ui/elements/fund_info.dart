import 'package:felloapp/ui/elements/marquee_widget.dart';
import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

class FundInfo extends StatelessWidget {
  final List<String> infoList;
  FundInfo({this.infoList});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 5, vertical: 16),
      child: MarqueeWidget(
        pauseDuration: Duration(seconds: 3),
        animationDuration: Duration(seconds: 5),
        backDuration: Duration(seconds: 5),
        direction: Axis.horizontal,
        child: Row(
            children: List.generate(
                infoList.length,
                (index) => FundHighlight(
                      highlight: infoList[index],
                    ))),
      ),
    );
  }
}

class FundHighlight extends StatelessWidget {
  final String highlight;
  FundHighlight({this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.mediumTextSize / 4,
            backgroundColor: augmontGoldPalette.primaryColor,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            highlight,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: augmontGoldPalette.secondaryColor,
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
        ],
      ),
    );
  }
}
