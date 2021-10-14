import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AugmontGoldBuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          whiteBackground: WhiteBackground(
              color: Color(0xffF1F6FF), height: kToolbarHeight * 2.7),
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: "Buy Digital Gold",
              ),
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.padding12,
                  right: SizeConfig.pageHorizontalMargins,
                  left: SizeConfig.pageHorizontalMargins,
                ),
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth * 0.212,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                    color: UiConstants.primaryColor,
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg_pattern.png"),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: UiConstants.primaryColor.withOpacity(0.5),
                        offset: Offset(
                          0,
                          SizeConfig.screenWidth * 0.1,
                        ),
                        spreadRadius: -30,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                        icon: CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(
                            Icons.ac_unit,
                            color: Colors.white,
                            size: SizeConfig.iconSize3,
                          ),
                        ),
                        label: Text("24K",
                            style: TextStyles.body3.colour(Colors.white)),
                        onPressed: () {}),
                    TextButton.icon(
                      icon: CircleAvatar(
                        radius: SizeConfig.screenWidth * 0.029,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.white,
                          size: SizeConfig.iconSize3,
                        ),
                      ),
                      label: Text("99.99% Pure",
                          style: TextStyles.body3.colour(Colors.white)),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                        icon: CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(
                            Icons.ac_unit,
                            color: Colors.white,
                            size: SizeConfig.iconSize3,
                          ),
                        ),
                        label: Text("100% Secure",
                            style: TextStyles.body3.colour(Colors.white)),
                        onPressed: () {}),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding20,
                      vertical: SizeConfig.padding32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Enter Amount",
                        style: TextStyles.title4.bold,
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenWidth * 0.135,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffDFE4EC),
                          ),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: model.goldAmountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: SizeConfig.screenWidth * 0.275,
                              height: SizeConfig.screenWidth * 0.135,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(SizeConfig.roundness12),
                                  bottomRight:
                                      Radius.circular(SizeConfig.roundness12),
                                ),
                                color: Color(0xffF1F6FF),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding54),
                      FelloButtonLg(
                        child: model.isGoldBuyInProgress
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                model.getActionButtonText(),
                                style:
                                    TextStyles.body2.colour(Colors.white).bold,
                              ),
                        onPressed: () {
                          if (!model.isGoldBuyInProgress) {
                            FocusScope.of(context).unfocus();
                            model.initiateBuy();
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
