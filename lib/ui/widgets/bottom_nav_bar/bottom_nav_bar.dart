import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final RootViewModel parentModel;
  BottomNavBar({@required this.parentModel});

  final List<NavBarItemModel> navbarItems = [
    NavBarItemModel('Journey', Assets.navJourneyLottie),
    NavBarItemModel('Save', Assets.navSaveLottie),
    NavBarItemModel('Play', Assets.navPlayLottie),
    NavBarItemModel('Win', Assets.navWinLottie)
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, superModel, child) =>
          PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
        builder: (context, model, properties) {
          return Positioned(
            bottom:
                0, // model.avatarRemoteMlIndex > 2 ? 0 : -SizeConfig.navBarHeight,
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.navBarHeight,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins / 2),
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: superModel.getCurrentTabIndex == index
                          ? NavBarIcon(
                              animate: true,
                              item: navbarItems[index],
                              style: TextStyles.rajdhaniSB
                                  .colour(UiConstants.kTextColor),
                            )
                          : GestureDetector(
                              onTap: () {
                                parentModel.onItemTapped(index);
                              },
                              child: NavBarIcon(
                                animate: false,
                                item: navbarItems[index],
                                style: TextStyles.rajdhaniSB
                                    .colour(UiConstants.kTextColor2),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final bool animate;
  final NavBarItemModel item;
  final TextStyle style;
  NavBarIcon(
      {@required this.animate, @required this.item, @required this.style});
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -SizeConfig.navBarHeight * 0.05),
              child: Column(
                children: [
                  Container(
                      height: SizeConfig.navBarHeight * 0.6,
                      width: SizeConfig.navBarHeight * 0.6,
                      child: Lottie.asset(item.lottie,
                          fit: BoxFit.contain,
                          animate: animate,
                          repeat: false)),
                  Text(item.title, style: style),
                  SizedBox(height: SizeConfig.navBarHeight * 0.1)
                ],
              ),
            ),
          ],
        ));
  }
}
