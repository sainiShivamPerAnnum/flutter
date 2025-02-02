import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/user_bootup_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/elements/dev_rel/flavor_banners.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/my_account_components/win_helpers.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/shared/marquee_text.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/lazy_load_indexed_stack.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

GlobalKey felloAppBarKey = GlobalKey();

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final isNewUser = locator<UserService>().userSegments.contains(
        Constants.NEW_USER,
      );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RootViewModel>(
      onModelReady: (model) {
        model.onInit();
      },
      onModelDispose: (model) => model.onDispose(),
      builder: (ctx, model, child) {
        return Stack(
          children: [
            BaseScaffold(
              resizeToAvoidBottomInset: false,
              showBackgroundGrid: true,
              body: Stack(
                children: [
                  Column(
                    children: [
                      const RootAppBar(),
                      Consumer<AppState>(
                        builder: (ctx, m, child) {
                          if (m.getCurrentTabIndex == 0) {
                            return const HeadAlerts();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Expanded(
                        child: Consumer<AppState>(
                          builder: (ctx, m, child) {
                            return LazyLoadIndexedStack(
                              index: m.getCurrentTabIndex,
                              children: model.navBarItems.keys.toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const DEVBanner(),
                  const QABanner(),
                ],
              ),
              bottomNavigationBar: const BottomNavBar(),
            ),
            const CircularAnim(),
            // Positioned.fill(
            //   child: Container(
            //     color: Colors.black.withOpacity(0.85),
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: DefaultTextStyle(
            //           style: TextStyles.sourceSans.body1
            //               .colour(UiConstants.kTextColor)
            //               .copyWith(height: 1.5),
            //           child: Text(
            //             locale.tutorialstart,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class HeadAlerts extends StatelessWidget {
  const HeadAlerts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, UserBootUpDetailsModel?>(
      selector: (ctx, userService) => userService.userBootUp,
      builder: (ctx, bootUp, child) {
        final data = bootUp?.data;

        if (data == null || data.marqueeMessages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.padding40,
          color: data.marqueeColor.toColor(),
          child: MarqueeText(
            infoList: data.marqueeMessages,
            showBullet: true,
            bulletColor: Colors.white,
            textColor: Colors.white,
          ),
        );
      },
    );
  }
}

class RootAppBar extends StatelessWidget {
  const RootAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.mySegments],
      builder: (_, userservice, ___) {
        return Consumer<AppState>(
          builder: (ctx, appState, child) {
            return Consumer<AppState>(
              builder: (ctx, m, child) {
                if (m.rootIndex == 0) {
                  return Container(
                    width: SizeConfig.screenWidth,
                    height: kToolbarHeight + SizeConfig.viewInsets.top,
                    alignment: Alignment.bottomCenter,
                    child: FAppBar(
                      showAvatar: true,
                      leadingPadding: false,
                      titleWidget: Expanded(
                        child: Salutation(
                          leftMargin: SizeConfig.padding8,
                          textStyle: TextStyles.sourceSansSB.body1
                              .colour(Colors.white),
                        ),
                      ),
                      backgroundColor: UiConstants.kBackgroundColor,
                      showCoinBar: false,
                    ),
                  );
                }
                return Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.viewInsets.top,
                  alignment: Alignment.bottomCenter,
                  child: const SizedBox.shrink(),
                );
              },
            );
          },
        );
      },
    );
  }
}
