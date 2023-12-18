import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeList extends StatelessWidget {
  const FelloBadgeList({
    required this.badges,
    required this.onBadgeTapped,
    super.key,
  });

  final List<BadgeLevelInformation> badges;
  final ValueChanged<BadgeLevelInformation> onBadgeTapped;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding104,
      child: ListView.builder(
        padding: EdgeInsets.only(left: SizeConfig.padding24),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, i) {
          final badge = badges[i];
          return Row(
            children: [
              GestureDetector(
                onTap: () => onBadgeTapped(badge),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.network(
                      badge.badgeUrl,
                      height: SizeConfig.padding80,
                      width: SizeConfig.padding68,
                    ),
                    SizedBox(
                      height: SizeConfig.padding6,
                    ),
                    Text(
                      badges[i].title,
                      style: TextStyles.sourceSans.body4.colour(
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.padding32,
              ),
            ],
          );
        },
      ),
    );
  }
}
