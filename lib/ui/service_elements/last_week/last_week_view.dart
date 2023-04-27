import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_bg.dart';
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
                        child: const Icon(
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
                  height: SizeConfig.padding24,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const TotalInvestmentWidget(),
                        SizedBox(
                          height: SizeConfig.padding40,
                        ),
                        Center(
                          child: Text(
                            'Ajay’s Weekly Report',
                            style: TextStyles.rajdhaniSB.title5,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        const UserInvestmentWidget(),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        const WeekReportRowView(
                          title: 'Congratulations!',
                          subTitle: 'Your Tambola ticket won corners',
                          value: '₹2000',
                          icon: 'assets/svg/tambola_card_asset.svg',
                          backgroundColor: Color(0xff11444F),
                        ),
                        SizedBox(
                          height: SizeConfig.padding12,
                        ),
                        const WeekReportRowView(
                          title: 'Happy Hour',
                          subTitle: 'You got FREE Tambola Tickets',
                          value: '2/5',
                          icon: 'assets/svg/gift_icon.svg',
                          backgroundColor: Color(0xff975B4D),
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
          ],
        ),
      ),
    );
  }
}

class UserInvestmentWidget extends StatelessWidget {
  const UserInvestmentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding16 + SizeConfig.padding1,
                horizontal: SizeConfig.padding20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff919193)),
              color: Colors.black.withOpacity(0.50),
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
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
                  size: Size(SizeConfig.padding38, SizeConfig.padding38),
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
                  border: Border.all(color: const Color(0xff919193)),
                  color: Colors.black.withOpacity(0.50),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You missed\nout on',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextFieldTextColor),
                    ),
                    Text(
                      '₹340',
                      style: TextStyles.rajdhaniSB.body1,
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
                  border: Border.all(color: const Color(0xff919193)),
                  color: Colors.black.withOpacity(0.50),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Interest\nPercentage',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextFieldTextColor),
                    ),
                    Text(
                      '11.2%',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class TotalInvestmentWidget extends StatelessWidget {
  const TotalInvestmentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth! * 0.389,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding14, horizontal: SizeConfig.padding20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff919193)),
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding8,
              ),
              SvgPicture.asset(
                'assets/svg/gold_icon.svg',
                height: SizeConfig.padding54,
                // width: SizeConfig.padding80,
              ),
              Text(
                'Total Investments',
                style:
                    TextStyles.sourceSans.body3.colour(const Color(0xffFFD979)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                '₹10,23,450',
                style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Text(
                'Total Returns',
                style:
                    TextStyles.sourceSans.body3.colour(const Color(0xff62E3C4)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                '₹1,02,350',
                style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.padding10,
        ),
        Expanded(
          child: SizedBox(
            child: Column(
              children: [
                const AssetContainer(
                  icon: 'assets/svg/digitalgold.svg',
                  title: 'Digital Gold',
                  value: '₹10,23,450',
                ),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                const AssetContainer(
                  icon: 'assets/svg/fello_flo.svg',
                  title: 'Fello Flo',
                  value: '₹10,23,450',
                ),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                const AssetContainer(
                  icon: 'assets/svg/tambola_card_asset.svg',
                  title: 'Tambola prizes',
                  value: '₹10,000',
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WeekReportRowView extends StatelessWidget {
  const WeekReportRowView(
      {Key? key,
      required this.title,
      required this.value,
      required this.icon,
      required this.subTitle,
      required this.backgroundColor})
      : super(key: key);

  final String title;
  final String subTitle;
  final String value;
  final String icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding12, horizontal: SizeConfig.padding8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: SizeConfig.padding64,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.rajdhaniSB.body2,
                ),
                Text(subTitle, style: TextStyles.sourceSans.body3),
              ],
            ),
          ),
          const Spacer(),
          Text(value, style: TextStyles.rajdhaniSB.title4),
          SizedBox(
            width: SizeConfig.padding8,
          )
        ],
      ),
    );
  }
}

class AssetContainer extends StatelessWidget {
  const AssetContainer(
      {Key? key, required this.icon, required this.title, required this.value})
      : super(key: key);

  final String icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding8, horizontal: SizeConfig.padding14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff919193)),
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                height: SizeConfig.padding28,
              ),
              // SizedBox(
              //   height: SizeConfig.padding4,
              // ),
              Text(
                title,
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            value,
            style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}