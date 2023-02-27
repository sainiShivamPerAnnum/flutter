import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar();
  @override
  Widget build(BuildContext context) {
    RootController _rootController = locator<RootController>();
    return Consumer<AppState>(
      builder: (ctx, superModel, child) => Positioned(
        bottom:
            0, // model.avatarRemoteMlIndex > 2 ? 0 : -SizeConfig.navBarHeight,
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.navBarHeight,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_rootController.navItems.values.length,
                  (index) {
                final navbarItems =
                    _rootController.navItems.values.toList()[index];
                return superModel.getCurrentTabIndex == index
                    ? Expanded(
                        key: ValueKey(navbarItems.title),
                        child: NavBarIcon(
                          key: ValueKey(navbarItems.title),
                          animate: true,
                          item: navbarItems,
                          style: TextStyles.rajdhaniSB
                              .colour(UiConstants.kTextColor),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          key: ValueKey(navbarItems.title),
                          alignment: Alignment.center,
                          width: SizeConfig.screenWidth! * 0.2,
                          child: GestureDetector(
                            onTap: () {
                              superModel.onItemTapped(index);
                            },
                            child: NavBarIcon(
                              animate: false,
                              item: navbarItems,
                              style: TextStyles.rajdhaniSB
                                  .colour(UiConstants.kTextColor2),
                            ),
                          ),
                        ),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final bool animate;
  final Key? key;
  final NavBarItemModel item;
  final TextStyle style;

  NavBarIcon(
      {required this.animate,
      required this.item,
      required this.style,
      this.key});
  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: item.key,
      description: item.title,
      child: Container(
          key: key,
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
          )),
    );
  }
}
