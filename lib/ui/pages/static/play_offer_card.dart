import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final PlayViewModel model;
  final int i;
  OfferCard({this.model, this.i});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.6,
      height: SizeConfig.screenWidth * 0.34,
      margin: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins / 2),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.germsPattern), fit: BoxFit.cover),
        color: model.offerList[i].bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: model.offerList[i].bgColor.withOpacity(0.3),
            offset: Offset(
              0,
              SizeConfig.screenWidth * 0.15,
            ),
            spreadRadius: -44,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.07,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.offerList[i].title1,
              style: TextStyles.title5.colour(Colors.white).bold,
            ),
            SizedBox(height: SizeConfig.padding6),
            Text(
              model.offerList[i].title2,
              style: TextStyles.title5.colour(Colors.white).bold,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth * 0.171,
              height: SizeConfig.screenWidth * 0.065,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                model.offerList[i].buttonText,
                style: TextStyles.body4.colour(Colors.white).bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
