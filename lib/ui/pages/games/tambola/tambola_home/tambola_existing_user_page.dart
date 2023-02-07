import 'dart:math';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/ticket_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/sticky_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaExistingUserPage extends StatefulWidget {
  TambolaExistingUserPage({Key? key, required this.model}) : super(key: key);
  final TambolaHomeViewModel model;

  @override
  State<TambolaExistingUserPage> createState() =>
      _TambolaExistingUserPageState();
}

class _TambolaExistingUserPageState extends State<TambolaExistingUserPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
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
      appBar: FAppBar(
        // type: FaqsType.play,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,

        action: Row(
          children: [
            TextButton(
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
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                side: BorderSide(color: Colors.white, width: 1),
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
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            InkWell(
              onTap: () =>
                  AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addWidget,
                page: TambolaNewUser,
                widget: TambolaNewUserPage(
                  model: widget.model,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1a1a1a),
                    border: Border.all(color: Colors.white)),
                padding: EdgeInsets.all(6),
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
        backgroundColor: UiConstants.kArrowButtonBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          const NewSquareBackground(),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: UiConstants.kArrowButtonBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding26)
                            .copyWith(top: SizeConfig.padding10),
                    child: Image.asset(Assets.win1croreBanner)),
                TodayWeeklyPicksCard(
                  model: widget.model,
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                StickyNote(
                  trailingWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.padding16,
                      ),
                      SizedBox(
                        width: SizeConfig.padding4,
                      ),
                      Text("1", style: TextStyles.sourceSansB.title3),
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      Text(
                        "ticket every week",
                        style: TextStyles.sourceSansSB.body4,
                      )
                    ],
                  ),
                  amount: "500",
                ),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                if (widget.model.userWeeklyBoards != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                locale.tTotalTickets +
                                    "${widget.model.activeTambolaCardCount}",
                                style: TextStyles.rajdhaniSB.body1),
                            if (TambolaRepo.expiringTicketCount != 0)
                              Text(
                                "${TambolaRepo.expiringTicketCount} ticket${TambolaRepo.expiringTicketCount > 1 ? 's' : ''} expiring this sunday",
                                style: TextStyles.sourceSansSB.body4
                                    .colour(Colors.redAccent.withOpacity(0.8)),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                            animationController
                                .forward()
                                .then((value) => animationController.reset());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding12,
                              vertical: SizeConfig.padding6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness40),
                            ),
                            child: Text(
                              locale.tGetTickets,
                              style: TextStyles.rajdhaniSB.body2,
                              key: ValueKey(Constants.GET_TAMBOLA_TICKETS),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding6,
                  ),
                  TicketsView(model: widget.model),
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
                  height: SizeConfig.padding14,
                ),
                GestureDetector(
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: TambolaNewUser,
                      widget: TambolaNewUserPage(
                        model: widget.model,
                        showWinners: true,
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
                          "Last week Winners",
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
                  height: 32,
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
                SizedBox(
                  height: SizeConfig.padding4,
                ),
                TermsAndConditions(url: Constants.tambolatnc),
                SizedBox(
                  height: SizeConfig.navBarHeight + SizeConfig.padding16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
