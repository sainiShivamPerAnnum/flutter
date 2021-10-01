import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/ui/elements/week-winners_board.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                          Widgets()
                              .getHeadlineLight("My winnings", Colors.black),
                          Widgets().getHeadlineBold(
                              text: "\$ 1000", color: UiConstants.primaryColor),
                        ],
                      ),
                      SizedBox(height: 12),
                      Widgets().getBodyBold("Redeem for", Colors.black),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Widgets().getButton(
                              "Augmont Digital Gold",
                              () {},
                              augmontGoldPalette.primaryColor,
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Widgets().getButton(
                              "Amazon Gift voucher",
                              () {},
                              Colors.orange,
                            ),
                          ),
                        ],
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
                      child: Widgets().getTitle(
                          "Play tambola and win upto \$1000", Colors.black),
                    )),
                  ),
                  Expanded(
                      child: Card(
                    child: Container(
                      height: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 30),
                      child: Widgets().getTitle(
                          "Refer your friend and win iphone", Colors.black),
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Widgets().getTitle("Scoreboard", Colors.black)],
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
