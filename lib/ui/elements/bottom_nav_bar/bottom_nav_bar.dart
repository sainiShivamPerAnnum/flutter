import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/shared/show_case.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    RootController rootController = locator<RootController>();
    final navItemsLength = rootController.navItems.values.length;
    final locale = locator<S>();
    return Consumer<AppState>(
      builder: (ctx, superModel, child) => Selector<CardActionsNotifier, bool>(
          selector: (_, notifier) => notifier.isVerticalView,
          builder: (context, isCardsOpen, child) {
            return AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              height: isCardsOpen ? 0 : SizeConfig.navBarHeight,
              child: BottomAppBar(
                notchMargin: navItemsLength % 2 == 0 ? 7 : 0,
                shape: const CircularNotchedRectangle(),
                color: Colors.black,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    navItemsLength,
                    (index) {
                      final navbarItems =
                          rootController.navItems.values.toList()[index];
                      return superModel.getCurrentTabIndex == index
                          ? Expanded(
                              key: ValueKey(navbarItems.title),
                              child: GestureDetector(
                                onTap: () => superModel.onItemTapped(index),
                                child: NavBarIcon(
                                  key: ValueKey(navbarItems.title),
                                  animate: true,
                                  item: navbarItems,
                                  style: TextStyles.rajdhaniSB
                                      .colour(UiConstants.kTextColor),
                                ),
                              ),
                            )
                          : Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  superModel.onItemTapped(index);
                                },
                                child: Container(
                                  height: kBottomNavigationBarHeight,
                                  key: ValueKey(navbarItems.title),
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: ShowCaseView(
                                    onTargetClick: () =>
                                        superModel.onItemTapped(index),
                                    globalKey: tutorialkey3,
                                    title: null,
                                    description: locale.tutorial3,
                                    shapeBorder: const RoundedRectangleBorder(),
                                    child: NavBarIcon(
                                      animate: false,
                                      item: navbarItems,
                                      style: TextStyles.rajdhaniSB
                                          .colour(UiConstants.kTextColor2),
                                    ),
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
  @override
  final Key? key;
  final NavBarItemModel item;
  final TextStyle style;

  const NavBarIcon({
    required this.animate,
    required this.item,
    required this.style,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: kBottomNavigationBarHeight * 0.61,
          width: kBottomNavigationBarHeight * 0.65,
          child: Lottie.asset(
            item.lottie,
            fit: BoxFit.contain,
            animate: animate,
            repeat: false,
          ),
        ),
        const SizedBox(height: kBottomNavigationBarHeight * 0.05),
        Text(item.title, style: style),
        // SizedBox(height: SizeConfig.navBarHeight * 0.1)
      ],
    );
  }
}
