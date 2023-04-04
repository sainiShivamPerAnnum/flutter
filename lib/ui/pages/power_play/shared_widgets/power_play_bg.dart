import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class PowerPlayBackgroundUi extends StatelessWidget {
  const PowerPlayBackgroundUi(
      {Key? key, required this.child, this.floatingActionButton})
      : super(key: key);

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              UiConstants.kPowerPlayPrimary,
              Color(0xff3C2840),
              UiConstants.kPowerPlaySecondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.6, 1],
          ),
        ),
        child: child,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
