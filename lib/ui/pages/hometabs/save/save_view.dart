import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Savings growth",
                    style: TextStyles.body3,
                  ),
                  Row(
                    children: [
                      Text(
                        "15%",
                        style:
                            TextStyles.body2.colour(UiConstants.primaryColor),
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
                          Text("My Gold Balance: ",
                              style: TextStyles.title3.light),
                          PropertyChangeConsumer<UserService,
                              UserServiceProperties>(
                            builder: (ctx, model, child) => Text(
                              "${model.userFundWallet.augGoldQuantity} gm",
                              style: TextStyles.title3.bold.colour(
                                  FelloColorPalette.augmontFundPalette()
                                      .primaryColor),
                            ),
                          ),
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
                          Text(
                            "100% secure",
                            style: TextStyles.body3
                                .colour(UiConstants.primaryColor),
                          ),
                        ],
                      ),
                      Divider(
                        height: 30,
                      ),
                      Text("You get 1 ticket for every \$100 invested",
                          style: TextStyles.body3)
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
                      Text("Your winnings", style: TextStyles.body3),
                      Text(
                        "₹ ${model.getUnclaimedPrizeBalance()}",
                        style:
                            TextStyles.body2.colour(UiConstants.primaryColor),
                      ),
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
                  Text("Recent Transactions", style: TextStyles.title2.bold)
                ],
              ),
              MiniTransactionCard(),
              SizedBox(height: 40),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FelloButton(
                      // text: "FelloButton",
                      // bgColor: UiConstants.primaryColor,
                      textStyle: TextStyle(color: Colors.white),
                      action: (val) {
                        if (val) print("I Changed");
                      },
                      offlineButtonUI: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        alignment: Alignment.center,
                        child: Text("Fello Button"),
                      ),
                      activeButtonUI: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: UiConstants.primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: Text("Fello Button"),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => FelloConfirmationDialog(
                            content: Padding(
                              padding:
                                  EdgeInsets.all(SizeConfig.globalMargin * 3),
                              child:
                                  SvgPicture.asset("images/svgs/offline.svg"),
                            ),
                            onAccept: () async {
                              Navigator.pop(context);

                              AppState.delegate.appState.currentAction =
                                  PageAction(
                                page: TransactionPageConfig,
                                state: PageState.addPage,
                              );
                            },
                            onReject: () => Navigator.pop(context),
                            result: (res) {
                              if (res) print("I Changed");
                            },
                          ),
                        );
                      }),
                  FelloButton(
                    onPressedAsync: () async {
                      await Future.delayed(Duration(seconds: 3));
                    },
                    onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => FelloInfoDialog(
                        title: "Info Dialog",
                        subtitle: "This is the subtitle",
                        body:
                            "What other ways do you use to minimize the app size ??with tooling and language features that allow developers to eliminate a whole class of errors, increase app performance and reduce package size.",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
