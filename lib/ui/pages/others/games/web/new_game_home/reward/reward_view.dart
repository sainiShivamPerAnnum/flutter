import 'package:felloapp/ui/pages/others/games/web/new_game_home/reward/components/rank_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardView extends StatelessWidget {
  const RewardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
        color: UiConstants.kLeaderBoardBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const RankWidget(
            firstPriceMoney: 1500,
            secondPriceMoney: 1000,
            thirdPriceMoney: 500,
            firstPricePoint: 200,
            secondPricePoint: 100,
            thirdPricePoint: 50,
          ),
          Expanded(
            child: NotificationListener<OverscrollNotification>(
              // onNotification: (OverscrollNotification notification) {
              // var controller = HomeController.to.scrollController;
              // if (notification.overscroll < 0 &&
              //     controller.offset + notification.overscroll <= 0) {
              //   if (controller.offset != 0) controller.jumpTo(0);
              //   return true;
              // }
              // if (controller.offset + notification.overscroll >=
              //     controller.position.maxScrollExtent) {
              //   if (controller.offset !=
              //       controller.position.maxScrollExtent) {
              //     controller.jumpTo(controller.position.maxScrollExtent);
              //   }
              //   return true;
              // }
              // controller.jumpTo(controller.offset + notification.overscroll);
              // return true;
              // },
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: SizeConfig.screenHeight * 0.0897,
                    child: Center(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/temp/medal.svg',
                          width: SizeConfig.iconSize5,
                          height: SizeConfig.iconSize5,
                        ),
                        title: Text(
                          index == 0
                              ? '4th - 10th'
                              : '${(index * 10) + 1}th - ${(index * 10) + 10}th',
                          style: Rajdhani.style.body2.semiBold,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rs ${(5 - index) * 1000}',
                              style: SansPro.style.body2,
                            ),
                            SizedBox(
                              width: SizeConfig.padding16,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset('assets/temp/Tokens.svg'),
                                SizedBox(
                                  width: SizeConfig.padding2,
                                ),
                                Text(
                                  '100',
                                  style: SansPro.style.body3,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: SizeConfig.dividerHeight,
                    color: UiConstants.kDividerColor,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
