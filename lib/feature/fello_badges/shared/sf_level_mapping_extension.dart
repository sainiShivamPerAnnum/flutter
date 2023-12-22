import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

typedef LevelData = ({
  String url,
  Color borderColor,
  Color textColor,
  String title,
});

extension SFLevelMappingExtension on SuperFelloLevel {
  LevelData get getLevelData {
    return switch (this) {
      SuperFelloLevel.NEW_FELLO => (
          title: 'New Fello',
          url: '',
          borderColor: Colors.white.withOpacity(0.30),
          textColor: const Color(0xFF61E3C4),
        ),
      SuperFelloLevel.GOOD => (
          title: 'Good Fello',
          url: 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg',
          borderColor: UiConstants.kPeachTextColor,
          textColor: UiConstants.kPeachTextColor,
        ),
      SuperFelloLevel.WISE => (
          title: 'Wise Fello',
          url: 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-1.svg',
          borderColor: UiConstants.kBlogTitleColor,
          textColor: UiConstants.kBlogTitleColor,
        ),
      SuperFelloLevel.SUPER_FELLO => (
          title: 'Super Fello',
          url: 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg',
          borderColor: UiConstants.yellow3,
          textColor: UiConstants.yellow3,
        ),
    };
  }
}
