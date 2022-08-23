import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class MyWinningsView extends StatelessWidget {
  final openFirst;
  MyWinningsView({this.openFirst = false});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.getWinningHistory();
        // model.getGoldenTickets();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          //floatingActionButton: AddTodoButton(),
          backgroundColor: UiConstants.kBackgroundColor,
          body: Stack(
            children: [
              NewSquareBackground(),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    AppBar(
                      title: Text(
                        'My Rewards',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyles.title4.bold.colour(Colors.white),
                      ),
                      elevation: 0.0,
                      backgroundColor: UiConstants.kBackgroundColor,
                      leading: IconButton(
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: NestedScrollView(
                            // allows you to build a list of elements that would be scrolled away till the body reached the top
                            headerSliverBuilder: (context, _) {
                              return [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      PrizeClaimCard(
                                        model: model,
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            body: Container(
                              margin:
                                  EdgeInsets.only(top: SizeConfig.padding20),
                              child: GoldenTicketsView(
                                openFirst: openFirst,
                              ),
                            ),
                          )
                          //  ListView(
                          //   padding: EdgeInsets.zero,
                          //   // crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [

                          // ),
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
