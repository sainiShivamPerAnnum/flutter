import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals/octfest_info_modal.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/leaderboard_sheet.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/winners_marquee.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

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
                      height: SizeConfig.screenHeight * 0.08 +
                          SizeConfig.screenWidth * 0.24),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: SizeConfig.padding20),
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigPrizeContainer(
                                bgColor: Color(0xff26A6F4),
                                bigText: locale.winMoneyBigText,
                                smallText: locale.winMoneySmallText,
                                image: Assets.moneyBag,
                                painter: LakhCustomPaint(),
                                onPressed: () => AppState
                                    .delegate.appState.setCurrentTabIndex = 1,
                              ),
                              SizedBox(width: SizeConfig.padding16),
                              BigPrizeContainer(
                                bgColor: UiConstants.tertiarySolid,
                                bigText: locale.winIphoneBigText,
                                smallText: locale.winIphoneSmallText,
                                image: Assets.iphone,
                                painter: IphoneCustomPaint(),
                                onPressed: () {
                                  model.panelController
                                      .animatePanelToPosition(1);
                                  model.setCurrentPage = 1;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding20),
                        WinnersMarqueeStrip(),
                        SizedBox(height: SizeConfig.padding24),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Text(
                            "Ongoing Events",
                            style: TextStyles.title3.bold,
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding16),
                        Container(
                          height: SizeConfig.screenWidth * 0.32,
                          width: SizeConfig.screenWidth,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: SizeConfig.pageHorizontalMargins),
                              Container(
                                width: SizeConfig.screenWidth * 0.4,
                                height: SizeConfig.screenWidth * 0.32,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding16),
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text(
                                  "Saver of the Day",
                                  style: TextStyles.body2.colour(Colors.white),
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 0.4,
                                height: SizeConfig.screenWidth * 0.32,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding16),
                                color: Colors.purple,
                                alignment: Alignment.center,
                                child: Text(
                                  "Saver of the Week",
                                  style: TextStyles.body2.colour(Colors.white),
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 0.4,
                                height: SizeConfig.screenWidth * 0.32,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.padding16),
                                color: Colors.green,
                                alignment: Alignment.center,
                                child: Text(
                                  "Saver of the Month",
                                  style: TextStyles.body2.colour(Colors.white),
                                ),
                              )
                            ],
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
                          height: SizeConfig.screenWidth * 0.24,
                          width: SizeConfig.screenWidth,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: SizeConfig.pageHorizontalMargins),
                              InkWell(
                                onTap: () => model.openVoucherModal(
                                    Assets.amazonCoupon,
                                    "Amazon Pay Gift Voucher",
                                    "",
                                    UiConstants.tertiarySolid,
                                    false, [
                                  "Redeem your game and referral winnings as an Amazon voucher sent directly to your email and mobile!"
                                ]),
                                child: RewardsAvatar(
                                  color: Color(0xff242F41),
                                  asset: Assets.amazonCoupon,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BaseUtil.openModalBottomSheet(
                                    addToScreenStack: true,
                                    content: OctFestInfoModal(),
                                    isBarrierDismissable: false,
                                    hapticVibrate: true,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            SizeConfig.padding24),
                                        topRight: Radius.circular(
                                            SizeConfig.padding24)),
                                  );
                                },
                                child: RewardsAvatar(
                                  color: Color(0xffFFC50C),
                                  asset: Assets.bdubsCoupon,
                                ),
                              ),
                              InkWell(
                                onTap: () => model.openVoucherModal(
                                  Assets.gplayCoupon,
                                  "Google Play Credits",
                                  "Coming soon",
                                  Colors.blue,
                                  true,
                                  [],
                                ),
                                child: RewardsAvatar(
                                  color: Colors.black,
                                  asset: Assets.gplayCoupon,
                                ),
                              ),
                              InkWell(
                                onTap: () => model.openVoucherModal(
                                    Assets.myntraCoupon,
                                    "Myntra Shopping Voucher",
                                    "Coming soon",
                                    Color(0xff611919),
                                    true, []),
                                child: RewardsAvatar(
                                  color: Color(0xffFFDBF6),
                                  asset: Assets.myntraCoupon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //ReferralLeaderboard(),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.24,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.09),
              child: Hero(
                tag: "myWinnigs",
                child: WinningsContainer(
                  shadow: false,
                  onTap: () => model.navigateToMyWinnings(),
                ),
              ),
            ),
            WinnersLeaderBoardSE(
              model: model,
            )
          ],
        );
      },
    );
  }
}

class RewardsAvatar extends StatelessWidget {
  final Color color;
  final String asset;

  RewardsAvatar({this.asset, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.24,
      margin: EdgeInsets.only(right: SizeConfig.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness56),
        color: color,
        image: DecorationImage(image: AssetImage(asset), fit: BoxFit.fitWidth),
      ),
    );
  }
}

class BigPrizeContainer extends StatelessWidget {
  final Color bgColor;
  final String image;
  final String smallText;
  final String bigText;
  final CustomPainter painter;
  final Function onPressed;

  BigPrizeContainer(
      {this.bgColor,
      this.bigText,
      this.image,
      this.smallText,
      this.painter,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: SizeConfig.screenWidth * 0.422,
        height: SizeConfig.screenWidth * 0.28,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: SizeConfig.screenWidth * 0.422,
                height: SizeConfig.screenWidth * 0.24,
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
                      left: 0,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.22,
                          height: SizeConfig.screenWidth * 0.18,
                          decoration: BoxDecoration(),
                          child: Opacity(
                            opacity: 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight:
                                    Radius.circular(SizeConfig.roundness32),
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
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: SizeConfig.screenWidth * 0.422,
                        height: SizeConfig.screenWidth * 0.24,
                        padding: EdgeInsets.only(
                          right: SizeConfig.padding16,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.screenWidth * 0.19),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    smallText ?? "Play and Win",
                                    style:
                                        TextStyles.body4.colour(Colors.white),
                                  ),
                                  Text(
                                    bigText ?? "₹ 1 Lakh every week",
                                    maxLines: 3,
                                    style: TextStyles.body3
                                        .colour(Colors.white)
                                        .bold,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                image ?? Assets.moneyBag,
                width: SizeConfig.screenWidth * 0.2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VoucherModal extends StatelessWidget {
  final String asset, title, subtitle;
  final bool commingSoon;
  final Color color;
  final List<String> instructions;
  const VoucherModal(
      {this.asset,
      this.commingSoon,
      this.subtitle,
      this.title,
      this.color,
      this.instructions});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding24),
          topRight: Radius.circular(SizeConfig.padding24),
        ),
        image: DecorationImage(
          image: AssetImage(
            Assets.voucherBg,
          ),
          fit: BoxFit.cover,
        ),
      ),
      height: SizeConfig.screenHeight * 0.4,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.padding24),
                topRight: Radius.circular(SizeConfig.padding24),
              ),
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins / 2,
                    top: SizeConfig.padding16,
                    bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ?? "title",
                      textAlign: TextAlign.center,
                      style: TextStyles.title3.bold
                          .colour(UiConstants.primaryColor),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        icon: Icon(
                          Icons.close,
                          size: SizeConfig.iconSize1,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Spacer(),
              Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness24),
                      boxShadow: [
                        BoxShadow(
                            color: color.withOpacity(0.16),
                            offset: Offset(20, 10),
                            blurRadius: 50,
                            spreadRadius: 10)
                      ]),
                  child:
                      Image.asset(asset, width: SizeConfig.screenWidth * 0.4)),
              SizedBox(
                  height: commingSoon
                      ? SizeConfig.padding12
                      : SizeConfig.padding20),
              commingSoon
                  ? Text(subtitle ?? "subtitle", style: TextStyles.body1)
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Column(
                        children: List.generate(
                          instructions.length,
                          (i) => referralTile(
                            instructions[i],
                          ),
                        ),
                      ),
                    ),
              Spacer(),
              SizedBox(
                height: SizeConfig.padding24,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget referralTile(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Icon(
            Icons.brightness_1,
            size: 12,
            color: UiConstants.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyles.body3,
            ),
          ),
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
