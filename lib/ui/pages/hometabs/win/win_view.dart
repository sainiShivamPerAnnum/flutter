import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/ui/elements/week-winners_board.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<WinViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Container(
          padding: EdgeInsets.only(
              left: SizeConfig.globalMargin,
              top: SizeConfig.globalMargin * 2,
              right: SizeConfig.globalMargin),
          child: ListView(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("My winnings", style: TextStyles.body3.light),
                          PropertyChangeConsumer<UserService,
                              UserServiceProperties>(
                            builder: (ctx, model, child) => Text(
                              //"₹ 0.00",
                              "₹ ${model.userFundWallet.unclaimedBalance}",
                              style: TextStyles.body2.bold
                                  .colour(UiConstants.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 12),
                      // Widgets().getBodyBold("Redeem for", Colors.black),
                      SizedBox(height: 12),
                      if (model.getUnclaimedPrizeBalance > 0)
                        PropertyChangeConsumer<UserService,
                            UserServiceProperties>(
                          builder: (ctx, m, child) => FelloButton(
                            defaultButtonText:
                                m.userFundWallet.isPrizeBalanceUnclaimed()
                                    ? "Redeem"
                                    : "Share",
                            onPressedAsync: () =>
                                model.prizeBalanceAction(context),
                            defaultButtonColor: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Card(
                        child: Container(
                      height: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 30),
                      child: Text(
                        "Play tambola and win upto \$1000",
                        style: TextStyles.body2.bold,
                      ),
                    )),
                  ),
                  Expanded(
                      child: Card(
                    child: Container(
                      height: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 30),
                      child: Text(
                        "Refer your friend and win iphone",
                        style: TextStyles.body2.bold,
                      ),
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Scoreboard", style: TextStyles.body2.bold),
                ],
              ),
              Container(
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [WeekWinnerBoard(), Leaderboard()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
