import 'package:felloapp/feature/fello_badges/ui/widgets/badges_custom_painters.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class UserProgressIndicator extends StatefulWidget {
  const UserProgressIndicator({required this.level, super.key});

  final int level;

  @override
  State<UserProgressIndicator> createState() => _UserProgressIndicatorState();
}

class _UserProgressIndicatorState extends State<UserProgressIndicator> {
  double level0 = 0.1;
  double level1 = 0.0;
  double level2 = 0.0;

  void _updateProgress() {
    switch (widget.level) {
      case 2:
        setState(() {
          level0 = 1.0;
          level1 = 0.1;
        });
        break;
      case 3:
        setState(() {
          level0 = 1.0;
          level1 = 1.0;
          level2 = 0.1;
        });
        break;

      case 4:
        setState(() {
          level0 = 1.0;
          level1 = 1.0;
          level2 = 1.0;
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              SizedBox(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: SizeConfig.padding120,
                            height: SizeConfig.padding6,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9).withOpacity(0.25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: SizeConfig.padding6,
                            child: AnimatedContainer(
                              alignment: Alignment.bottomCenter,
                              width: level0 * (SizeConfig.padding120),
                              height: SizeConfig.padding6,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInExpo,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF79780),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              // color: const Color(0xFFF79780),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: SizeConfig.padding120,
                            height: SizeConfig.padding6,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9).withOpacity(0.25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: SizeConfig.padding6,
                            child: AnimatedContainer(
                              alignment: Alignment.bottomCenter,
                              width: level1 * (SizeConfig.padding120),
                              height: SizeConfig.padding6,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInExpo,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF93B5FE),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              // color: const Color(0xFFF79780),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(width: SizeConfig.padding2),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: SizeConfig.padding120,
                            height: SizeConfig.padding6,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9).withOpacity(0.25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: SizeConfig.padding6,
                            child: AnimatedContainer(
                              alignment: Alignment.bottomCenter,
                              width: level2 * (SizeConfig.padding120),
                              height: SizeConfig.padding6,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInExpo,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFFD979),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              // color: const Color(0xFFF79780),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.padding10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BEGINNER',
                    style: TextStyles.sourceSansB.body4.colour(
                      const Color(0xFFB3B3B3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.padding18),
                    child: Text(
                      'INTERMEDIATE',
                      style: TextStyles.sourceSansB.body4.colour(
                        const Color(0xFFB3B3B3),
                      ),
                    ),
                  ),
                  Text(
                    'SUPER FELLO',
                    style: TextStyles.sourceSansB.body4.colour(
                      const Color(0xFFB3B3B3),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: SizeConfig.padding18,
          top: SizeConfig.padding12,
          child: CustomPaint(
            size: Size(
                SizeConfig.padding26, (SizeConfig.padding26 * 1).toDouble()),
            painter: StarCustomPainter(),
          ),
        ),
      ],
    );
  }
}
