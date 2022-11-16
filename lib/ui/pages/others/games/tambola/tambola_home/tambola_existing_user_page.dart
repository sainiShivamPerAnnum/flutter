import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/tambola/tambola_widget.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaExistingUserPage extends StatelessWidget {
  TambolaExistingUserPage({Key? key, required this.model}) : super(key: key);
  final TambolaHomeViewModel model;
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        type: FaqsType.play,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        title: "Tambola",
        backgroundColor: UiConstants.kArowButtonBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          NewSquareBackground(),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TodayWeeklyPicksCard(
                  model: model,
                ),
                if (model.userWeeklyBoards != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tickets(${model.activeTambolaCardCount})',
                            style: TextStyles.rajdhaniSB.body1),
                        GestureDetector(
                          onTap: () {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness40),
                            ),
                            child: Text(
                              '+ Get Tickets',
                              style: TextStyles.rajdhaniSB.body2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TicketsView(model: model),
                ] else
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FullScreenLoader(),
                        SizedBox(height: SizeConfig.padding20),
                        Text(
                          "Fetching your tambola tickets..",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: TambolaNewUser,
                      widget: TambolaNewUserPage(
                        model: model,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.06),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xff627F8E).withOpacity(0.2),
                      border: Border.all(color: Color(0xff627F8E)),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View All Tickets',
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                ButTicketsComponent(
                  model: model,
                ),
                SizedBox(
                  height: 52,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
