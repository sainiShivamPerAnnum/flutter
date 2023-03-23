import 'dart:math';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/ticket_widget.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/buy_ticket_widget.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/how_tambola_works_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TambolaExistingUserScreen extends StatefulWidget {
  const TambolaExistingUserScreen({Key? key, required this.model})
      : super(key: key);

  final TambolaHomeViewModel model;

  @override
  State<TambolaExistingUserScreen> createState() =>
      _TambolaExistingUserScreenState();
}

class _TambolaExistingUserScreenState extends State<TambolaExistingUserScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      appBar: _buildFAppBar(locale),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TodayWeeklyPicksCard(
                  model: widget.model,
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                if (widget.model.userWeeklyBoards != null)
                  TicketWidget(
                      model: widget.model,
                      animationController: animationController,
                      scrollController: _scrollController,
                      locale: locale)
                else
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FullScreenLoader(),
                        SizedBox(height: SizeConfig.padding20),
                        Text(
                          locale.tFetch,
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
                      page: AllTambolaTicketsPageConfig,
                      widget: AllTambolaTickets(
                          ticketList: widget.model.tambolaBoardViews!.toList()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.06),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff627F8E).withOpacity(0.2),
                      border: Border.all(color: const Color(0xff627F8E)),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.tViewAllTicks,
                          style: TextStyles.rajdhaniSB.body1,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: SizeConfig.padding16,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (ctx, child) {
                    final sineValue =
                        sin(5 * 2 * pi * animationController.value);
                    return Transform.translate(
                      offset: Offset(sineValue * 5, 0),
                      child: child,
                    );
                  },
                  child: ButTicketsComponent(
                    model: widget.model,
                  ),
                ),
                TambolaLeaderBoard(
                  model: widget.model,
                ),
                SizedBox(
                  height: SizeConfig.padding34,
                ),
                HowTambolaWorks(model: widget.model),
                SizedBox(height: SizeConfig.padding14),
                LottieBuilder.network(
                    "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),
                SizedBox(height: SizeConfig.navBarHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FAppBar _buildFAppBar(S locale) {
    return FAppBar(
      // type: FaqsType.play,
      showAvatar: false,
      showCoinBar: false,
      showHelpButton: false,

      action: Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              onSurface: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
            ),
            onPressed: () {
              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addWidget,
                page: TambolaNewUser,
                widget: TambolaNewUserPage(
                  model: widget.model,
                  showPrizeSection: true,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "Prizes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.body2,
                ),
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          InkWell(
            onTap: () => AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addWidget,
              page: TambolaNewUser,
              widget: TambolaNewUserPage(
                model: widget.model,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff1a1a1a),
                  border: Border.all(color: Colors.white)),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.question_mark,
                color: Colors.white,
                size: SizeConfig.padding20,
              ),
            ),
          )
        ],
      ),
      title: locale.tTitle,
      backgroundColor: UiConstants.kBackgroundColor,
    );
  }
}

/// TODO: After refactoring update the original widget with this widget
