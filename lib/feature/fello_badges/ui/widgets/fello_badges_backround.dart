import 'dart:math';

import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FelloBadgesBackground extends StatelessWidget {
  const FelloBadgesBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF191919),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.fToolBarHeight * 1,
              ),
              Transform.translate(
                offset: const Offset(-60, 0),
                child: Transform.scale(
                  scale: 2,
                  child: Transform.rotate(
                    angle: -(pi / 9.5),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          width: SizeConfig.screenWidth! * 2,
                          color: const Color(0xff023C40).withOpacity(.3),
                        ),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        Container(
                          height: 10,
                          width: SizeConfig.screenWidth! * 2,
                          color: const Color(0xff023C40).withOpacity(.3),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          child,
        ],
      ),
    );
  }
}
