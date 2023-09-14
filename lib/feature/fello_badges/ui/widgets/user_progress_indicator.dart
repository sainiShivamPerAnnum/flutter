import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class UserProgressIndicator extends StatelessWidget {
  const UserProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: 105,
                      margin: EdgeInsets.only(right: SizeConfig.padding2),
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF79780),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.padding2),
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // width: 105,
                      height: SizeConfig.padding6,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                      ),
                    ),
                  )
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
      ],
    );
  }
}
