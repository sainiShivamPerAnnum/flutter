import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/draw_time_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HappyHourBanner extends StatefulWidget {
  HappyHourBanner({Key? key}) : super(key: key);

  @override
  State<HappyHourBanner> createState() => _HappyHourBannerState();
}

class _HappyHourBannerState extends State<HappyHourBanner> with DrawTimeUtil {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.07,
      width: SizeConfig.screenWidth,
      child: Container(
        height: double.infinity,
        alignment: Alignment.centerLeft,
        color: Color(0xff495DB2),
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.sandTimer,
              height: 42,
              width: 42,
            ),
            SizedBox(
              width: 12,
            ),
            RichText(
              text: TextSpan(
                text: "Happy Hour ending in",
                style: TextStyles.sourceSans.body3.colour(Colors.white),
                children: [
                  TextSpan(
                      text: " $inHours: $inMinutes mins",
                      style: TextStyles.sourceSansB.body3.colour(Colors.white)),
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
