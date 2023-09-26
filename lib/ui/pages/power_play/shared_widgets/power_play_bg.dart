import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class PowerPlayBackgroundUi extends StatelessWidget {
  const PowerPlayBackgroundUi({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              UiConstants.kPowerPlayGradientPrimary,
              UiConstants.kPowerPlayGradientSecondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.3, 1],
          ),
        ),
        child: child,
      ),
    );
  }
}
