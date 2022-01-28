import 'dart:ui';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyWinningsView extends StatelessWidget {
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
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Winnings",
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: NestedScrollView(
                          // allows you to build a list of elements that would be scrolled away till the body reached the top
                          headerSliverBuilder: (context, _) {
                            return [
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  PrizeClaimCard(
                                    model: model,
                                  ),
                                  (model.userService.userFundWallet
                                                  ?.lockedPrizeBalance !=
                                              null &&
                                          model.userService.userFundWallet
                                                  .lockedPrizeBalance >
                                              0)
                                      ? InkWell(
                                          onTap: () {
                                            AppState.delegate.appState.currentAction = PageAction(
                                                state: PageState.addPage,
                                                page: ReferralDetailsPageConfig);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: SizeConfig.padding8,
                                                left: SizeConfig
                                                    .pageHorizontalMargins,
                                                right: SizeConfig
                                                    .pageHorizontalMargins),
                                            decoration: BoxDecoration(
                                              color: UiConstants.tertiaryLight,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.roundness16),
                                            ),
                                            padding: EdgeInsets.all(
                                                SizeConfig.padding16),
                                            child: Stack(
                                              children: [
                                                Text(
                                                  'Your Locked Balance will now be available as Golden Tickets. Click to know more',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyles.body3.light,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ]),
                              ),
                            ];
                          },
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: SizeConfig.padding24),
                              WinningsContainer(
                                shadow: false,
                                onTap: () {
                                  AppState.delegate.appState.currentAction =
                                      PageAction(
                                          state: PageState.addPage,
                                          page: GoldenMilestonesViewPageConfig);
                                },
                                child: Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.giftBoxOpen,
                                        ),
                                        SizedBox(
                                            width:
                                                SizeConfig.screenWidth * 0.05),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Earn your next\nGolden Tickets",
                                              style: TextStyles.body1
                                                  .colour(Colors.white)
                                                  .light,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.padding16,
                                    left: SizeConfig.pageHorizontalMargins),
                                child: Text(
                                  "My Rewards",
                                  style: TextStyles.title3.bold,
                                ),
                              ),
                              GoldenTicketsView()
                            ],
                          ),
                        )
                        //  ListView(
                        //   padding: EdgeInsets.zero,
                        //   // crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [

                        // ),
                        ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
