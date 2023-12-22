import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class BadgeProgressIndicator extends StatelessWidget {
  const BadgeProgressIndicator({
    required this.achieve,
    this.color = UiConstants.peach2,
    this.spacing = 10,
    super.key,
  });

  final num achieve;
  final Color color;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                height: SizeConfig.padding6,
                decoration: ShapeDecoration(
                  color: UiConstants.kProfileBorderColor.withOpacity(0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                final maxWidth = constraints.biggest.width;
                return Container(
                  alignment: Alignment.centerLeft,
                  height: SizeConfig.padding6,
                  child: AnimatedContainer(
                    alignment: Alignment.bottomCenter,
                    width: (achieve) / 100 * maxWidth,
                    height: SizeConfig.padding6,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInExpo,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(
          width: spacing,
        ),
        Text(
          '$achieve %',
          textAlign: TextAlign.right,
          style: TextStyles.sourceSans.body3,
        )
      ],
    );
  }
}
