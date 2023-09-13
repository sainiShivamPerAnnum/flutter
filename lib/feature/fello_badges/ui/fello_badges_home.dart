import 'dart:math';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FelloBadgeHome extends StatefulWidget {
  const FelloBadgeHome({super.key});

  @override
  State<FelloBadgeHome> createState() => _FelloBadgeHomeState();
}

class _FelloBadgeHomeState extends State<FelloBadgeHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FelloBadgesBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FAppBar(
                showHelpButton: true,
                type: FaqsType.yourAccount,
                showCoinBar: false,
                showAvatar: false,
                leadingPadding: false,
                action: Row(children: [
                  Selector2<UserService, ScratchCardService,
                      Tuple2<Portfolio?, int>>(
                    builder: (context, value, child) => FelloInfoBar(
                      svgAsset: Assets.scratchCard,
                      size: SizeConfig.padding16,
                      child: "₹${value.item1?.rewards.toInt() ?? 0}",
                      onPressed: () {
                        Haptic.vibrate();
                        AppState.delegate!.parseRoute(Uri.parse("myWinnings"));
                      },
                      mark: value.item2 > 0,
                    ),
                    selector: (p0, userService, scratchCardService) => Tuple2(
                        userService.userPortfolio,
                        scratchCardService.unscratchedTicketsCount),
                  ),
                ]),
              ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
              Stack(
                children: [
                  Text(
                    'Super Fello',
                    textAlign: TextAlign.center,
                    style: TextStyles.rajdhaniB.title1.colour(
                      Colors.white,
                    ),
                  ),
                  // Transform.translate(
                  //   offset: Offset(-1, -2),
                  //   child: Text(
                  //     'Super Fello',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyles.rajdhaniB.title1.copyWith(
                  //       // color: Colors.white,
                  //
                  //       foreground: Paint()
                  //         ..style = PaintingStyle.stroke
                  //         ..strokeWidth = 1
                  //         ..color = Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // SizedBox(
              //   height: SizeConfig.padding16,
              // ),
              const UserBadgeContainer(),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              "Become a *Super Fello* by\nwinning all the badges below"
                  .beautify(
                style: TextStyles.rajdhaniB.body1.colour(
                  Colors.white,
                ),
                boldStyle: TextStyles.rajdhaniB.body1.colour(
                  const Color(0xFF26F1CC),
                ),
                alignment: TextAlign.center,
              ),
              Stack(
                children: [
                  const UserProgressIndicator(),
                  Positioned(
                    right: SizeConfig.padding18,
                    top: SizeConfig.padding12,
                    child: CustomPaint(
                      size: Size(SizeConfig.padding26,
                          (SizeConfig.padding26 * 1).toDouble()),
                      painter: StarCustomPainter(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding34,
              ),
              FelloBadgeDetails(),
              SizedBox(
                height: SizeConfig.padding34,
              ),
              HowSuperFelloWorksWidget(
                isBoxOpen: false,
                onStateChanged: () {
                  // setState(() {});
                },
              ),
              SizedBox(
                height: SizeConfig.padding34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HowSuperFelloWorksWidget extends StatefulWidget {
  const HowSuperFelloWorksWidget(
      {super.key, required this.onStateChanged, this.isBoxOpen = true});

  final Function onStateChanged;
  final bool isBoxOpen;

  @override
  State<HowSuperFelloWorksWidget> createState() =>
      _HowSuperFelloWorksWidgetState();
}

class _HowSuperFelloWorksWidgetState extends State<HowSuperFelloWorksWidget> {
  bool isBoxOpen = false;

  @override
  void initState() {
    super.initState();
    isBoxOpen = widget.isBoxOpen;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
        vertical: SizeConfig.padding4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.01, 1.00),
          end: Alignment(0.01, -1),
          colors: [Color(0xFF3A393C), Color(0xFF232326)],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isBoxOpen = !isBoxOpen;
              });

              // Future.delayed(const Duration(milliseconds: 200), () {
              //   widget.onStateChanged();
              // });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.padding36),
                  child: Text(
                    'How SuperFello works?',
                    style: TextStyles.rajdhaniSB.body1,
                  ),
                ),
                const Spacer(),
                Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (isBoxOpen)
            SizedBox(
              height: SizeConfig.padding20,
            ),
          isBoxOpen
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeIn,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Earn a badge by completing a simple task',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      SizedBox(
                        height: 24,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: SizeConfig.padding1,
                                    height: SizeConfig.padding4,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffA5FCE7),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding4,
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      Text(
                        'You will auto collect that badge as the task is completed',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      SizedBox(
                        height: 24,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: SizeConfig.padding1,
                                    height: SizeConfig.padding4,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffA5FCE7),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding4,
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      Text(
                        'Increase level to SUPER Fello when you collect all 9 super badges',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

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

class UserBadgeContainer extends StatelessWidget {
  const UserBadgeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.padding132,
      height: SizeConfig.padding132,
      child: Stack(
        children: [
          Positioned(
            left: 0.95,
            top: 0,
            child: SizedBox(
              width: 112.05,
              height: 113,
              child: Stack(
                children: [
                  Positioned(
                    left: 19.90,
                    top: 20.07,
                    child: SizedBox(
                      width: 72.24,
                      height: 72.86,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 72.24,
                              height: 72.85,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFCEC4FF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 72.24,
                              height: 72.85,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 72.24,
                                      height: 72.85,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFFCEC4FF),
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.22,
                    top: 16.36,
                    child: Container(
                      width: 78.99,
                      height: 79.66,
                      decoration: const ShapeDecoration(
                        shape: OvalBorder(
                          side:
                              BorderSide(width: 2.25, color: Color(0xFFA7A7A8)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.22,
                    top: 16.36,
                    child: Container(
                      width: 78.88,
                      height: 79.55,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.52,
                    top: 8.59,
                    child: Container(
                      width: 95.01,
                      height: 95.82,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                              width: 0.58,
                              color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 112.05,
                      height: 113,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                              width: 0.30,
                              color: const Color(0xFF727272).withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12.11,
            top: 35.68,
            child: Container(
              width: 2.53,
              height: 2.55,
              decoration: const ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 102.89,
            top: 54.38,
            child: Container(
              width: 4.21,
              height: 4.25,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 64.57,
            child: Container(
              width: 2.53,
              height: 2.55,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 76.35,
            top: 97.71,
            child: Container(
              width: 2.53,
              height: 2.55,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 92.15,
            top: 12.53,
            child: Container(
              width: 1.68,
              height: 1.70,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.75),
                shape: const OvalBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProgressIndicator extends StatelessWidget {
  const UserProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: 105,
                      margin: EdgeInsets.only(right: SizeConfig.padding2),
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF79780),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.padding2),
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // width: 105,
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BEGINNER',
                    style: TextStyles.sourceSansB.body4.colour(
                      const Color(0xFFB3B3B3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.padding18),
                    child: Text(
                      'INTERMEDIATE',
                      style: TextStyles.sourceSansB.body4.colour(
                        const Color(0xFFB3B3B3),
                      ),
                    ),
                  ),
                  Text(
                    'SUPER FELLO',
                    style: TextStyles.sourceSansB.body4.colour(
                      const Color(0xFFB3B3B3),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class FelloBadgesBackground extends StatelessWidget {
  const FelloBadgesBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF191919),
        backgroundBlendMode: BlendMode.darken,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.fToolBarHeight * 1.6,
              ),
              Row(
                children: [
                  Flexible(
                    child: Transform.rotate(
                      angle: -pi / 9,
                      child: Transform.scale(
                        scale: 2,
                        child: Container(
                          height: 30,
                          width: SizeConfig.screenWidth! * 2,
                          color: const Color(0xff023C40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding36,
              ),
              Row(
                children: [
                  Expanded(
                    child: Transform.rotate(
                      angle: -pi / 9,
                      child: Transform.scale(
                        scale: 2,
                        child: Container(
                          height: SizeConfig.padding6,
                          width: SizeConfig.screenWidth! * 2,
                          color: const Color(0xff023C40),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class StarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4859731, size.height * 0.1438654);
    path_0.cubicTo(
        size.width * 0.5008654,
        size.height * 0.1115788,
        size.width * 0.5467500,
        size.height * 0.1115788,
        size.width * 0.5616423,
        size.height * 0.1438654);
    path_0.lineTo(size.width * 0.6415885, size.height * 0.3171873);
    path_0.cubicTo(
        size.width * 0.6493923,
        size.height * 0.3341054,
        size.width * 0.6654269,
        size.height * 0.3457542,
        size.width * 0.6839269,
        size.height * 0.3479481);
    path_0.lineTo(size.width * 0.8734692, size.height * 0.3704215);
    path_0.cubicTo(
        size.width * 0.9087769,
        size.height * 0.3746077,
        size.width * 0.9229577,
        size.height * 0.4182500,
        size.width * 0.8968538,
        size.height * 0.4423885);
    path_0.lineTo(size.width * 0.7567192, size.height * 0.5719808);
    path_0.cubicTo(
        size.width * 0.7430423,
        size.height * 0.5846308,
        size.width * 0.7369154,
        size.height * 0.6034808,
        size.width * 0.7405500,
        size.height * 0.6217538);
    path_0.lineTo(size.width * 0.7777462, size.height * 0.8089654);
    path_0.cubicTo(
        size.width * 0.7846769,
        size.height * 0.8438385,
        size.width * 0.7475538,
        size.height * 0.8708115,
        size.width * 0.7165269,
        size.height * 0.8534423);
    path_0.lineTo(size.width * 0.5499731, size.height * 0.7602154);
    path_0.cubicTo(
        size.width * 0.5337154,
        size.height * 0.7511115,
        size.width * 0.5139000,
        size.height * 0.7511115,
        size.width * 0.4976423,
        size.height * 0.7602154);
    path_0.lineTo(size.width * 0.3310873, size.height * 0.8534423);
    path_0.cubicTo(
        size.width * 0.3000615,
        size.height * 0.8708115,
        size.width * 0.2629385,
        size.height * 0.8438385,
        size.width * 0.2698677,
        size.height * 0.8089654);
    path_0.lineTo(size.width * 0.3070665, size.height * 0.6217538);
    path_0.cubicTo(
        size.width * 0.3106973,
        size.height * 0.6034808,
        size.width * 0.3045735,
        size.height * 0.5846308,
        size.width * 0.2908946,
        size.height * 0.5719808);
    path_0.lineTo(size.width * 0.1507600, size.height * 0.4423885);
    path_0.cubicTo(
        size.width * 0.1246562,
        size.height * 0.4182500,
        size.width * 0.1388358,
        size.height * 0.3746077,
        size.width * 0.1741438,
        size.height * 0.3704212);
    path_0.lineTo(size.width * 0.3636877, size.height * 0.3479481);
    path_0.cubicTo(
        size.width * 0.3821892,
        size.height * 0.3457542,
        size.width * 0.3982231,
        size.height * 0.3341054,
        size.width * 0.4060269,
        size.height * 0.3171873);
    path_0.lineTo(size.width * 0.4859731, size.height * 0.1438654);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01190477;
    paint_0_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4437615, size.height * 0.09873231);
    path_1.cubicTo(
        size.width * 0.4565231,
        size.height * 0.07105808,
        size.width * 0.4958577,
        size.height * 0.07105808,
        size.width * 0.5086192,
        size.height * 0.09873231);
    path_1.lineTo(size.width * 0.5885654, size.height * 0.2720542);
    path_1.cubicTo(
        size.width * 0.5972385,
        size.height * 0.2908523,
        size.width * 0.6150538,
        size.height * 0.3037954,
        size.width * 0.6356077,
        size.height * 0.3062327);
    path_1.lineTo(size.width * 0.8251538, size.height * 0.3287062);
    path_1.cubicTo(
        size.width * 0.8554154,
        size.height * 0.3322946,
        size.width * 0.8675731,
        size.height * 0.3697012,
        size.width * 0.8451962,
        size.height * 0.3903923);
    path_1.lineTo(size.width * 0.7050615, size.height * 0.5199846);
    path_1.cubicTo(
        size.width * 0.6898615,
        size.height * 0.5340385,
        size.width * 0.6830577,
        size.height * 0.5549846,
        size.width * 0.6870923,
        size.height * 0.5752885);
    path_1.lineTo(size.width * 0.7242923, size.height * 0.7625000);
    path_1.cubicTo(
        size.width * 0.7302308,
        size.height * 0.7923885,
        size.width * 0.6984115,
        size.height * 0.8155077,
        size.width * 0.6718192,
        size.height * 0.8006231);
    path_1.lineTo(size.width * 0.5052654, size.height * 0.7073923);
    path_1.cubicTo(
        size.width * 0.4872000,
        size.height * 0.6972808,
        size.width * 0.4651808,
        size.height * 0.6972808,
        size.width * 0.4471154,
        size.height * 0.7073923);
    path_1.lineTo(size.width * 0.2805631, size.height * 0.8006231);
    path_1.cubicTo(
        size.width * 0.2539696,
        size.height * 0.8155077,
        size.width * 0.2221496,
        size.height * 0.7923885,
        size.width * 0.2280892,
        size.height * 0.7625000);
    path_1.lineTo(size.width * 0.2652877, size.height * 0.5752885);
    path_1.cubicTo(
        size.width * 0.2693223,
        size.height * 0.5549808,
        size.width * 0.2625177,
        size.height * 0.5340385,
        size.width * 0.2473192,
        size.height * 0.5199846);
    path_1.lineTo(size.width * 0.1071846, size.height * 0.3903923);
    path_1.cubicTo(
        size.width * 0.08480962,
        size.height * 0.3697012,
        size.width * 0.09696385,
        size.height * 0.3322942,
        size.width * 0.1272281,
        size.height * 0.3287062);
    path_1.lineTo(size.width * 0.3167715, size.height * 0.3062327);
    path_1.cubicTo(
        size.width * 0.3373288,
        size.height * 0.3037954,
        size.width * 0.3551435,
        size.height * 0.2908523,
        size.width * 0.3638142,
        size.height * 0.2720542);
    path_1.lineTo(size.width * 0.4437615, size.height * 0.09873231);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02380954;
    paint_1_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FelloBadgeBGCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.016000, 0);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.6160714);
    path_0.lineTo(size.width * -0.02666667, size.height * 1.0970238);
    path_0.lineTo(size.width * 1.016000, size.height * 0.5601190);
    path_0.lineTo(size.width * 1.016000, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff023C40).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FelloBadgeBG2CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.016000, 0);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.9173913);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.9956522);
    path_0.lineTo(size.width * 1.016000, size.height * 0.08260870);
    path_0.lineTo(size.width * 1.016000, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff023C40).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// import 'dart:ui' as ui;
//
// //Add this CustomPaint widget to the Widget Tree
// CustomPaint(
// size: Size(2, 25),
// painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(1, 0.980469);
    path_0.lineTo(1, 24.9605);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.6483350;
    paint_0_stroke.color = const Color(0xffA5FCE7).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
