import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  const Loader({Key key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  Animation<Duration> animation;
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    animation =
        Tween<Duration>(begin: Duration(seconds: 30), end: Duration.zero)
            .animate(controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            print(status.toString());
            if (status == AnimationStatus.completed) {
              controller.reset();
              controller.forward();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeListener(() {});
    super.dispose();
  }

  double bottomPos = -(SizeConfig.screenHeight * 0.5);

  @override
  void didChangeDependencies() {
    if (mounted) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          bottomPos = 0;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Stack(
        children: [
          AnimatedPositioned(
            bottom: bottomPos,
            duration: Duration(seconds: 1),
            curve: Curves.decelerate,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.roundness24),
                ),
                color: Colors.white,
              ),
              width:
                  SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
              margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: SizeConfig.padding80,
                    width: SizeConfig.screenWidth * 0.6,
                    child: Lottie.asset("assets/lotties/txnloader.json",
                        fit: BoxFit.fitWidth),
                  ),

                  // SpinKitWave(
                  //     size: SizeConfig.padding40,
                  //     color: UiConstants.primaryColor),
                  SizedBox(height: SizeConfig.padding20),
                  SizedBox(height: SizeConfig.padding6),
                  Text("Processing...", style: TextStyles.title4.bold),
                  SizedBox(height: SizeConfig.padding8),
                  Text(
                    "Please do not close the app. You transaction is in progress..",
                    style: TextStyles.body2.colour(Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  RichText(
                    text: TextSpan(
                      text: "Estimated time remaining: ",
                      style: TextStyles.body4.colour(Colors.grey).light,
                      children: [
                        TextSpan(
                          text:
                              "${(animation.value.inSeconds % 60).toString().padLeft(2, '0')} secs",
                          style: TextStyles.body4
                              .colour(UiConstants.primaryColor)
                              .bold,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding24),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
