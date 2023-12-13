import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/feature/fello_badges/shared/sf_level_mapping_extension.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_custom_painters.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class UserProgressIndicator extends StatefulWidget {
  const UserProgressIndicator({required this.level, super.key});

  final SuperFelloLevel level;

  @override
  State<UserProgressIndicator> createState() => _UserProgressIndicatorState();
}

class _UserProgressIndicatorState extends State<UserProgressIndicator> {
  final _levels = [
    SuperFelloLevel.BEGINNER,
    SuperFelloLevel.INTERMEDIATE,
    SuperFelloLevel.SUPER_FELLO,
  ];

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < _levels.length; i++) ...[
                    Expanded(
                      child: _Indicator(
                        progress:
                            _levels[i].level <= widget.level.level ? 1 : 0,
                        color: _levels[i].getLevelData.borderColor,
                      ),
                    ),
                    if (i != _levels.length - 1)
                      const SizedBox(
                        width: 4,
                      )
                  ]
                ],
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

class _Indicator extends StatelessWidget {
  final double progress;
  final Color color;

  const _Indicator({
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.biggest.width;
      return Stack(
        children: [
          Container(
            width: maxWidth,
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
              width: progress * maxWidth,
              height: SizeConfig.padding6,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInExpo,
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      );
    });
  }
}
