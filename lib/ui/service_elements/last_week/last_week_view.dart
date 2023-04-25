import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_bg.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LastWeekOverView extends StatelessWidget {
  const LastWeekOverView({
    Key? key,
    // required this.model,
  }) : super(key: key);

  // final LastWeekModel model;

  @override
  Widget build(BuildContext context) {
    return LastWeekBg(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: SizeConfig.fToolBarHeight / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppState.backButtonDispatcher!.didPopRoute();
                        },
                        child: Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/paper_plane.svg',
                      height: SizeConfig.padding32,
                      width: SizeConfig.padding32,
                    ),
                    SizedBox(
                      width: SizeConfig.padding16,
                    ),
                    Text(
                      'Last Week on Fello',
                      style: TextStyles.rajdhaniSB.title3,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding32,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:
                                  SizeConfig.padding90 + SizeConfig.padding10,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding12,
                                  horizontal: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.28),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '10L+',
                                    style: TextStyles.sourceSansSB.title5,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding8,
                                  ),
                                  Text(
                                    'Investments\nfrom users',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white.withOpacity(0.5)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  SizeConfig.padding90 + SizeConfig.padding10,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding12,
                                  horizontal: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.28),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '₹50K',
                                    style: TextStyles.sourceSansSB.title5,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding8,
                                  ),
                                  Text(
                                    'rewards\ndistributed',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white.withOpacity(0.5)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  SizeConfig.padding90 + SizeConfig.padding10,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding12,
                                  horizontal: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.28),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '₹30K',
                                    style: TextStyles.sourceSansSB.title5,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding8,
                                  ),
                                  Text(
                                    'returns\nearned',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white.withOpacity(0.5)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/tambola_icon.svg',
                              height: SizeConfig.padding32,
                              width: SizeConfig.padding28,
                            ),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            Text(
                              '20 Users won Tambola Corners & One Rows',
                              style: TextStyles.sourceSans.body3
                                  .colour(const Color(0xffACACAC)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        Row(
                          children: [
                            SvgPicture.network(
                              Assets.powerPlayMain,
                              height: SizeConfig.padding32,
                              width: SizeConfig.padding32,
                            ),
                            SizedBox(
                              width: SizeConfig.padding14,
                            ),
                            Text(
                              '20 Users won Tambola Corners & One Rows',
                              style: TextStyles.sourceSans.body3
                                  .colour(const Color(0xffACACAC)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding32,
                        ),
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(
                          height: SizeConfig.padding32,
                        ),
                        Center(
                          child: Text(
                            'Ajay’s Weekly Report',
                            style: TextStyles.rajdhaniSB.title5,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding16,
                                    horizontal: SizeConfig.padding20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.50),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   height: SizeConfig.padding38,
                                    //   width: SizeConfig.padding38,
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.red.withOpacity(0.50),
                                    //       shape: BoxShape.circle),
                                    // ),
                                    DefaultAvatar(
                                      size: Size(SizeConfig.padding38,
                                          SizeConfig.padding38),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding20,
                                    ),
                                    Text(
                                      'Savings made',
                                      style: TextStyles.sourceSans.body3
                                          .colour(const Color(0xffFFD979)),
                                    ),
                                    Text(
                                      '₹0',
                                      style: TextStyles.sourceSansSB.title5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding14,
                                        horizontal: SizeConfig.padding14),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.50),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'You missed\nout on',
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants
                                                  .kTextFieldTextColor),
                                        ),
                                        Text(
                                          '₹340',
                                          style: TextStyles.rajdhaniSB.body1
                                              .colour(UiConstants
                                                  .kTextFieldTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding14,
                                        horizontal: SizeConfig.padding14),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.50),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Net Interest\nPercentage',
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants
                                                  .kTextFieldTextColor),
                                        ),
                                        Text(
                                          '11.2%',
                                          style: TextStyles.rajdhaniSB.body1
                                              .colour(UiConstants
                                                  .kTextFieldTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        const WeekReportRowView(
                          title: 'Your Tambola tickets won',
                          value: '₹2000',
                          icon: 'assets/svg/tambola_card_asset.svg',
                        ),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        const WeekReportRowView(
                          title: 'Invested in Happy Hours',
                          value: '2/5',
                          icon: 'assets/svg/gift_icon.svg',
                        ),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        const WeekReportRowView(
                          title: 'PowerPlay Predictions Made',
                          value: '5',
                          icon: Assets.powerPlayMain,
                          isNetwork: true,
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding12,
                              horizontal: SizeConfig.padding16),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/trophy_banner.svg',
                                height: SizeConfig.padding38,
                              ),
                              SizedBox(
                                width: SizeConfig.padding20,
                              ),
                              Flexible(
                                child: Text(
                                  'Congratulations!\nYou were in the top 10 Percentile Investors on Fello',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextFieldTextColor),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.navBarHeight * 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: SizeConfig.navBarHeight * 0.8,
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.1, 1],
                      colors: [
                        UiConstants.kBuyTicketSaveButton,
                        UiConstants.kBuyTicketSaveButton.withOpacity(0.4),
                      ],
                    ),
                    // color: UiConstants.kBuyTicketSaveButton,
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  // color:  UiConstants.kBuyTicketSaveButton,
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'START SAVING NOW',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekReportRowView extends StatelessWidget {
  const WeekReportRowView({Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.isNetwork = false})
      : super(key: key);

  final String title;
  final String value;
  final String icon;
  final bool isNetwork;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: SizeConfig.padding70,
          child: isNetwork
              ? SvgPicture.network(
            icon,
            height: SizeConfig.padding32,
            // width: SizeConfig.padding32,
          )
              : SvgPicture.asset(
            icon,
            height: SizeConfig.padding32,
          ),
        ),
        Text(
          title,
          style: TextStyles.sourceSans.body3
              .colour(UiConstants.kTextFieldTextColor),
        ),
        const Spacer(),
        Text(value.toString(), style: TextStyles.rajdhaniSB.body2),
      ],
    );
  }
}
