import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  const Loader({Key key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
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
                  Text("Relax back", style: TextStyles.title4.bold),
                  SizedBox(height: SizeConfig.padding6),
                  Text(
                    "Please do not close the app. You transaction is in progress..",
                    style: TextStyles.body2.colour(Colors.black45),
                    textAlign: TextAlign.center,
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
