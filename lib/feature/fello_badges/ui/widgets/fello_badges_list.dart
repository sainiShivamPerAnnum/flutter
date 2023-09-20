import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/progress_bottom_sheet.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloBadgeList extends StatelessWidget {
  const FelloBadgeList({super.key, this.badges});

  final List<FelloBadge>? badges;

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
                        title: badges?[index].title ?? '',
                        description: badges?[index].description ?? '',
                        buttonText: 'GET MORE TICKETS',
                        onButtonPressed: () {},
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            (badges?[index].enable ?? false)
                                ? Colors.transparent
                                : const Color(0xFF191919),
                            BlendMode.saturation,
                          ),
                          child: SvgPicture.network(
                            Assets.tambolaTitanBadge,
                            height: SizeConfig.padding80,
                            width: SizeConfig.padding68,
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
          }),
    );
  }
}
