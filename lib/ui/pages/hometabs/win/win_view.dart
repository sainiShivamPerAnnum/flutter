import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/ui/elements/texts/marquee_text.dart';
import 'package:felloapp/ui/elements/week-winners_board.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<WinViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Stack(
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: SizeConfig.padding24),
                  InkWell(
                    onTap: model.navigateToMyWinnings,
                    child: Hero(
                      tag: "myWinnigs",
                      child: WinningsContainer(
                        shadow: false,
                        child: Container(
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(SizeConfig.padding16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.winMyWinnings,
                                style: TextStyles.title5.colour(Colors.white60),
                              ),
                              SizedBox(height: SizeConfig.padding8),
                              Text(
                                locale.saveWinningsValue(1000),
                                style: TextStyles.title1
                                    .colour(Colors.white)
                                    .weight(FontWeight.w900)
                                    .letterSpace(2),
                              )
                            ],
                          ),
                        ),
                        color: Color(0xff11192B),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Container(
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: SizeConfig.pageHorizontalMargins),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BigPrizeContainer(
                          bgColor: UiConstants.primaryColor,
                          bigText: locale.winMoneyBigText,
                          smallText: locale.winMoneySmallText,
                          image: Assets.moneyBag,
                        ),
                        //SizedBox(width: SizeConfig.padding16),
                        BigPrizeContainer(
                          bgColor: UiConstants.tertiarySolid,
                          bigText: locale.winIphoneBigText,
                          smallText: locale.winIphoneSmallText,
                          image: Assets.iphone,
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
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                      color: UiConstants.tertiaryLight.withOpacity(0.5),
                    ),
                    child: MarqueeText(
                      infoList: [
                        "Shourya won ₹ 1000",
                        "Manish won ₹ 2000",
                        "Shreeyash won ₹ 1200"
                      ],
                      showBullet: true,
                      bulletColor: UiConstants.tertiarySolid,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Text(
                      "Rewards and Coupons",
                      style: TextStyles.title3.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Container(
                    height: SizeConfig.screenWidth * 0.309,
                    width: SizeConfig.screenWidth,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: SizeConfig.pageHorizontalMargins),
                        Container(
                          height: SizeConfig.screenWidth * 0.309,
                          width: SizeConfig.screenWidth * 0.405,
                          margin: EdgeInsets.only(right: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            image: DecorationImage(
                                image: AssetImage(Assets.amazonGC),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          height: SizeConfig.screenWidth * 0.309,
                          width: SizeConfig.screenWidth * 0.405,
                          margin: EdgeInsets.only(right: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            image: DecorationImage(
                                image: AssetImage(Assets.myntraGV),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          height: SizeConfig.screenWidth * 0.309,
                          width: SizeConfig.screenWidth * 0.405,
                          margin: EdgeInsets.only(right: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            image: DecorationImage(
                                image: AssetImage(Assets.amazonGC),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.4,
                  )
                  // Container(
                  //   height: SizeConfig.screenHeight,
                  //   child: Column(
                  //     children: [WeekWinnerBoard(), Leaderboard()],
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 1,
                minChildSize: 0.4,
                builder: (BuildContext context, myscrollController) {
                  return Stack(
                    children: [
                      Positioned(
                        top: -SizeConfig.screenHeight * 0.19,
                        child: Container(
                          height: SizeConfig.screenHeight * 2,
                          // color: Colors.red,
                          width: SizeConfig.screenWidth,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: SizeConfig.screenWidth,
                                  child: CustomPaint(
                                    painter: ModalCustomBackground(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenWidth * 0.12,
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Text(
                            "Leaderboard",
                            style: TextStyles.title3.bold,
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.white,

                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                                vertical: SizeConfig.pageHorizontalMargins * 4),
                            controller: myscrollController,
                            itemCount: 40,
                            itemBuilder: (ctx, i) {
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      UiConstants.primaryLight.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness24),
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding4,
                                ),
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.all(SizeConfig.padding12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth * 0.154,
                                      height: SizeConfig.tileAvatarRadius * 2,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5b3a90cba7ea4353dd3f9804%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D186%26cropX2%3D3092%26cropY1%3D449%26cropY2%3D3354",
                                              ),
                                              radius:
                                                  SizeConfig.tileAvatarRadius,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  UiConstants.primaryColor,
                                              radius: SizeConfig.padding16,
                                              child: Text(
                                                "${i + 1}",
                                                style: TextStyles.body4
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Mckinney",
                                              style: TextStyles.body3),
                                          SizedBox(height: SizeConfig.padding4),
                                          Text(
                                            "Tambola",
                                            style: TextStyles.body4.colour(
                                                UiConstants.primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                        icon: CircleAvatar(
                                          radius:
                                              SizeConfig.screenWidth * 0.029,
                                          backgroundColor:
                                              UiConstants.primaryLight,
                                          child: Image.asset(
                                            "assets/images/icons/money.png",
                                            height: SizeConfig.iconSize3,
                                          ),
                                        ),
                                        label: Text("Rs 10K",
                                            style: TextStyles.body3
                                                .colour(Colors.black54)),
                                        onPressed: () {}),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class BigPrizeContainer extends StatelessWidget {
  final Color bgColor;
  final String image;
  final String smallText;
  final String bigText;

  BigPrizeContainer({this.bgColor, this.bigText, this.image, this.smallText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.422,
      height: SizeConfig.screenWidth * 0.520,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
                width: SizeConfig.screenWidth * 0.422,
                height: SizeConfig.screenWidth * 0.422,
                decoration: BoxDecoration(
                    color: bgColor ?? UiConstants.primaryColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: bgColor != null
                            ? bgColor.withOpacity(0.16)
                            : UiConstants.primaryColor.withOpacity(0.16),
                        offset: Offset(
                          0,
                          SizeConfig.screenWidth * 0.1,
                        ),
                        spreadRadius: 10,
                      )
                    ]),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: SizeConfig.screenWidth * 0.3,
                        height: SizeConfig.screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness32),
                            bottomLeft: Radius.circular(SizeConfig.roundness56),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: SizeConfig.screenWidth * 0.422,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding16,
                            vertical: SizeConfig.padding24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              smallText ?? "Play and Win",
                              style: TextStyles.body4.colour(Colors.white),
                            ),
                            Text(
                              bigText ?? "Rs. 1 Lakh every week",
                              style: TextStyles.body1.colour(Colors.white).bold,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              image ?? Assets.moneyBag,
              width: SizeConfig.screenWidth * 0.28,
            ),
          )
        ],
      ),
    );
  }
}


 // Card(
              //   margin: EdgeInsets.symmetric(vertical: 20),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text("My winnings", style: TextStyles.body3.light),
              //             PropertyChangeConsumer<UserService,
              //                 UserServiceProperties>(
              //               builder: (ctx, model, child) => Text(
              //                 //"₹ 0.00",
              //                 "₹ ${model.userFundWallet.unclaimedBalance}",
              //                 style: TextStyles.body2.bold
              //                     .colour(UiConstants.primaryColor),
              //               ),
              //             ),
              //           ],
              //         ),
              //         // SizedBox(height: 12),
              //         // Widgets().getBodyBold("Redeem for", Colors.black),
              //         SizedBox(height: 12),
              //         if (model.getUnclaimedPrizeBalance > 0)
              //           PropertyChangeConsumer<UserService,
              //               UserServiceProperties>(
              //             builder: (ctx, m, child) => FelloButton(
              //               defaultButtonText:
              //                   m.userFundWallet.isPrizeBalanceUnclaimed()
              //                       ? "Redeem"
              //                       : "Share",
              //               onPressedAsync: () =>
              //                   model.prizeBalanceAction(context),
              //               defaultButtonColor: Colors.orange,
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // ),
