import 'package:felloapp/ui/pages/f3_dummy_pages/widgets.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    "15%",
                    Colors.black,
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
                      Widgets()
                          .getHeadlineLight("Your gold balance", Colors.black),
                      Widgets().getHeadlineBold("0.567 gm", Colors.amber),
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
                          () {},
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
                      "You get 1 ticket for every \$100 invested", Colors.black)
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
                  Widgets()
                      .getHeadlineBold("\$ 1000", UiConstants.primaryColor),
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
  }
}
