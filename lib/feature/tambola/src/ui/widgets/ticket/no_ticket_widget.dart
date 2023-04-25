import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoTicketWidget extends StatelessWidget {
  const NoTicketWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth! * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.noWinnersAsset,
            width: SizeConfig.screenWidth! * 0.2,
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
          Text(
            "No eligible tickets",
            style: TextStyles.sourceSans.body4.colour(Colors.white),
          ),
        ],
      ),
    );
  }
}
