import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SilverComparisonSection extends StatelessWidget {
  const SilverComparisonSection({
    required this.backgroundColor,
    super.key,
  });
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: SizeConfig.padding20),
      color: UiConstants.kArrowButtonBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding20,
              vertical: SizeConfig.padding10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                    child: RichText(
                      text: TextSpan(
                        text: "Silver ", 
                        style:
                            TextStyles.rajdhaniSB.title3.colour(Colors.white),
                        children: [
                          TextSpan(
                            text: "vs ",
                            style: TextStyles.rajdhaniSB.title3.colour(
                              const Color.fromARGB(255, 131, 225, 248),
                            ),
                          ),
                          TextSpan(
                            text: "other investments",
                            style: TextStyles.rajdhaniSB.title3
                                .colour(Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding24,
                      vertical: SizeConfig.padding10,
                    ),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [

                          Color.fromARGB(255, 49, 56, 59),
                          Color.fromARGB(255, 20, 31, 36),
                          Color.fromARGB(255, 1, 55, 74),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.silverAsset,
                          height: SizeConfig.screenHeight! * 0.09,
                          width: SizeConfig.screenHeight! * 0.09,
                        ),
                        SizedBox(
                          width: SizeConfig.padding32,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Digital Silver",
                              style: TextStyles.sourceSans.body3,
                            ),
                            SizedBox(
                              width: SizeConfig.padding20,
                            ),
                            Text(
                              "23%",
                               style: TextStyles.rajdhaniSB.title1.copyWith(
                                color: const Color.fromARGB(255, 168, 238, 255),

                              ),
                            ),
                            Text(
                             "Returns*",
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white.withOpacity(0.6)),
                            ),
                            Text(
                              '(Per annum)',
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white.withOpacity(0.6)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  CarouselSlider(
                    items: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding24,
                          vertical: SizeConfig.padding10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.crypto,
                              height: SizeConfig.screenHeight! * 0.12,
                              width: SizeConfig.screenHeight! * 0.12,
                            ),
                            SizedBox(
                              width: SizeConfig.padding32,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                              "Crypto",
                              style: TextStyles.sourceSans.body3,
                              ),
                              SizedBox(
                                width: SizeConfig.padding20,
                              ),
                              Text(
                                "20%",
                                style: TextStyles.rajdhaniSB.title1,
                              ),
                              Text(
                              "Returns*",
                                style: TextStyles.sourceSans.body3
                                    .colour(Colors.white.withOpacity(0.4)),
                              ),
                            ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding24,
                          vertical: SizeConfig.padding10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.volatile,
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FDs",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Low returns\nHigh lock-in",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding24,
                          vertical: SizeConfig.padding10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/stocks.svg",
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stocks",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Volatile Returns\nHigh risk",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding24,
                          vertical: SizeConfig.padding10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff323232),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bonds.svg",
                              height: SizeConfig.screenHeight! * 0.15,
                              width: SizeConfig.screenHeight! * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.padding24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bonds",
                                  style: TextStyles.sourceSans.body3,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding10,
                                ),
                                Text(
                                  "Stable returns\nHigh Lock-in",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white.withOpacity(0.4)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 2.75,
                      viewportFraction: 0.8,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    "VS",
                    style: TextStyles.sourceSansB.body2,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
