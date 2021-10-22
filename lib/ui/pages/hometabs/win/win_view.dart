import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/texts/marquee_text.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/user_winnings.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/win_leaderboard.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<WinViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Stack(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                      height:
                          SizeConfig.screenWidth * 0.3 + SizeConfig.padding40),
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: SizeConfig.padding54),
                        Container(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: SizeConfig.pageHorizontalMargins),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigPrizeContainer(
                                bgColor: Color(0xff26A6F4),
                                bigText: locale.winMoneyBigText,
                                smallText: locale.winMoneySmallText,
                                image: Assets.moneyBag,
                                painter: LakhCustomPaint(),
                              ),
                              SizedBox(width: SizeConfig.padding16),
                              BigPrizeContainer(
                                bgColor: UiConstants.tertiarySolid,
                                bigText: locale.winIphoneBigText,
                                smallText: locale.winIphoneSmallText,
                                image: Assets.iphone,
                                painter: IphoneCustomPaint(),
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
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness32),
                                  image: DecorationImage(
                                      image: AssetImage(Assets.amazonGC),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height: SizeConfig.screenWidth * 0.309,
                                width: SizeConfig.screenWidth * 0.405,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness32),
                                  image: DecorationImage(
                                      image: AssetImage(Assets.myntraGV),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height: SizeConfig.screenWidth * 0.309,
                                width: SizeConfig.screenWidth * 0.405,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness32),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConfig.padding80),
              child: InkWell(
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
                          UserWinningsSE(
                            style: TextStyles.title1
                                .colour(Colors.white)
                                .weight(FontWeight.w900)
                                .letterSpace(2),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            WinnersLeaderBoardSE()
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
  final CustomPainter painter;

  BigPrizeContainer(
      {this.bgColor, this.bigText, this.image, this.smallText, this.painter});

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
                            // color: Colors.white.withOpacity(0.3),
                            // borderRadius: BorderRadius.only(
                            //   topRight: Radius.circular(SizeConfig.roundness32),
                            //   bottomLeft: Radius.circular(SizeConfig.roundness56),
                            // ),
                            ),
                        child: Opacity(
                          opacity: 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(SizeConfig.roundness32),
                            ),
                            child: CustomPaint(
                              size: Size(
                                  SizeConfig.screenWidth * 0.3,
                                  (SizeConfig.screenWidth *
                                          0.3 *
                                          0.676923076923077)
                                      .toDouble()),
                              painter: painter,
                            ),
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

//Copy this CustomPainter code to the Bottom of the File
class LakhCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.184615, size.height * 0.2691261);
    path_0.cubicTo(
        size.width * 1.184615,
        size.height * 0.7285773,
        size.width * 1.156438,
        size.height * 1.052747,
        size.width * 0.6349246,
        size.height * 0.9553091);
    path_0.cubicTo(
        size.width * 0.5865785,
        size.height * 0.9462761,
        size.width * 0.5367577,
        size.height * 0.9483352,
        size.width * 0.4888669,
        size.height * 0.9616466);
    path_0.cubicTo(
        size.width * -0.07392585,
        size.height * 1.118072,
        size.width * 0.007692154,
        size.height * 0.7302920,
        size.width * 0.007692154,
        size.height * 0.2691261);
    path_0.cubicTo(
        size.width * 0.007692154,
        size.height * -0.2109852,
        size.width * 0.2711554,
        size.height * -0.6001920,
        size.width * 0.5961538,
        size.height * -0.6001920);
    path_0.cubicTo(
        size.width * 0.9211538,
        size.height * -0.6001920,
        size.width * 1.184615,
        size.height * -0.2109852,
        size.width * 1.184615,
        size.height * 0.2691261);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class IphoneCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.179104, size.height * 0.1723363);
    path_0.cubicTo(
        size.width * 1.179104,
        size.height * 0.5976011,
        size.width * 1.288672,
        size.height * 1.119681,
        size.width * 0.7680075,
        size.height * 0.9679692);
    path_0.cubicTo(
        size.width * 0.6618127,
        size.height * 0.9370264,
        size.width * 0.5524649,
        size.height * 0.9220132,
        size.width * 0.4449075,
        size.height * 0.9400901);
    path_0.cubicTo(
        size.width * -0.3325672,
        size.height * 1.070758,
        size.width * 0.1492530,
        size.height * 0.6584198,
        size.width * 0.1492530,
        size.height * 0.2217868);
    path_0.cubicTo(
        size.width * 0.1492530,
        size.height * -0.2424967,
        size.width * 0.2929104,
        size.height * -0.6683231,
        size.width * 0.6082075,
        size.height * -0.6683231);
    path_0.cubicTo(
        size.width * 0.9235075,
        size.height * -0.6683231,
        size.width * 1.179104,
        size.height * -0.2919473,
        size.width * 1.179104,
        size.height * 0.1723363);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WinnerboardView extends StatelessWidget {
  final WinnersModel model;
  final ScrollController controller;
  WinnerboardView({this.model, this.controller});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding80),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding8,
            ),
            child: Row(
              children: [
                Text(
                  "Last updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.timestamp.toDate())}",
                  style: TextStyles.body4.colour(Colors.grey),
                )
              ],
            ),
          ),
          Column(
              // controller: controller,
              // shrinkWrap: true,
              // itemCount: model.winners.length,
              children: List.generate(
            //50,
            model.winners.length,
            (i) {
              return Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.all(SizeConfig.padding12),
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding8,
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: UiConstants.primaryColor,
                      radius: SizeConfig.padding16,
                      child: Text(
                        "${i + 1}",
                        style: TextStyles.body4.colour(Colors.white),
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              //"avc",
                              model.winners[i].username ?? "Username",
                              style: TextStyles.body3),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            model.gametype == "GM_CRIC2020"
                                ? "Circket"
                                : "Tambola",
                            style: TextStyles.body4
                                .colour(UiConstants.primaryColor),
                          )
                        ],
                      ),
                    ),
                    TextButton.icon(
                        icon: CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor: UiConstants.tertiaryLight,
                          child: SvgPicture.asset(Assets.tickets,
                              height: SizeConfig.iconSize3),
                        ),
                        label: Text(
                            //"00",
                            model.winners[i].score.toString() ?? "00",
                            style: TextStyles.body3.colour(Colors.black54)),
                        onPressed: () {}),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
