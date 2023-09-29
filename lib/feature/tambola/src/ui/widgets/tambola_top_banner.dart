import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaTopBanner extends StatelessWidget {
  const TambolaTopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.06),
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins + SizeConfig.padding16,
        bottom: SizeConfig.pageHorizontalMargins,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kSnackBarPositiveContentColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            SizeConfig.roundness12,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.one_cr_bg, height: SizeConfig.padding90),
              SizedBox(width: SizeConfig.padding8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Win upto 1 Crore',
                    style: TextStyles.sourceSansL.title3,
                  ),
                  Text(
                    'Tambola',
                    style: TextStyles.rajdhaniB.title1.copyWith(
                      shadows: [
                        const Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                    color: const Color(0xffFFD979),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        SizeConfig.roundness56,
                      ),
                    )),
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                'Today’s draw at 6 PM',
                style: TextStyles.sourceSansSB.body3,
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: const Color(0xffFFD979),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      SizeConfig.roundness56,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
