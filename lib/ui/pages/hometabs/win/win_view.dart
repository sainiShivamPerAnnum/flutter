import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/leaderboard_sheet.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/winners_marquee.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../core/base_remote_config.dart';
import '../../../../core/enums/user_service_enum.dart';
import '../../../../core/service/notifier_services/user_service.dart';
import '../../../service_elements/user_service/profile_image.dart';
import '../../../widgets/coin_bar/coin_bar_view.dart';
import 'customPainters.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<WinViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) {
        String minWithdrawPrize = BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.MIN_WITHDRAWABLE_PRIZE);
        String refUnlock = BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT);
        int refUnlockAmt = BaseUtil.toInt(refUnlock);
        int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);

        return PropertyChangeConsumer<UserService, UserServiceProperties>(
            properties: [UserServiceProperties.myUserFund],
            builder: (context, m, property) {
              double currentWinning = m.userFundWallet.unclaimedBalance;
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    "Win",
                    style: TextStyles.rajdhaniSB.title1,
                  ),
                  elevation: 0,
                  backgroundColor: UiConstants.kSecondaryBackgroundColor,
                  actions: [
                    FelloCoinBar(svgAsset: Assets.aFelloToken),
                    SizedBox(width: SizeConfig.padding10),
                    GestureDetector(
                      onTap: () {
                        model.openProfile();
                      },
                      child: ProfileImageSE(radius: SizeConfig.avatarRadius),
                    ),
                    SizedBox(width: SizeConfig.padding20)
                  ],
                ),
                body: Container(
                  width: double.infinity,

                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        //Current Winnings section
                        Container(
                          decoration: BoxDecoration(
                            color: UiConstants.kSecondaryBackgroundColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(SizeConfig.roundness12),
                              bottomRight:
                                  Radius.circular(SizeConfig.roundness12),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(
                              SizeConfig.padding24,
                              SizeConfig.padding44,
                              SizeConfig.padding24,
                              SizeConfig.padding32),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Winnings',
                                        style: TextStyles.rajdhaniSB.copyWith(
                                            fontSize: SizeConfig.body0),
                                      ),
                                      Text(
                                        '₹ ${m.userFundWallet.unclaimedBalance.toString() ?? '-'}',
                                        style: TextStyles.title1.extraBold
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding40,
                                      ),
                                      m.userFundWallet.unclaimedBalance >=
                                              minWithdrawPrizeAmt
                                          ? AppPositiveBtn(
                                              btnText: "Redeem",
                                              onPressed: () {},
                                              width:
                                                  SizeConfig.screenWidth * 0.4)
                                          : Text(
                                              'Rewards can be\nredeemed at Rs. $minWithdrawPrizeAmt',
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor2),
                                            ),
                                    ],
                                  ),
                                  Consumer<AppState>(
                                    builder: (ctx, m, child) =>
                                        WinningsCylinder(
                                      index: AppState
                                          .delegate.appState.getCurrentTabIndex,
                                      currentWinning: currentWinning,
                                      model: model,
                                      redeemAmount: minWithdrawPrizeAmt,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding54,
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 0.3,
                              ),
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                              TextButton(
                                onPressed: () {
                                  AppState.delegate.appState.currentAction =
                                      PageAction(
                                    page: CampaignViewPageConfig,
                                    state: PageState.addWidget,
                                    widget: MyWinningsView(),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            Assets.unredemmedGoldenTicketBG,
                                            height: SizeConfig.padding38),
                                        SizedBox(
                                          width: SizeConfig.padding8,
                                        ),
                                        Text(
                                          'Golden Tickets',
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '3 NEW',
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.white),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding54,
                        ),
                        //Refer and Earn
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  SizeConfig.padding24,
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    SizeConfig.padding24,
                                    SizeConfig.padding44,
                                    SizeConfig.padding24,
                                    0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xff1A1A1A),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            SizeConfig.roundness12))),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            AppState.delegate.appState
                                                .currentAction = PageAction(
                                              page: CampaignViewPageConfig,
                                              state: PageState.addWidget,
                                              widget: ReferralDetailsView(),
                                            );
                                          },
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: SizeConfig.padding20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding28,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Earn upto Rs.50 and',
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor3)),
                                          WidgetSpan(
                                              child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.padding4),
                                            height: 17,
                                            width: 17,
                                            child: SvgPicture.asset(
                                              Assets.aFelloToken,
                                            ),
                                          )),
                                          TextSpan(
                                              text:
                                                  '200 from every Golden Ticket. Win an iPad every month.',
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor3)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding28,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.padding32,
                                              vertical: SizeConfig.padding6),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.roundness8),
                                              ),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 0.6)),
                                          child: Text(
                                            model.loadingRefCode
                                                ? '-'
                                                : model.refCode,
                                            style: TextStyles.title2.extraBold
                                                .colour(Colors.white),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  model.copyReferCode();
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color: UiConstants
                                                      .kTabBorderColor,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  model.shareWhatsApp();
                                                },
                                                icon: Icon(
                                                  Icons.share,
                                                  color: UiConstants
                                                      .kTabBorderColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: SizeConfig.padding44),
                                child: SvgPicture.asset(Assets.referAndEarn,
                                    height: SizeConfig.padding90),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // : Stack(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.only(top: SizeConfig.padding20),
                  //         child: ListView(
                  //           padding:
                  //               EdgeInsets.only(top: SizeConfig.screenWidth * 0.24),
                  //           children: [
                  //             Container(
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   BigPrizeContainer(
                  //                     bgColor: Color(0xff26A6F4),
                  //                     bigText: locale.winMoneyBigText,
                  //                     smallText: locale.winMoneySmallText,
                  //                     image: Assets.moneyBag,
                  //                     painter: LakhCustomPaint(),
                  //                     onPressed: () => AppState
                  //                         .delegate.appState.setCurrentTabIndex = 1,
                  //                   ),
                  //                   SizedBox(width: SizeConfig.padding16),
                  //                   BigPrizeContainer(
                  //                     bgColor: UiConstants.tertiarySolid,
                  //                     bigText: locale.winIphoneBigText,
                  //                     smallText: locale.winIphoneSmallText,
                  //                     image: Assets.iphone,
                  //                     painter: IphoneCustomPaint(),
                  //                     onPressed: () {
                  //                       // model.panelController.animatePanelToPosition(1);
                  //                       // model.setCurrentPage = 1;
                  //                       AppState.delegate.appState.currentAction =
                  //                           PageAction(
                  //                         page: ReferralDetailsPageConfig,
                  //                         state: PageState.addPage,
                  //                       );
                  //                     },
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(height: SizeConfig.padding32),
                  //             WinnersMarqueeStrip(),
                  //             SizedBox(height: SizeConfig.padding20),
                  //             if (model.ongoingEvents != null)
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Padding(
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal:
                  //                             SizeConfig.pageHorizontalMargins),
                  //                     child: Text(
                  //                       "Ongoing Campaigns",
                  //                       style: TextStyles.title3.bold,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: SizeConfig.padding16),
                  //                   Container(
                  //                     height: SizeConfig.screenWidth * 0.3,
                  //                     width: SizeConfig.screenWidth,
                  //                     child: ListView(
                  //                       padding: EdgeInsets.zero,
                  //                       scrollDirection: Axis.horizontal,
                  //                       controller: model.eventScrollController,
                  //                       children: List.generate(
                  //                         model.ongoingEvents.length,
                  //                         (i) => Container(
                  //                           margin: EdgeInsets.only(
                  //                               left: i == 0
                  //                                   ? SizeConfig
                  //                                       .pageHorizontalMargins
                  //                                   : 0),
                  //                           child: EventCard(
                  //                             event: model.ongoingEvents[i],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: SizeConfig.padding24),
                  //                 ],
                  //               ),
                  //             SizedBox(
                  //               height: SizeConfig.screenHeight * 0.24,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         //margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.09),
                  //         child: Hero(
                  //           tag: "myWinnigs",
                  //           child: WinningsContainer(
                  //             shadow: false,
                  //             onTap: () => model.navigateToMyWinnings(),
                  //           ),
                  //         ),
                  //       ),
                  //       WinnersLeaderBoardSE(
                  //         model: model,
                  //       )
                  //     ],
                  //   ),
                ),
              );
            });
      },
    );
  }
}

class WinningsCylinder extends StatefulWidget {
  const WinningsCylinder({
    Key key,
    @required this.index,
    @required this.currentWinning,
    @required this.model,
    @required this.redeemAmount,
  }) : super(key: key);

  final int index;
  final double currentWinning;
  final WinViewModel model;
  final int redeemAmount;

  @override
  State<WinningsCylinder> createState() => _WinningsCylinder();
}

double containerHeight = SizeConfig.screenWidth * 0.4;
double containerWidth = SizeConfig.screenWidth * 0.3;

double containerFilledHeight = 0;

class _WinningsCylinder extends State<WinningsCylinder> {
  @override
  void initState() {
    containerFilledHeight = 0;

    super.initState();
  }

  @override
  void dispose() {
    containerFilledHeight = 0;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 3) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (containerFilledHeight == 0) {
          setState(() {
            if (widget.currentWinning >= widget.redeemAmount) {
              containerFilledHeight = containerHeight;
            } else {
              containerFilledHeight = widget.model.calculateFillHeight(
                  widget.currentWinning, containerHeight, widget.redeemAmount);
            }
          });
        }
      });
    }
    return Center(
      child: Container(
        width: containerWidth,
        height: containerHeight,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
                child: CustomPaint(
              size: Size(SizeConfig.screenWidth * 0.15,
                  (SizeConfig.screenWidth * 0.4)),
              painter: CustomCylinderOuter(),
            )),
            AnimatedContainer(
                height: containerFilledHeight,
                duration: Duration(seconds: 1),
                curve: Curves.easeInCirc,
                margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                child: CustomPaint(
                  size: Size((SizeConfig.screenWidth * 0.15) - 8,
                      containerFilledHeight - 10),
                  painter: CustomCylinderInner(),
                )),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;

  EventCard({@required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppState.delegate.appState.currentAction = PageAction(
            state: PageState.addWidget,
            widget: TopSaverView(
              eventType: event.type,
            ),
            page: AugmontGoldSellPageConfig);
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.64,
        height: SizeConfig.screenWidth * 0.3,
        margin: EdgeInsets.only(right: SizeConfig.padding16),
        decoration: event.thumbnail.isNotEmpty
            ? BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(event.thumbnail),
                  fit: BoxFit.cover,
                ),
              )
            : BoxDecoration(
                color: Color(event.color),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
        padding: EdgeInsets.all(SizeConfig.padding16),
        child: event.thumbnail.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    event.title,
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
                  Text(
                    event.subtitle,
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withOpacity(0.5)),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding6,
                            horizontal: SizeConfig.padding12),
                        child: Text(
                          "Explore",
                          style:
                              TextStyles.body3.bold.colour(Color(event.color)),
                        ),
                      )
                    ],
                  )
                ],
              )
            : SizedBox(),
      ),
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
                    borderRadius: BorderRadius.circular(SizeConfig.roundness24),
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
                                    Radius.circular(SizeConfig.roundness24),
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
                                        TextStyles.body3.colour(Colors.white),
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
