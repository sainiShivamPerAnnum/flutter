import 'package:felloapp/feature/tambola/src/ui/animations/dotted_border_animation.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({required this.dotsController, super.key});

  final AnimationController dotsController;

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  late PageController _controller1, _controller2, _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = PageController(viewportFraction: 0.6, initialPage: 1);
    _controller2 = PageController(viewportFraction: 0.6, initialPage: 1);
    _controller3 = PageController(viewportFraction: 0.6, initialPage: 1);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        color: UiConstants.darkPrimaryColor,
      ),
      child: Column(
        children: [
          Text(
            "Reveal numbers to match with Tickets",
            style: TextStyles.sourceSansB.body2.colour(Colors.white),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: AnimatedDottedRectangle(
              controller: widget.dotsController,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(SizeConfig.padding16),
                child: Row(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _controller1,
                        scrollDirection: Axis.vertical,
                        itemCount: 90,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 1 ? "Spin" : "${i + 1}".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller2,
                        scrollDirection: Axis.vertical,
                        itemCount: 90,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 1 ? "to" : "${i + 1}".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller3,
                        scrollDirection: Axis.vertical,
                        itemCount: 90,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 1 ? "Win" : "${i + 1}".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              switchInCurve: Curves.easeOutExpo,
              switchOutCurve: Curves.easeInExpo,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: MaterialButton(
                height: SizeConfig.padding44,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5)),
                minWidth: SizeConfig.screenWidth! * 0.3,
                color: Colors.white,
                onPressed: () {},
                child: Text(
                  "SPIN",
                  style: TextStyles.rajdhaniB.body0.colour(Colors.black),
                ),
              )
              // : Container(
              //     margin: EdgeInsets.symmetric(
              //       horizontal: SizeConfig.padding16,
              //       vertical: SizeConfig.padding16,
              //     ),
              //     padding: EdgeInsets.symmetric(
              //         horizontal: SizeConfig.padding16,
              //         vertical: SizeConfig.padding12),
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             color: UiConstants.primaryColor, width: 1),
              //         borderRadius:
              //             BorderRadius.circular(SizeConfig.roundness12),
              //         color: Colors.black45),
              //     child: Row(children: [
              //       Text(
              //         "5-7",
              //         style: TextStyles.rajdhaniB.body1
              //             .colour(UiConstants.primaryColor),
              //       ),
              //       SizedBox(width: SizeConfig.padding4),
              //       Text(
              //         "Matches",
              //         style: TextStyles.body2.colour(Colors.white54),
              //       ),
              //       const Spacer(),
              //       Text(
              //         "1",
              //         style: TextStyles.rajdhaniB.body1
              //             .colour(UiConstants.primaryColor),
              //       ),
              //       SizedBox(width: SizeConfig.padding4),
              //       Text(
              //         "Ticket",
              //         style: TextStyles.body2.colour(Colors.white54),
              //       ),
              //     ]),
              //   ),
              )
        ],
      ),
    );
  }
}
