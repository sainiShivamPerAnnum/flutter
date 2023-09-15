import 'dart:async';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaRewardLottieStrip extends StatefulWidget {
  const TambolaRewardLottieStrip({
    super.key,
  });

  @override
  State<TambolaRewardLottieStrip> createState() =>
      _TambolaRewardLottieStripState();
}

class _TambolaRewardLottieStripState extends State<TambolaRewardLottieStrip> {
  final List<String> _goldMarquee = [
    'Get Tickets on saving ₹500',
    'Play Tickets Tutorial',
    'Last Week’s Leaderboard',
  ];

  final List<String> icon = [
    Assets.goldAsset,
    Assets.tambolaCardAsset,
    'assets/svg/trophy_banner.svg',
  ];

  void onTap(int index) {
    switch (index) {
      case 0:
        AppState.delegate!.appState.currentAction = PageAction(
          page: AssetSelectionViewConfig,
          state: PageState.addWidget,
          widget: const AssetSelectionPage(
            showOnlyFlo: false,
          ),
        );
        break;
      case 1:
        AppState.delegate!.parseRoute(Uri.parse('ticketsIntro'));
        break;
      case 2:
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: TambolaNewUser,
          widget: TambolaHomeDetailsView(
            isStandAloneScreen: true,
            showWinners: true,
            showPrizeSection: false,
            showBottomButton: false,
            showDemoImage: false,
          ),
        );
        break;
    }
  }

  late final PageController _controller = PageController(initialPage: 0);

  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentPage < 3) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_controller.hasClients) {
          _controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kFloContainerColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      margin: EdgeInsets.only(
        bottom: SizeConfig.padding10,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
      ),
      height: SizeConfig.padding48,
      width: SizeConfig.screenWidth,
      child: PageView.builder(
        controller: _controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.tambolaCarousel,
                  properties: {
                    'order': index + 1,
                  });
              onTap(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10,
                  vertical: SizeConfig.padding12),
              child: Row(
                children: [
                  SizedBox(
                    height: SizeConfig.padding26,
                    width: SizeConfig.padding32,
                    child: SvgPicture.asset(
                      icon[index],
                      height: SizeConfig.padding26,
                      width: SizeConfig.padding32,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  Text(_goldMarquee[index],
                      style: TextStyles.rajdhaniSB.body0.colour(Colors.white)),
                  const Spacer(),
                  SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: UiConstants.primaryColor,
                    height: SizeConfig.padding24,
                    width: SizeConfig.padding24,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
