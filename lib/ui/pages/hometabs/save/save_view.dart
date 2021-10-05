import 'package:felloapp/core/enums/user_service_enums.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/buttons/flat_button/flatButton_view.dart';
import 'package:felloapp/ui/widgets/buttons/raisedButton/raised_button_view.dart';
import 'package:felloapp/ui/widgets/buttons/sellGoldButton/sellGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<SaveViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Container(
          padding: EdgeInsets.only(
              left: SizeConfig.globalMargin,
              top: SizeConfig.globalMargin * 2,
              right: SizeConfig.globalMargin),
          child: ListView(
            children: [
              PropertyChangeConsumer<UserService, UserServiceProperties>(
                  properties: [UserServiceProperties.myUserName],
                  builder: (context, model, properties) {
                    return Text(model.myUserName);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Widgets().getHeadlineLight(
                    "Savings growth",
                    Colors.black,
                  ),
                  Row(
                    children: [
                      Widgets().getHeadlineBold(
                        text: "15%",
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: UiConstants.primaryColor,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.globalMargin * 2, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Widgets().getHeadlineLight(
                              "Your gold balance", Colors.black),
                          Widgets().getHeadlineBold(
                              text: "${model.getGoldBalance()} gm",
                              color: Colors.amber),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(child: BuyGoldBtn()),
                          SizedBox(width: 24),
                          Expanded(child: SellGoldBtn()),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/aes256.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Image.asset(
                            "images/sebi.png",
                            color: Colors.blue,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Spacer(),
                          Widgets().getBodyLight(
                            "100% secure",
                            UiConstants.primaryColor,
                          ),
                        ],
                      ),
                      Divider(
                        height: 30,
                      ),
                      Widgets().getBodyBold(
                          "You get 1 ticket for every \$100 invested",
                          Colors.black)
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Widgets().getHeadlineLight("Your winnings", Colors.black),
                      Widgets().getHeadlineBold(
                          text: "₹ ${model.getUnclaimedPrizeBalance()}",
                          color: UiConstants.primaryColor),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets().getTitle("Recent Transactions", Colors.black)
                ],
              ),
              MiniTransactionCard(),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: RBtn(
                      text: "What is digital gold?",
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 2));
                        print("I am a future function");
                      },
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.mediumTextSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: FBtn(
                        text: "ABXS",
                        onPressed: () async {
                          await Future.delayed(Duration(seconds: 2));
                          print("I am a future function");
                        }),
                    // Widgets().getButton(
                    //   "ABXS",
                    //   () {},
                    //   Colors.grey[300],
                    // ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
