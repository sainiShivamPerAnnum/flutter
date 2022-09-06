import 'dart:developer';
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

class BottomNavBar extends StatefulWidget {
  final RootViewModel parentModel;
  BottomNavBar({@required this.parentModel});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  AnimationController journeyLottieController,
      playLottieController,
      saveLottieController,
      winLottieController;
  List<NavBarItemModel> navbarItems;
  @override
  void initState() {
    log("BottomNavbar init called");
    journeyLottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    playLottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    saveLottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    winLottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    navbarItems = [
      NavBarItemModel(
          'Journey',
          Assets.navJourneyActive,
          Assets.navJourneyInactive,
          Assets.navJourneyLottie,
          journeyLottieController),
      NavBarItemModel('Play', Assets.navPlayActive, Assets.navPlayInactive,
          Assets.navPlayLottie, playLottieController),
      NavBarItemModel('Save', Assets.navSaveActive, Assets.navSaveInactive,
          Assets.navSaveLottie, saveLottieController),
      NavBarItemModel('Win', Assets.navWinActive, Assets.navWinInactive,
          Assets.navWinLottie, winLottieController)
    ];
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navbarItems[0].controller.forward();
    });
  }

  onNavItemTap(int index, AppState appStateInstance) {
    if (appStateInstance.getCurrentTabIndex != index) {
      navbarItems.forEach((element) {
        element.controller.reset();
      });
      widget.parentModel.onItemTapped(index);
      navbarItems[index].controller.forward(from: 0.0);
    } else {
      navbarItems[index].controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, superModel, child) =>
          PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
        builder: (context, model, properties) {
          return Positioned(
            bottom: model.avatarRemoteMlIndex > 2
                ? 0
                : -SizeConfig
                    .navBarHeight, //SizeConfig.pageHorizontalMargins / 2,
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
                      child: GestureDetector(
                        onTap: () {
                          onNavItemTap(index, superModel);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.navBarHeight * 0.6,
                                // color: Colors.green,
                                width: SizeConfig.navBarHeight * 0.6,
                                child: Lottie.asset(navbarItems[index].lottie,
                                    fit: BoxFit.contain,
                                    controller: navbarItems[index].controller,
                                    repeat: false),
                              ),
                              Text(navbarItems[index].title,
                                  style: superModel.getCurrentTabIndex == index
                                      ? TextStyles.rajdhaniSB
                                          .colour(UiConstants.kTextColor)
                                      : TextStyles.rajdhaniSB
                                          .colour(UiConstants.kTextColor2))
                            ],
                          ),
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
