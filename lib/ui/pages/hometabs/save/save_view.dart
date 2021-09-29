import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);
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
                              text: "0.567 gm", color: Colors.amber),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Widgets().getButton(
                              "Buy",
                              () {
                                print(baseProvider.todaysPicks);
                              },
                              augmontGoldPalette.primaryColor,
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Widgets().getButton(
                              "Sell",
                              () {},
                              Colors.grey[300],
                            ),
                          ),
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
                          text: "\$ 1000", color: UiConstants.primaryColor),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Widgets().getTitle("History", Colors.black)],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Widgets().getButton(
                      "What is digital Gold",
                      () {},
                      Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Widgets().getButton(
                      "ABXS",
                      () {},
                      Colors.grey[300],
                    ),
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
