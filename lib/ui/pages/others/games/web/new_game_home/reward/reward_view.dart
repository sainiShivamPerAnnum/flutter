import 'package:felloapp/ui/pages/others/games/web/new_game_home/reward/components/rank_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardView extends StatelessWidget {
  const RewardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF39393C),
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
              onNotification: (OverscrollNotification notification) {
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
                return true;
              },
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 7,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 70,
                    child: Center(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/temp/medal.svg',
                          width: 32,
                          height: 32,
                        ),
                        title: Text(
                          index == 0
                              ? '4th - 10th'
                              : '${(index * 10) + 1}th - ${(index * 10) + 10}th',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rs ${(5 - index) * 1000}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset('assets/temp/Tokens.svg'),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Text(
                                  '100',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFB3B3B3),
                                  ),
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
                  return const Divider(
                    height: 0.5,
                    color: Color(0xFF9EA1A1),
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
