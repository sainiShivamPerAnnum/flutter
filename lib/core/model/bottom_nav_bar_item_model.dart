import 'package:flutter/material.dart';

class NavBarItemModel {
  final String title;
  final String activeIconImage;
  final String inactiveIconImage;
  final String lottie;
  final AnimationController controller;

  NavBarItemModel(this.title, this.activeIconImage, this.inactiveIconImage,
      this.lottie, this.controller);
}
