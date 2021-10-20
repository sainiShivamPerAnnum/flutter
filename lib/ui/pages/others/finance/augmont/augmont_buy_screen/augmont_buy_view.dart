import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AugmontGoldBuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          whiteBackground: WhiteBackground(
              color: Color(0xffF1F6FF), height: kToolbarHeight * 2.7),
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.abBuyDigitalGold,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.padding24,
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
                        icon: SvgPicture.asset(Assets.gold24K,
                            width: SizeConfig.padding24),
                        label: Text(locale.saveGold24k,
                            style: TextStyles.body3.colour(Colors.white)),
                        onPressed: () {}),
                    TextButton.icon(
                      icon: SvgPicture.asset(Assets.goldPure,
                          width: SizeConfig.padding24),
                      label: Text(locale.saveGoldPure,
                          style: TextStyles.body3.colour(Colors.white)),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                        icon: SvgPicture.asset(Assets.goldSecure,
                            width: SizeConfig.padding24),
                        label: Text(locale.saveSecure,
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
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness32),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff0B175F0D),
                          blurRadius: SizeConfig.padding12,
                          offset: Offset(0, SizeConfig.padding12),
                          spreadRadius: SizeConfig.padding20,
                        )
                      ]),
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
                            SizedBox(width: SizeConfig.padding24),
                            Expanded(
                              child: TextField(
                                controller: model.goldAmountController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.body2.bold,
                                onChanged: (val) {
                                  model.goldBuyAmount = double.tryParse(val);
                                  model.updateGoldAmount();
                                },
                                decoration: InputDecoration(
                                  prefix:
                                      Text("₹ ", style: TextStyles.body2.bold),
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
                              padding:
                                  EdgeInsets.only(left: SizeConfig.padding20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You buy",
                                    style: TextStyles.body3.colour(Colors.grey),
                                  ),
                                  SizedBox(height: SizeConfig.padding4 / 2),
                                  FittedBox(
                                    child: Text(
                                      "${model.goldAmountInGrams.toStringAsFixed(4)} gm",
                                      style: TextStyles.body2.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          model.amoutChip(model.chipAmountList[0]),
                          model.amoutChip(model.chipAmountList[1]),
                          model.amoutChip(model.chipAmountList[2]),
                          // model.amoutChip(model.chipAmountList[3]),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding54),
                      CurrentPriceWidget(
                        model: model,
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
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      Text(
                        "Buy Clicking on Buy, you agree to T&C",
                        textAlign: TextAlign.center,
                        style: TextStyles.body3.colour(Colors.grey),
                      ),
                      SizedBox(height: SizeConfig.padding40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(Assets.augLogo,
                              height: SizeConfig.padding24),
                          Image.asset(Assets.amfiGraphic,
                              color: UiConstants.primaryColor,
                              height: SizeConfig.padding24),
                          Image.asset(Assets.sebiGraphic,
                              color: Color(0xff2E2A81),
                              height: SizeConfig.padding20),
                        ],
                      ),
                      SizedBox(height: SizeConfig.viewInsets.bottom)
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

class CurrentPriceWidget extends StatefulWidget {
  final AugmontGoldBuyViewModel model;
  CurrentPriceWidget({this.model});

  @override
  _CurrentPriceWidgetState createState() => _CurrentPriceWidgetState();
}

class _CurrentPriceWidgetState extends State<CurrentPriceWidget>
    with SingleTickerProviderStateMixin {
  Animation<Duration> animation;
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(minutes: 3));
    animation = Tween<Duration>(begin: Duration(minutes: 3), end: Duration.zero)
        .animate(controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.model.fetchGoldRates();
              controller.repeat();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.246,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: UiConstants.primaryColor.withOpacity(0.1),
        border: Border.all(width: 1, color: UiConstants.primaryColor),
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Current Price",
                style: TextStyles.body1.colour(UiConstants.primaryColor),
              ),
              Spacer(),
              widget.model.isGoldRateFetching
                  ? SpinKitThreeBounce(
                      size: SizeConfig.body2,
                      color: UiConstants.primaryColor,
                    )
                  : Text(
                      "₹ ${widget.model.goldBuyPrice.toStringAsFixed(2)}",
                      style: TextStyles.body1
                          .colour(UiConstants.primaryColor)
                          .bold,
                    )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Row(
            children: [
              Text(
                "Valid for: ",
                style: TextStyles.body4.colour(UiConstants.primaryColor).light,
              ),
              Text(
                '${animation.value.inMinutes}:${animation.value.inSeconds % 60}',
                style: TextStyles.body4.colour(UiConstants.primaryColor).bold,
              )
            ],
          )
        ],
      ),
    );
  }
}
