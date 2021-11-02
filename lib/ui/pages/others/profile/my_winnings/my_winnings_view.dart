import 'dart:math';

import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/user_winnings.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MyWinningsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.getWinningHistory();
      },
      builder: (ctx, model, child) {
        return Scaffold(
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
                      child: ListView(
                        padding: EdgeInsets.only(
                            top: SizeConfig.pageHorizontalMargins),
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "myWinnings",
                            child: WinningsContainer(
                              shadow: false,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding24),
                          PrizeClaimCard(
                            model: model,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            child: Text(
                              "Winning History",
                              style: TextStyles.title3.bold,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          model.isWinningHistoryLoading
                              ? ListLoader()
                              : (model.winningHistory != null &&
                                      model.winningHistory.isNotEmpty
                                  ? Container(
                                      height: SizeConfig.screenHeight * 0.5,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.navBarHeight),
                                        physics: BouncingScrollPhysics(),
                                        itemCount: model.winningHistory.length,
                                        itemBuilder: (ctx, i) => ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .pageHorizontalMargins),
                                          leading: CircleAvatar(
                                            radius: SizeConfig.padding24,
                                            backgroundColor: model.colorList[
                                                Random().nextInt(
                                                    model.colorList.length)],
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  SizeConfig.padding4),
                                              child: SvgPicture.asset(
                                                  Assets.congrats),
                                            ),
                                          ),
                                          title: Text(
                                            model.getWinningHistoryTitle(model
                                                .winningHistory[i].subType),
                                            style: TextStyles.body2.bold,
                                          ),
                                          subtitle: Text(
                                            DateFormat("dd MMM, yyyy").format(
                                                model
                                                    .winningHistory[i].timestamp
                                                    .toDate()),
                                            style: TextStyles.body3
                                                .colour(Colors.grey),
                                          ),
                                          trailing: Text(
                                            "₹ ${model.winningHistory[i]?.amount}",
                                            style: TextStyles.body2.bold.colour(
                                                model.winningHistory[i].amount >
                                                        0
                                                    ? UiConstants.primaryColor
                                                    : Colors.red[300]),
                                          ),
                                        ),
                                      ),
                                    )
                                  : NoRecordDisplayWidget(
                                      asset: Assets.noTransaction,
                                      text: "No Winning History yet",
                                    ))
                        ],
                      ),
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


//                             Card(
//                             margin: EdgeInsets.symmetric(vertical: 20),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 25),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Text("My winnings",
//                                           style: TextStyles.body3.light),
//                                       PropertyChangeConsumer<UserService,
//                                           UserServiceProperties>(
//                                         builder: (ctx, model, child) => Text(
//                                           //"₹ 0.00",
//                                           "₹ ${model.userFundWallet.unclaimedBalance}",
//                                           style: TextStyles.body2.bold
//                                               .colour(UiConstants.primaryColor),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // SizedBox(height: 12),
//                                   // Widgets().getBodyBold("Redeem for", Colors.black),
//                                   SizedBox(height: 12),
//                                   //if (model.getUnclaimedPrizeBalance > 0)
//                                   PropertyChangeConsumer<UserService,
//                                       UserServiceProperties>(
//                                     builder: (ctx, m, child) => FelloButton(
//                                       defaultButtonText: m.userFundWallet
//                                               .isPrizeBalanceUnclaimed()
//                                           ? "Redeem"
//                                           : "Share",
//                                       onPressedAsync: () =>
//                                           model.prizeBalanceAction(context),
//                                       defaultButtonColor: Colors.orange,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
