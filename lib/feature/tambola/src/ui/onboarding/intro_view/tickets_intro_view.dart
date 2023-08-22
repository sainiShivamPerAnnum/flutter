import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/onboarding_views/tickets_tutorial_assets_view.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketsIntroView extends StatefulWidget {
  const TicketsIntroView({super.key});

  @override
  State<TicketsIntroView> createState() => _TicketsIntroViewState();
}

class _TicketsIntroViewState extends State<TicketsIntroView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              left: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              right: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.38,
              right: SizeConfig.screenWidth! * 0.03,
              child: Opacity(
                opacity: 0.7,
                child: SvgPicture.asset(Assets.goldAsset,
                    width: SizeConfig.padding54),
              ),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.3,
              left: SizeConfig.screenWidth! * 0.05,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(Assets.floAsset,
                    width: SizeConfig.padding54),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: kToolbarHeight / 3),
                            Hero(
                              tag: "mainAsset",
                              child: SvgPicture.asset(
                                Assets.tambolaCardAsset,
                                width: SizeConfig.padding152,
                              ),
                            ),
                            // SizedBox(height: SizeConfig.padding10),
                            Hero(
                              tag: "mainTitle",
                              child: Material(
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Text(
                                      "Tickets",
                                      style: TextStyles.rajdhaniBL.title50
                                          .colour(UiConstants.kGoldProPrimary)
                                          .letterSpace(2)
                                          .copyWith(
                                        shadows: [
                                          const Shadow(
                                            color: Colors
                                                .black, // Color(0xff88a19f),
                                            offset: Offset(3, 2),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Text(
                                    //   "Tickets",
                                    //   style: TextStyles.rajdhaniBL.title50.copyWith(
                                    //     foreground: Paint()
                                    //       ..style = PaintingStyle.stroke
                                    //       ..strokeWidth = 0.05
                                    //       ..color = Colors.black,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding10),
                            Text(
                              "Participate in daily draw to\nEarn rewards",
                              style: TextStyles.sourceSansSB.body1
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  SizeConfig.pageHorizontalMargins),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    painter: const TicketPainter(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding16,
                                        vertical: SizeConfig.padding16,
                                      ),
                                      width: SizeConfig.screenHeight! * 0.24,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '#1234567890',
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(UiConstants
                                                        .kGreyTextColor),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: SizeConfig.padding20),
                                            alignment: Alignment.center,
                                            child: MySeparator(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                          ),
                                          GridView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: 15,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 1,
                                            ),
                                            itemBuilder: (ctx, i) {
                                              return Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius
                                                      .circular(SizeConfig
                                                              .blockSizeHorizontal *
                                                          1),
                                                  border: Border.all(
                                                      color: Colors.white54,
                                                      width: 0.7),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        i.toString(),
                                                        style: TextStyles
                                                            .rajdhaniB.body2
                                                            .colour(
                                                                Colors.white54),
                                                      ),
                                                    ),
                                                    // markStatus(i)
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   "Get Tickets by saving min ₹500 in\nany of the assets every week",
                            // style: TextStyles.sourceSansM.body2
                            //     .colour(Colors.white),
                            //   textAlign: TextAlign.center,
                            // ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Get Tickets by saving min ',
                                  ),
                                  TextSpan(
                                    text: '₹500',
                                    style: TextStyles.sourceSansM.body2
                                        .colour(const Color(0xFFFFD979)),
                                  ),
                                  const TextSpan(
                                    text: ' in\nany of the assets every week',
                                  ),
                                ],
                              ),
                              style: TextStyles.sourceSansM.body2
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                        Text(
                          "We will help you know how Tickets work",
                          style:
                              TextStyles.sourceSansB.body2.colour(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.padding20),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: ActionSlider.standard(
                            action: (controller) async {
                              Haptic.vibrate();
                              // AppState.screenStack.add(ScreenItem.modalsheet);
                              unawaited(
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    pageBuilder: (_, __, ___) =>
                                        const TicketsTutorialsView(),
                                  ),
                                ),
                              );
                            },
                            toggleColor: UiConstants.primaryColor,
                            child: Text(
                              "GET STARTED WITH TICKETS",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding16),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: UiConstants.kSaveStableFelloCardBg,
                  height:
                      SizeConfig.viewInsets.bottom + kBottomNavigationBarHeight,
                  child: ListTile(
                    leading: DefaultAvatar(),
                    title: Text(
                      "Ashiwin Singh",
                      style: TextStyles.sourceSansB.body2.colour(Colors.white),
                    ),
                    trailing: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        text: "Earned ",
                        style: TextStyles.rajdhaniSB.body3.colour(Colors.white),
                        children: [
                          TextSpan(
                            text: "₹ 10,123\n",
                            style: TextStyles.rajdhaniSB.body3.colour(
                              const Color(0xffF6CC60),
                            ),
                          ),
                          TextSpan(
                            text: "from tickets last week",
                            style: TextStyles.rajdhaniSB.body3
                                .colour(Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RotatingPolkaDotsWidget extends StatefulWidget {
  const RotatingPolkaDotsWidget({super.key});

  @override
  State<RotatingPolkaDotsWidget> createState() =>
      _RotatingPolkaDotsWidgetState();
}

class _RotatingPolkaDotsWidgetState extends State<RotatingPolkaDotsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Repeats the animation infinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        Assets.polkaDots,
        fit: BoxFit.contain,
        width: SizeConfig.screenWidth! / 1.5,
        height: SizeConfig.screenWidth! / 1.5,
      ),
    );
  }
}
