import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  List<dynamic> get tileUrls =>
      AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['howScreen']['tileUrls'] ??
      [];

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: Stack(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                const FAppBar(
                  showAvatar: false,
                  showCoinBar: false,
                  showHelpButton: false,
                  backgroundColor: Colors.transparent,
                  title: 'How it works?',
                  centerTitle: true,
                ),
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowIndicator();
                      return true;
                    },
                    child: ListView.separated(
                      itemCount: tileUrls.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding16,
                        vertical: SizeConfig.padding20,
                      ),
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl: tileUrls[index],
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      separatorBuilder: (context, index) => Divider(
                        height: 48,
                        thickness: .8,
                        color: Colors.white.withOpacity(.50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 13,
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: Colors.white,
                    onPressed: () {
                      AppState.delegate!.appState.currentAction = PageAction(
                        state: PageState.replace,
                        page: PowerPlayHomeConfig,
                      );
                    },
                    child: Center(
                      child: Text(
                        'START PREDICTING NOW',
                        style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
