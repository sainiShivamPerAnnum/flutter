import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/progress_bottom_sheet.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeList extends StatelessWidget {
  const FelloBadgeList({super.key, this.badges});

  final List<OtherBadge>? badges;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding104,
      child: ListView.builder(
        padding: EdgeInsets.only(left: SizeConfig.padding24),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: badges?.length ?? 0,
        itemBuilder: (context, index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  BaseUtil.openModalBottomSheet(
                    addToScreenStack: true,
                    enableDrag: false,
                    hapticVibrate: true,
                    isBarrierDismissible: true,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    content: ProgressBottomSheet(
                      badgeUrl: Assets.tambolaTitanBadge,
                      // TODO: Replace with badges?[index].imageUrl
                      title: badges?[index].title ?? '',
                      description: badges?[index].bottomSheetText ?? '',
                      buttonText: (badges?[index].enable ?? false)
                          ? 'GET MORE TICKETS'
                          : badges![index].bottomSheetCta!,
                      onButtonPressed: () {},
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipPath(
                      clipper: HexagonClipper(),
                      child: Transform.translate(
                        offset: Offset(SizeConfig.padding1, 0),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            (badges?[index].enable ?? false)
                                ? Colors.transparent
                                : const Color(0xFF191919),
                            BlendMode.saturation,
                          ),
                          child: SvgPicture.network(
                            'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/badges/saving_marvel.svg',
                            height: SizeConfig.padding80,
                            width: SizeConfig.padding68,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding6,
                    ),
                    Text(
                      badges?[index].title ?? "",
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

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final h = SizeConfig.padding72;
    final w = SizeConfig.padding70;

    path.moveTo(w / SizeConfig.padding4, 0); // Move to the top center
    path.lineTo(w, h / SizeConfig.padding6); // Line to the top-right
    path.lineTo(
        w,
        (SizeConfig.padding4 * h) /
            SizeConfig.padding2); // Line to the bottom-right
    path.lineTo(w / SizeConfig.padding4, h); // Line to the bottom center
    path.lineTo(
        0,
        (SizeConfig.padding6 * h) /
            SizeConfig.padding4); // Line to the bottom-left
    path.lineTo(0, h / SizeConfig.padding4); // Line to the top-left

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
// path.moveTo(w / SizeConfig.padding2, 0); // Move to the top center
// path.lineTo(w, h / SizeConfig.padding4); // Line to the top-right
// path.lineTo(w, (SizeConfig.padding3 * h) / SizeConfig.padding4); // Line to the bottom-right
// path.lineTo(w / SizeConfig.padding2, h); // Line to the bottom center
// path.lineTo(0, (SizeConfig.padding3 * h) / SizeConfig.padding4); // Line to the bottom-left
// path.lineTo(0, h / SizeConfig.padding4); // Line to the top-left
