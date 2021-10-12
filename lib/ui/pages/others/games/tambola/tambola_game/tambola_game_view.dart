import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/tambola_faq_section.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TambolaGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<TambolaGameViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  PicksCardView(),
                  // if (showCardSummary)
                  //   _buildTicketSummaryCards(
                  //       baseProvider.weeklyTicksFetched,
                  //       baseProvider.weeklyDrawFetched,
                  //       baseProvider.userWeeklyBoards,
                  //       _activeTambolaCardCount),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 3,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    child: Row(
                      children: [
                        Text(
                          "My Tickets (${model.activeTambolaCardCount})",
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: SizeConfig.cardTitleTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: model.showAllBoards,
                          highlightColor:
                              UiConstants.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: UiConstants.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              "Show All",
                              style: GoogleFonts.montserrat(
                                color: UiConstants.primaryColor,
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  connectivityStatus != ConnectivityStatus.Offline
                      ? model.buildCards()
                      : Center(
                          child: NetworkBar(
                            textColor: Colors.black,
                          ),
                        ),
                  PrizeSection(),
                  TambolaFaqSection()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
