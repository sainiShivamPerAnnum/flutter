import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeList extends StatelessWidget {
  const FelloBadgeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding104,
      child: ListView.builder(
          padding: EdgeInsets.only(left: SizeConfig.padding24),
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.network(
                      Assets.tambolaTitanBadge,
                      height: SizeConfig.padding80,
                      width: SizeConfig.padding68,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: SizeConfig.padding6,
                    ),
                    Text(
                      'Tambola Titan',
                      style: TextStyles.sourceSans.body4.colour(
                        Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.padding32,
                ),
              ],
            );
          }),
    );
  }
}
