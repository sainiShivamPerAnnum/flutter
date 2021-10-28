import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/user_winnings.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  title: "My Winnings",
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
                          Text(
                            "Unclaimed Balance: ${model.userService.userFundWallet.unclaimedBalance} ",
                            style: TextStyles.body3,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            child: Row(
                              children: [
                                ClaimButton(
                                  color: Color(0xff11192B),
                                  image: Assets.amazonClaim,
                                  onTap: () => model.showConfirmDialog(
                                      PrizeClaimChoice.AMZ_VOUCHER),
                                  text: "Redeem as Amazon Pay Gift Card",
                                ),
                                SizedBox(
                                  width: SizeConfig.padding12,
                                ),
                                ClaimButton(
                                  color: UiConstants.tertiarySolid,
                                  image: Assets.goldClaim,
                                  onTap: () => model.showConfirmDialog(
                                      PrizeClaimChoice.GOLD_CREDIT),
                                  text: "Redeem as Digital Gold",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding20),
                          Container(
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            height: SizeConfig.padding54,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding32),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
                              color: UiConstants.tertiaryLight.withOpacity(0.5),
                            ),
                            child: FittedBox(
                              child: Text(
                                "Winnings can be redeemed after reaching ₹100",
                                style: TextStyles.body3,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding24),
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
                                        padding: EdgeInsets.zero,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: model.winningHistory.length,
                                        itemBuilder: (ctx, i) => ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .pageHorizontalMargins),
                                          leading: CircleAvatar(
                                            radius: SizeConfig.padding24,
                                            backgroundImage: NetworkImage(
                                                "https://upload.wikimedia.org/wikipedia/en/5/51/Minecraft_cover.png"),
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
                                                UiConstants.primaryColor),
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

class ClaimButton extends StatelessWidget {
  final Color color;
  final String image;
  final String text;
  final Function onTap;

  ClaimButton({
    @required this.color,
    @required this.image,
    @required this.onTap,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FelloButton(
        onPressed: onTap,
        activeButtonUI: Container(
          height: SizeConfig.screenWidth * 0.2,
          width: SizeConfig.screenWidth * 0.422,
          decoration: BoxDecoration(
            color: color ?? UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.padding20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
            vertical: SizeConfig.padding16,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.padding24,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Image.asset(
                  image ?? Assets.amazonClaim,
                ),
              ),
              SizedBox(width: SizeConfig.padding6),
              Expanded(
                child: Text(
                  text ?? "Redeem for amazon pay",
                  style: TextStyles.body2.colour(Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
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
