import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/last_week_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/leaderBoards.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_bg.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LastWeekOverView extends StatelessWidget {
  const LastWeekOverView({
    Key? key,
    this.callCampaign = true,
    this.fromRoot = false,
  }) : super(key: key);

  final bool callCampaign;
  final bool fromRoot;

  @override
  Widget build(BuildContext context) {
    return BaseView<LastWeekViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        if (model.state == ViewState.Busy) {
          return LastWeekBg(
            showButton: false,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: const FullScreenLoader(),
            ),
          );
        }
        if (model.data == null && model.state == ViewState.Idle) {
          return LastWeekBg(
            showButton: false,
            showBackButtuon: true,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/paper_plane.svg',
                      height: SizeConfig.padding90,
                      width: SizeConfig.padding90,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      "Last week’s results will be available soon.\nCome back later!",
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return LastWeekUi(
          callCampaign: callCampaign,
          fromRoot: fromRoot,
          model: model.data!,
          lastWeekViewModel: model,
        );
      },
    );
  }
}

class LastWeekUi extends StatelessWidget {
  const LastWeekUi({
    required this.callCampaign,
    required this.fromRoot,
    required this.model,
    required this.lastWeekViewModel,
    super.key,
  });

  final LastWeekData model;
  final bool callCampaign;
  final bool fromRoot;
  final LastWeekViewModel lastWeekViewModel;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return LastWeekBg(
      callCampaign: callCampaign,
      iconUrl: model.cta?.iconUrl,
      title: model.cta?.text,
      isTopSaver: model.isTopSaver,
      model: model,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: fromRoot
                  ? SizeConfig.fToolBarHeight
                  : SizeConfig.fToolBarHeight / 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.backButtonDispatcher!.didPopRoute();
                      if (callCampaign) {
                        locator<MarketingEventHandlerService>().getCampaigns();
                      }

                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.lastWeekCrossButton,
                          properties: {
                            "Last week deposited": model.user?.invested,
                            "last week returns": model.user?.returns,
                            "last week return Percentage":
                                model.user?.gainsPerc,
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: fromRoot ? SizeConfig.padding26 : 0),
                      child: const Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.paperPlane,
                  height: SizeConfig.padding32,
                  width: SizeConfig.padding32,
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Text(
                  locale.lastWeekFello,
                  style: TextStyles.rajdhaniSB.title3,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (model.user != null) ...[
                      MyWinningsLastWeek(
                        data: model,
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      MySavingsLastWeek(
                        data: model,
                      ),
                    ],
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    Center(
                      child: Text(
                        locale.lastWeekleaderBoard,
                        style: TextStyles.rajdhaniSB.body0,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding4,
                    ),
                    LeaderBoards(
                        winners: lastWeekViewModel.pastWeekWinners ?? [],
                        showMyRankings: false,
                        backgroundTransparent: true,
                        showSeeAllButton: true),
                    SizedBox(
                      height: SizeConfig.navBarHeight * 1.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInvestmentWidget extends StatelessWidget {
  const UserInvestmentWidget({
    required this.data,
    super.key,
  });

  final UserLastWeekData data;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
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
                DefaultAvatar(
                  size: Size(SizeConfig.padding38, SizeConfig.padding38),
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Text(
                  locale.savingsMade,
                  style: TextStyles.sourceSans.body3
                      .colour(const Color(0xffFFD979)),
                ),
                Text(
                  '₹${data.invested}',
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
                      'Returns\nGained',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextFieldTextColor),
                    ),
                    Text(
                      '₹${BaseUtil.digitPrecision(data.returns!)}',
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
                      '${(data.gainsPerc! * 100).toStringAsFixed(2)}%',
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

class MyWinningsLastWeek extends StatelessWidget {
  const MyWinningsLastWeek({required this.data, super.key});
  final LastWeekData data;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Column(
      children: [
        Container(
          width: SizeConfig.screenWidth!,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding16, horizontal: SizeConfig.padding20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff919193)),
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Column(children: [
            SvgPicture.asset(
              Assets.trophyWonSvg,
              height: SizeConfig.padding64,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Text(
              locale.btnCongratulations,
              style:
                  TextStyles.sourceSansSB.body2.colour(UiConstants.kTextColor),
            ),
            Text(
              locale.ticketsThisWeek,
              style: TextStyles.sourceSans.body4.colour(UiConstants.textGray70),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.ticketsMatched,
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.textGray70)),
                    Text(data.user!.matchedTickets.toString() ?? '',
                        style: TextStyles.rajdhaniSB.title5
                            .colour(UiConstants.kTextColor))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(locale.rewardsWon,
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.textGray70)),
                    Text('₹${data.user!.rewardsWon}',
                        style: TextStyles.rajdhaniSB.title5
                            .colour(UiConstants.kTextColor))
                  ],
                )
              ],
            )
          ]),
        ),
      ],
    );
  }
}

class MySavingsLastWeek extends StatelessWidget {
  const MySavingsLastWeek({required this.data, super.key});
  final LastWeekData data;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Row(
      children: [
        Expanded(
          child: ReturnsContainer(
            title: locale.totalReturnGained,
            value: '₹${(data.user!.returns ?? 0).toStringAsFixed(2)}',
          ),
        ),
        SizedBox(
          width: SizeConfig.padding10,
        ),
        Expanded(
          child: ReturnsContainer(
            title: locale.totalPercentage,
            value: '${data.user!.gainsPerc}%',
          ),
        ),
      ],
    );
  }
}

class TotalInvestmentWidget extends StatelessWidget {
  const TotalInvestmentWidget({
    required this.data,
    super.key,
  });

  final LastWeekData data;

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
              SvgPicture.network(
                Assets.goldCoinIcon,
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
                BaseUtil.formatIndianRupees(data.main!.investments!.auggold99! +
                    data.main!.investments!.lendboxp2P!),
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
                BaseUtil.formatIndianRupees(data.main!.returns!.auggold99! +
                    data.main!.returns!.lendboxp2P!),
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
                AssetContainer(
                    icon: 'assets/svg/digitalgold.svg',
                    title: 'Digital Gold',
                    value: BaseUtil.formatIndianRupees(
                        data.main!.investments!.auggold99!)),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                AssetContainer(
                    icon: 'assets/svg/fello_flo.svg',
                    title: 'Fello Flo',
                    value: BaseUtil.formatIndianRupees(
                        data.main!.investments!.lendboxp2P!)),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                AssetContainer(
                    icon: 'assets/svg/tambola_card_asset.svg',
                    title: 'Ticket Rewards',
                    value: BaseUtil.formatIndianRupees(
                        data.main!.tambolaPrizeAmt!.toDouble()))
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
      {required this.title,
      required this.value,
      required this.icon,
      required this.subTitle,
      required this.backgroundColor,
      Key? key})
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
          vertical: SizeConfig.padding16, horizontal: SizeConfig.padding8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        children: [
          SvgPicture.network(
            icon,
            width: SizeConfig.padding54,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            // width: SizeConfig.screenWidth! * 0.40,
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
          // const Spacer(),
          Text(value, style: TextStyles.rajdhaniSB.body0),
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
      {required this.icon, required this.title, required this.value, Key? key})
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
              Text(
                title,
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.8)),
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

class ReturnsContainer extends StatelessWidget {
  const ReturnsContainer({required this.title, required this.value, super.key});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding14, horizontal: SizeConfig.padding12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff919193)),
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: SizeConfig.padding100,
              child: Text(title,
                  maxLines: 2,
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.textGray70)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyles.rajdhaniSB.body1
                      .colour(UiConstants.kTextColor)),
            )
          ]),
    );
  }
}
