import 'dart:math';

import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FelloBadgesBackground extends StatelessWidget {
  const FelloBadgesBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF191919),
        // backgroundBlendMode: BlendMode.darken,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.fToolBarHeight * 1,
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
