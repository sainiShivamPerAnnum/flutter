import 'dart:math';

import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeDetails extends StatelessWidget {
  FelloBadgeDetails({super.key});

  List<Color> colors = [
    const Color(0xFF5B413E),
    const Color(0xFF394B71),
    const Color(0xFF01646B)
  ];

  List<String> title = [
    "Beginner\nFello Level",
    "Intermediate\nFello Level",
    "Super\nFello Level"
  ];

  List<String> imageUrl = [
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg',
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-1.svg',
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg',
  ];

  List<String> benefits = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenHeight! * 0.765,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding2),
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              width: 310,
              constraints: const BoxConstraints(
                minHeight: 580,
              ),
              margin:
                  EdgeInsets.only(right: index == 2 ? 0 : SizeConfig.padding24),
              decoration: ShapeDecoration(
                color: colors[index],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  buildBackgroundStack(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title[index],
                              style: TextStyles.rajdhaniB.title2
                                  .colour(
                                    index == 2
                                        ? const Color(0xFFFFD979)
                                        : Colors.white,
                                  )
                                  .copyWith(
                                    height: 1.27,
                                  ),
                            ),
                            SvgPicture.network(
                              imageUrl[index],
                              height: SizeConfig.padding78,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        Container(
                          width: SizeConfig.padding86,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding8,
                              vertical: SizeConfig.padding4),
                          decoration: ShapeDecoration(
                            color: index == 0
                                ? const Color(0xFFEFD7D2)
                                : index == 1
                                    ? const Color(0xFFC9E4F0)
                                    : const Color(0xFFFFE9B1),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFF232326)),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock,
                                size: 15,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: SizeConfig.padding4,
                              ),
                              Text(
                                'LOCKED',
                                textAlign: TextAlign.right,
                                style: TextStyles.sourceSansB.body4.colour(
                                  Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: SizeConfig.padding128,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding12,
                              vertical: SizeConfig.padding12),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF79780).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/gift_icon.svg',
                                    height: SizeConfig.padding26,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding8,
                                  ),
                                  Text(
                                    'Benefits you get',
                                    textAlign: TextAlign.right,
                                    style: TextStyles.sourceSansSB.body1.colour(
                                      const Color(0xFFEFD7D2),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding8,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: index == 0 ? 1 : 4,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.padding14,
                                      ),
                                      Container(
                                        width: SizeConfig.padding6,
                                        height: SizeConfig.padding6,
                                        decoration: const ShapeDecoration(
                                          color: Colors.white,
                                          shape: CircleBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding14,
                                      ),
                                      Text(
                                        'Exclusive coupons',
                                        style:
                                            TextStyles.rajdhaniSB.body2.colour(
                                          Colors.white,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Text(
                          'Unlock Beginner Benefits',
                          style: TextStyles.sourceSansSB.body2.colour(
                            const Color(0xFFEFD7D2),
                          ),
                        ),
                        Text(
                          'Get these badges to unlock this level',
                          style: TextStyles.sourceSans.body3.colour(
                            Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding12,
                        ),
                        SizedBox(
                          // height: SizeConfig.screenHeight! * 0.35,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                height: SizeConfig.padding86,
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding16,
                                    vertical: SizeConfig.padding8),
                                decoration: ShapeDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.network(
                                      Assets.tambolaTitanBadge,
                                      height: SizeConfig.padding56,
                                      width: SizeConfig.padding50,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.padding12,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth! * 0.53,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Smart Saver',
                                                style: TextStyles
                                                    .sourceSans.body3
                                                    .colour(
                                                  Colors.white,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 12,
                                                weight: 700,
                                                grade: 200,
                                                opticalSize: 48,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: SizeConfig.padding4,
                                          ),
                                          Text(
                                            'Make your first savings',
                                            style: TextStyles.sourceSans.body4
                                                .colour(
                                              Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.padding4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 153.28,
                                                height: SizeConfig.padding6,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0.28,
                                                      top: 0,
                                                      child: Container(
                                                        width: SizeConfig
                                                            .padding168,
                                                        height:
                                                            SizeConfig.padding6,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.25),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: SizeConfig
                                                            .padding132,
                                                        height:
                                                            SizeConfig.padding6,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: const Color(
                                                              0xFFFFCCBF),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '80 %',
                                                textAlign: TextAlign.right,
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(
                                                  Colors.white
                                                      .withOpacity(0.75),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: SizeConfig.padding12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget buildBackgroundStack() {
    return ClipRRect(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.fToolBarHeight * 1.2,
          ),
          Transform.rotate(
            angle: -pi / 9,
            child: Transform.scale(
              scale: 1.3,
              child: Container(
                height: SizeConfig.padding28,
                width: SizeConfig.screenWidth!,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding36,
          ),
          Transform.rotate(
            angle: -pi / 9,
            child: Transform.scale(
              scale: 1.2,
              child: Container(
                height: SizeConfig.padding54,
                width: SizeConfig.screenWidth!,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          )
        ],
      ),
    );
  }
}
