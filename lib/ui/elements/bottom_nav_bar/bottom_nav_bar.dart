import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/cart_actions.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    RootController rootController = locator<RootController>();
    final navItemsLength = rootController.navItems.values.length;

    return Consumer<AppState>(
      builder: (ctx, superModel, child) => BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
              maxHeight: state is CartItemAdded
                  ? SizeConfig.navBarHeight + 73.h
                  : SizeConfig.navBarHeight,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                    height: SizeConfig.navBarHeight,
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
                                      onTap: () =>
                                          superModel.onItemTapped(index),
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
                                        key: ValueKey(navbarItems.title),
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: NavBarIcon(
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
                  ),
                ),
                if (state is CartItemAdded)
                  Positioned(
                    bottom: SizeConfig.navBarHeight + 10.h,
                    left: 20.w,
                    right: 20.w,
                    child: CartActions(
                      cart: state,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.body1,
          width: SizeConfig.body1,
          child: AppImage(
            item.icon,
            color: style.color,
          ),
        ),
        Text(item.title, style: style),
      ],
    );
  }
}
