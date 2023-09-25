import 'package:felloapp/feature/fello_badges/ui/widgets/user_badges_container.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class FelloBadgeLoadingScreen extends StatelessWidget {
  const FelloBadgeLoadingScreen({
    super.key,
    required this.badgeBorderColor,
    required this.badgeUrl,
  });

  final Color badgeBorderColor;
  final String badgeUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding32,
          ),
          SvgPicture.network(
              'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/super_fello_title.svg'),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Hero(
            tag: 'user_badge',
            child: UserBadgeContainer(
              badgeColor: badgeBorderColor,
              badgeUrl: badgeUrl,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Transform.translate(
            offset: Offset(0, SizeConfig.padding1),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!.withOpacity(0.1),
              highlightColor: UiConstants.kBackgroundColor,
              child: Container(
                height: SizeConfig.padding108,
                width: SizeConfig.screenWidth! * 0.9,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding34,
          ),
          SizedBox(
            width: SizeConfig.screenWidth!,
            height: SizeConfig.screenHeight! * 0.765,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                    vertical: SizeConfig.padding2),
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!.withOpacity(0.1),
                    highlightColor: UiConstants.kBackgroundColor,
                    child: Container(
                      height: SizeConfig.screenHeight! * 0.765,
                      width: SizeConfig.screenWidth! * 0.9,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      margin: EdgeInsets.only(right: SizeConfig.padding12),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
