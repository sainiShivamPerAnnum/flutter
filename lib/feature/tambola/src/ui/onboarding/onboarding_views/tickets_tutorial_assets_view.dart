import 'package:felloapp/feature/tambola/src/ui/onboarding/intro_view/tickets_intro_view.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/onboarding_views/tickets_tutorial_slot_machine_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class TicketsTutorialsView extends StatefulWidget {
  const TicketsTutorialsView({super.key});

  @override
  State<TicketsTutorialsView> createState() => _TicketsTutorialsViewState();
}

class _TicketsTutorialsViewState extends State<TicketsTutorialsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _animation1;
  late CurvedAnimation _animation2;
  late CurvedAnimation _animation3;
  late CurvedAnimation _animation4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.33),
    );
    _animation2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.33, 0.67, curve: Curves.easeInOutCirc),
    );
    _animation3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.67, 1.0, curve: Curves.easeInOutCirc),
    );
    _animation4 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.9, 1.0),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Column(
              children: [
                Expanded(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: "mainAsset",
                              child: SvgPicture.asset(
                                Assets.tambolaCardAsset,
                                width: SizeConfig.padding70,
                              ),
                            ),
                            Hero(
                              tag: "mainTitle",
                              child: Material(
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Text(
                                      "Tickets",
                                      style: TextStyles.rajdhaniB.title1
                                          .colour(Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding20),
                        TicketsAnimatedWidget(
                          animation: _animation1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Save Min ₹500",
                                style: TextStyles.sourceSansB.title4
                                    .colour(Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "in any of the assets and\nGet Tickets every week with Fello",
                                style: TextStyles.sourceSansM.body2
                                    .colour(Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: SizeConfig.padding20),
                            ],
                          ),
                        ),
                        TicketsAnimatedWidget(
                          animation: _animation2,
                          child: const DummyAssetCard(
                            bgColor: UiConstants.kSaveDigitalGoldCardBg,
                            asset: Assets.goldAsset,
                            title: "Digital Gold",
                            subtitle:
                                '24K Gold • Withdraw anytime • 100% Secure',
                            variations: [
                              Tuple2("Digital Gold", "@ Market Price"),
                              Tuple2("Gold Pro", "16.5% returns*")
                            ],
                          ),
                        ),
                        TicketsAnimatedWidget(
                          animation: _animation3,
                          child: const DummyAssetCard(
                            bgColor: UiConstants.kSaveStableFelloCardBg,
                            asset: Assets.floAsset,
                            title: "Fello Flo",
                            subtitle: 'P2P Asset • RBI Certified',
                            variations: [
                              Tuple2("12%", "Flo"),
                              Tuple2("10%", "Flo"),
                              Tuple2("8%", "Flo"),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TicketsAnimatedWidget(
                          animation: _animation4,
                          child: MaterialButton(
                            height: SizeConfig.padding44,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness5)),
                            minWidth: SizeConfig.screenWidth! -
                                SizeConfig.pageHorizontalMargins * 2,
                            color: Colors.white,
                            onPressed: () {
                              _controller.reverse().then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TicketsTutorialsSlotMachineView()));
                              });
                            },
                            child: Text(
                              "START WITH TICKETS",
                              style: TextStyles.rajdhaniB.body0
                                  .colour(Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding20),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TicketsAnimatedWidget extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;
  const TicketsAnimatedWidget({
    required this.animation,
    required this.child,
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: Transform.scale(scale: animation.value, child: child),
    );
  }
}

class DummyAssetCard extends StatelessWidget {
  const DummyAssetCard({
    super.key,
    required this.bgColor,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.variations,
  });

  final Color bgColor;
  final String asset;
  final String title;
  final String subtitle;
  final List<Tuple2<String, String>> variations;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      color: bgColor,
      child: Container(
        width: SizeConfig.screenWidth! * 0.72,
        padding: EdgeInsets.all(SizeConfig.padding10),
        child: Column(
          children: [
            SvgPicture.asset(
              asset,
              height: SizeConfig.screenHeight! * 0.08,
            ),
            Text(
              title,
              style: TextStyles.rajdhaniSB.title4,
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(
              subtitle,
              style: TextStyles.sourceSans.body4
                  .colour(Colors.white.withOpacity(0.8)),
            ),
            SizedBox(height: SizeConfig.padding16),
            Row(
              children: List.generate(
                variations.length,
                (i) => Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      color: Colors.white12,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(SizeConfig.padding10),
                      child: Column(children: [
                        Text(
                          variations[i].item1,
                          style:
                              TextStyles.sourceSansB.body3.colour(Colors.white),
                        ),
                        Text(
                          variations[i].item2,
                          style: TextStyles.bodyFont.colour(Colors.white60),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.padding10)
          ],
        ),
      ),
    );
  }
}
