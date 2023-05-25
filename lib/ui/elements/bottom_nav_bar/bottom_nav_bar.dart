import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    RootController rootController = locator<RootController>();
    final navItemsLength = rootController.navItems.values.length;

    return Consumer<AppState>(
      builder: (ctx, superModel, child) => Selector<CardActionsNotifier, bool>(
          selector: (_, notifier) => notifier.isVerticalView,
          builder: (context, isCardsOpen, child) {
            if (isCardsOpen) return const SizedBox();
            return AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              child: BottomAppBar(
                notchMargin: navItemsLength % 2 != 0 ? 7 : 0,
                shape: const CircularNotchedRectangle(),
                color: Colors.black,
                height: SizeConfig.navBarHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    navItemsLength,
                    (index) {
                      if (index == (navItemsLength / 2).floor()) {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }

                      final navbarItems =
                          rootController.navItems.values.toList()[index];
                      return superModel.getCurrentTabIndex == index
                          ? Expanded(
                              key: ValueKey(navbarItems.title),
                              child: NavBarIcon(
                                callBack: () => superModel.onItemTapped(index),
                                key: ValueKey(navbarItems.title),
                                animate: true,
                                item: navbarItems,
                                style: TextStyles.rajdhaniSB
                                    .colour(UiConstants.kTextColor),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                height: SizeConfig.navBarHeight,
                                key: ValueKey(navbarItems.title),
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth! * 0.2,
                                child: GestureDetector(
                                  onTap: () {
                                    superModel.onItemTapped(index);
                                  },
                                  child: NavBarIcon(
                                    callBack: () {
                                      superModel.onItemTapped(index);
                                    },
                                    animate: false,
                                    item: navbarItems,
                                    style: TextStyles.rajdhaniSB
                                        .colour(UiConstants.kTextColor2),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final bool animate;
  final Key? key;
  final NavBarItemModel item;
  final TextStyle style;
  final VoidCallback callBack;

  const NavBarIcon({
    required this.animate,
    required this.item,
    required this.style,
    required this.callBack,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      onTargetClick: callBack,
      disposeOnTap: false,
      key: item.key,
      description: item.title == 'Play'
          ? 'Tap on the Play section'
          : item.title == 'Save'
              ? 'What are you waiting for?\nStart your savings journey now!'
              : 'You can find your scratch cards here. Tap on Account Section',
      child: Container(
        key: key,
        alignment: Alignment.center,
        // color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -SizeConfig.navBarHeight * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.navBarHeight * 0.6,
                    width: SizeConfig.navBarHeight * 0.6,
                    child: Lottie.asset(
                      item.lottie,
                      fit: BoxFit.contain,
                      animate: animate,
                      repeat: false,
                    ),
                  ),
                  Text(item.title, style: style),
                  SizedBox(height: SizeConfig.navBarHeight * 0.1)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
