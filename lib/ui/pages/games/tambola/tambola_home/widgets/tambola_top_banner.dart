import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaTopBanner extends StatelessWidget {
  const TambolaTopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.06),
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins + SizeConfig.padding16,
        bottom: SizeConfig.pageHorizontalMargins,
      ),
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/tambola_1cr_bg.png')),
          color: UiConstants.kSnackBarPositiveContentColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.roundness12,
            ),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/1_cr.svg',
                height: 80,
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Win upto 1 Cr',
                    style: TextStyles.sourceSans.body2,
                  ),
                  Text(
                    'Tambola',
                    style: TextStyles.rajdhaniB.body0.copyWith(
                      fontSize: 22,
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
          const SizedBox(
            height: 18,
          ),
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
                'Today’s draw in 12: 00: 11',
                style: TextStyles.sourceSans.body4,
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
