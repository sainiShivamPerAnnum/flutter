import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/progress_bottom_sheet.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeDetails extends StatefulWidget {
  const FelloBadgeDetails(
      {required this.levelsData, required this.currentLevel, super.key});

  final List<Level>? levelsData;
  final int currentLevel;

  @override
  State<FelloBadgeDetails> createState() => _FelloBadgeDetailsState();
}

class _FelloBadgeDetailsState extends State<FelloBadgeDetails> {
  final List<Color> colors = [
    const Color(0xFF5B413E),
    const Color(0xFF394B71),
    const Color(0xFF01646B)
  ];

  final List<String> title = [
    "Beginner\nFello Level",
    "Intermediate\nFello Level",
    "Super\nFello Level"
  ];

  double getIndex() {
    switch (widget.currentLevel) {
      case 1:
        return 0.0;
      case 2:
        return 1.0;
      case 3:
      case 4:
        return 2.0;
      default:
        return 0.0;
    }
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
                (getIndex() * SizeConfig.screenWidth!) -
                    SizeConfig.pageHorizontalMargins,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenHeight! * 0.765,
      child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding2),
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BadgeDetailsContainer(
              index: index,
              backgroundColor: colors[index],
              title: title[index],
              levelDetails: widget.levelsData?[index],
            );
          }),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class BadgeDetailsContainer extends StatelessWidget {
  BadgeDetailsContainer(
      {required this.index,
      required this.backgroundColor,
      required this.title,
      super.key,
      this.levelDetails});

  final int index;
  final Level? levelDetails;
  final Color backgroundColor;
  final String title;

  final List<String> imageUrl = [
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg',
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-1.svg',
    'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg',
  ];

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
      width: 310,
      constraints: const BoxConstraints(
        minHeight: 580,
      ),
      margin: EdgeInsets.only(right: index == 2 ? 0 : SizeConfig.padding24),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: (levelDetails?.isCompleted ?? false)
                ? borderColor[index]
                : Colors.white,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          buildBackgroundStack(),
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
                    Text(
                      title,
                      style: TextStyles.rajdhaniB.title2
                          .colour(
                            index == 2 ? const Color(0xFFFFD979) : Colors.white,
                          )
                          .copyWith(
                            height: 1.27,
                          ),
                    ),
                    SvgPicture.network(
                      imageUrl[index],
                      height: SizeConfig.padding78,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                (levelDetails?.isCompleted ?? false)
                    ? Container(
                        width: SizeConfig.padding86,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding8,
                            vertical: SizeConfig.padding4),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFCEF8F5),
                          shape: RoundedRectangleBorder(
                            // side: const BorderSide(
                            //     width: 1, color: Color(0xFF232326)),
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
                            const Icon(
                              Icons.done,
                              size: 15,
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
                            const Icon(
                              Icons.lock,
                              size: 15,
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
                  constraints: BoxConstraints(
                    minHeight: SizeConfig.padding128,
                  ),
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
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: levelDetails?.benefits?.length ?? 0,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
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
                                levelDetails!.benefits![index],
                                style: TextStyles.rajdhaniSB.body2.colour(
                                  Colors.white,
                                ),
                              )
                            ],
                          );
                        },
                      ),
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
                  (levelDetails?.isCompleted ?? false)
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
                  // height: SizeConfig.screenHeight! * 0.35,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
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
                              badgeUrl:
                                  levelDetails?.lvlData?[i].badgeurl ?? '',
                              title: levelDetails?.lvlData?[i].title ?? '',
                              description:
                                  levelDetails?.lvlData?[i].barHeading ?? '',
                              buttonText: 'GET MORE TICKETS',
                              onButtonPressed: () {
                                // Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: SizeConfig.padding86,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding16,
                              vertical: SizeConfig.padding8),
                          decoration: ShapeDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.network(
                                levelDetails?.lvlData?[i].badgeurl ?? '',
                                height: SizeConfig.padding56,
                                width: SizeConfig.padding50,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: SizeConfig.padding12,
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth! * 0.53,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          levelDetails?.lvlData?[i].title ?? '',
                                          style: TextStyles.sourceSans.body3
                                              .colour(
                                            Colors.white,
                                          ),
                                        ),
                                        ((levelDetails?.lvlData?[i].achieve ??
                                                    1) !=
                                                100)
                                            ? const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 12,
                                                weight: 700,
                                                grade: 200,
                                                opticalSize: 48,
                                              )
                                            : Transform.translate(
                                                offset: const Offset(0, 6),
                                                child: Container(
                                                  height: SizeConfig.padding20,
                                                  width: SizeConfig.padding20,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xff62E3C4),
                                                      width: 1,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.done,
                                                    color: Color(0xff62E3C4),
                                                    size: 12,
                                                    weight: 700,
                                                    grade: 200,
                                                    opticalSize: 48,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding4,
                                    ),
                                    Text(
                                      levelDetails?.lvlData?[i].barHeading ??
                                          '',
                                      style: TextStyles.sourceSans.body4.colour(
                                        Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding4,
                                    ),
                                    if ((levelDetails?.lvlData?[i].achieve ??
                                            1) !=
                                        100)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 153.28,
                                            height: SizeConfig.padding6,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: SizeConfig.padding168,
                                                  height: SizeConfig.padding6,
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFFD9D9D9)
                                                            .withOpacity(0.25),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: SizeConfig.padding6,
                                                  child: AnimatedContainer(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width: ((levelDetails
                                                                    ?.lvlData?[
                                                                        i]
                                                                    .achieve ??
                                                                1) /
                                                            100) *
                                                        (SizeConfig.padding168),
                                                    height: SizeConfig.padding6,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInExpo,
                                                    decoration: ShapeDecoration(
                                                      color: index == 0
                                                          ? const Color(
                                                              0xFFFFCCBF)
                                                          : const Color(
                                                              0xFFA5E4FF),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                    ),
                                                    // color: const Color(0xFFF79780),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '${levelDetails?.lvlData?[i].achieve ?? 0} %',
                                            textAlign: TextAlign.right,
                                            style: TextStyles.sourceSans.body4
                                                .colour(
                                              Colors.white.withOpacity(0.75),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
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
