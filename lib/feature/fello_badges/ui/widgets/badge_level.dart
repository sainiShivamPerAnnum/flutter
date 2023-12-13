import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'badge_progress_indicator.dart';
import 'progress_bottom_sheet.dart';

class BadgeLevel extends StatefulWidget {
  const BadgeLevel({
    required this.levelsData,
    required this.currentLevel,
    super.key,
  });

  final List<Level> levelsData;
  final int currentLevel;

  @override
  State<BadgeLevel> createState() => _BadgeLevelState();
}

class _BadgeLevelState extends State<BadgeLevel> {
  final List<Color> colors = [
    const Color(0xFF5B413E),
    const Color(0xFF394B71),
    UiConstants.kAutoSaveOnboardingTextColor,
  ];

  double _getIndex() {
    if (widget.currentLevel case 0 || 1) {
      return 0;
    }

    return widget.currentLevel.toDouble();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(
          const Duration(milliseconds: 800),
          () {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              alignment: 0.8,
            );

            _scrollController.animateTo(
                (_getIndex() * SizeConfig.screenWidth!) -
                    SizeConfig.pageHorizontalMargins,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenHeight! * 0.785,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding2,
        ),
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return BadgeDetailsContainer(
            index: index,
            backgroundColor: colors[index],
            levelDetails: widget.levelsData[index],
          );
        },
      ),
    );
  }
}

class BadgeDetailsContainer extends StatelessWidget {
  BadgeDetailsContainer({
    required this.index,
    required this.backgroundColor,
    required this.levelDetails,
    super.key,
  });

  final int index;
  final Level levelDetails;
  final Color backgroundColor;

  final List<Color> borderColor = const [
    Color(0xFFE19366),
    Color(0xff394B72),
    Color(0xffFFD979),
  ];

  final List<Color> benefitContainerColor = [
    const Color(0xFFF79780).withOpacity(0.2),
    const Color(0xFF93B5FE).withOpacity(0.2),
    const Color(0xFFCEF8F5).withOpacity(0.2),
  ];

  final List<Color> titleColor = [
    const Color(0xFFEFD7D2),
    const Color(0xFFA4E3FF),
    const Color(0xFFFFD979),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.864,
      constraints: BoxConstraints(
        minHeight: SizeConfig.screenHeight! * 0.72,
      ),
      margin: EdgeInsets.only(right: index == 2 ? 0 : SizeConfig.padding24),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color:
                (levelDetails.isCompleted) ? borderColor[index] : Colors.white,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: buildBackgroundStack(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        levelDetails.levelTitle,
                        style: TextStyles.rajdhaniB.title2
                            .colour(
                              index == 2
                                  ? const Color(0xFFFFD979)
                                  : Colors.white,
                            )
                            .copyWith(
                              height: 1.27,
                            ),
                      ),
                    ),
                    SvgPicture.network(
                      levelDetails.badgeurl,
                      height: SizeConfig.padding78,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                (levelDetails.isCompleted)
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding8,
                            vertical: SizeConfig.padding4),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFCEF8F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'UNLOCKED',
                              textAlign: TextAlign.right,
                              style: TextStyles.sourceSansB.body4.colour(
                                Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding4,
                            ),
                            Icon(
                              Icons.done,
                              size: SizeConfig.padding14,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: SizeConfig.padding86,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding8,
                            vertical: SizeConfig.padding4),
                        decoration: ShapeDecoration(
                          color: index == 0
                              ? const Color(0xFFEFD7D2)
                              : index == 1
                                  ? const Color(0xFFC9E4F0)
                                  : const Color(0xFFFFE9B1),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF232326)),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock,
                              size: SizeConfig.padding14,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: SizeConfig.padding4,
                            ),
                            Text(
                              'LOCKED',
                              textAlign: TextAlign.right,
                              style: TextStyles.sourceSansB.body4.colour(
                                Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding12,
                      vertical: SizeConfig.padding12),
                  decoration: ShapeDecoration(
                    color: benefitContainerColor[index],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/gift_icon.svg',
                            height: SizeConfig.padding26,
                          ),
                          SizedBox(
                            width: SizeConfig.padding8,
                          ),
                          Text(
                            'Benefits you get',
                            textAlign: TextAlign.right,
                            style: TextStyles.sourceSansSB.body1.colour(
                              titleColor[index],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      for (var i = 0;
                          i < (levelDetails.benefits.list.length);
                          i++)
                        Row(
                          children: [
                            SizedBox(
                              width: SizeConfig.padding14,
                            ),
                            Container(
                              width: SizeConfig.padding6,
                              height: SizeConfig.padding6,
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding14,
                            ),
                            Text(
                              levelDetails.benefits.list[index],
                              style: TextStyles.rajdhaniSB.body2.colour(
                                Colors.white,
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Text(
                  'Unlock Beginner Benefits',
                  style: TextStyles.sourceSansSB.body2.colour(
                    titleColor[index],
                  ),
                ),
                Text(
                  levelDetails.isCompleted
                      ? "Completed these tasks"
                      : 'Get these badges to unlock this level',
                  style: TextStyles.sourceSans.body3.colour(
                    Colors.white,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                SizedBox(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: levelDetails.lvlData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      final data = levelDetails.lvlData[i];

                      return GestureDetector(
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            enableDrag: false,
                            hapticVibrate: true,
                            isBarrierDismissible: true,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            content: ProgressBottomSheet(
                              badgeInformation: data,
                            ),
                          );
                        },
                        child: BadgeProgressWidget(
                          badgeInformation: data,
                          progressColor: index == 0
                              ? const Color(0xFFFFCCBF)
                              : const Color(0xFFA5E4FF),
                        ),
                      );
                    },
                    separatorBuilder: (context, i) => SizedBox(
                      height: SizeConfig.padding12,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBackgroundStack() {
    return ClipRRect(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.fToolBarHeight * 1.2,
          ),
          Transform.rotate(
            angle: -pi / 9,
            child: Transform.scale(
              scale: 1.3,
              child: Container(
                height: SizeConfig.padding28,
                width: SizeConfig.screenWidth!,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding36,
          ),
          Transform.rotate(
            angle: -pi / 9,
            child: Transform.scale(
              scale: 1.2,
              child: Container(
                height: SizeConfig.padding54,
                width: SizeConfig.screenWidth!,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BadgeProgressWidget extends StatelessWidget {
  const BadgeProgressWidget({
    required this.badgeInformation,
    required this.progressColor,
    super.key,
  });

  final BadgeLevelInformation badgeInformation;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding86,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
        vertical: SizeConfig.padding8,
      ),
      decoration: ShapeDecoration(
        color: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.network(
            badgeInformation.badgeurl,
            height: SizeConfig.padding56,
            width: SizeConfig.padding50,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        badgeInformation.title,
                        style: TextStyles.sourceSans.body3.colour(
                          Colors.white,
                        ),
                      ),
                      Visibility(
                        visible: !badgeInformation.isBadgeAchieved,
                        replacement: Transform.translate(
                          offset: Offset(0, SizeConfig.padding6),
                          child: Container(
                            height: SizeConfig.padding20,
                            width: SizeConfig.padding20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff62E3C4),
                                width: SizeConfig.padding1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.done,
                              color: const Color(0xff62E3C4),
                              size: SizeConfig.padding12,
                              weight: 700,
                              grade: 200,
                              opticalSize: 48,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: SizeConfig.padding12,
                          weight: 700,
                          grade: 200,
                          opticalSize: 48,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),
                  Text(
                    badgeInformation.barHeading,
                    style: TextStyles.sourceSans.body4.colour(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),

                  // Progress indicator.
                  if (!badgeInformation.isBadgeAchieved)
                    BadgeProgressIndicator(
                      achieve: badgeInformation.achieve,
                      color: progressColor,
                      spacing: 18,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
