import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class RootAnimation {
  RootAnimation(this.controller)
      : backgroundOpacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0, 0.3, curve: Curves.easeIn),
          ),
        ),
        contentHeight = Tween<double>(
                begin: SizeConfig.screenHeight, end: SizeConfig.viewInsets.top)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 0.7, curve: Curves.easeIn),
          ),
        ),
        contentOpacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 0.7, curve: Curves.easeIn),
          ),
        ),
        navbarPosition = Tween<double>(
                begin: -SizeConfig.navBarHeight * 2,
                end: SizeConfig.pageHorizontalMargins)
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1, curve: Curves.elasticIn),
          ),
        );

  final AnimationController controller;
  final Animation<double> backgroundOpacity;
  final Animation<double> navbarPosition;
  final Animation<double> contentHeight;
  final Animation<double> contentOpacity;
}
