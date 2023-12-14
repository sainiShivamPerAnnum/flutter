import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/skip_milestone_modal.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum JOURNEY_MILESTONE_STATUS { COMPLETED, INCOMPLETE, ACTIVE }

class JourneyMilestoneDetailsModalSheet extends StatefulWidget {
  final MilestoneModel milestone;
  final JOURNEY_MILESTONE_STATUS status;
  final String version;

  const JourneyMilestoneDetailsModalSheet(
      {required this.milestone, required this.status, required this.version});

  @override
  State<JourneyMilestoneDetailsModalSheet> createState() =>
      _JourneyMilestoneDetailsModalSheetState();
}

class _JourneyMilestoneDetailsModalSheetState
    extends State<JourneyMilestoneDetailsModalSheet> {
  final double scaleFactor = 2.5;
  final double pageHeight = SizeConfig.screenWidth! * 2.165;
  final ScratchCardRepository _gtService = locator<ScratchCardRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  S locale = locator<S>();
  bool _isLoading = false;
  ScratchCard? ticket;

  get isLoading => _isLoading;

  set isLoading(value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    }
  }

  Future<void> fetchMilestoneRewards() async {
    if (widget.status != JOURNEY_MILESTONE_STATUS.COMPLETED) return;
    isLoading = true;
    final res =
        await _gtService.getGTByPrizeSubtype(widget.milestone.prizeSubType);
    if (res.isSuccess()) ticket = res.model;
    // else
    // BaseUtil.showNegativeAlert(res.errorMessage, "");
    isLoading = false;
  }

  String getTicketType(mlIndex) {
    for (int i = 0; i < _journeyService.levels!.length; i++) {
      if (_journeyService.levels![i].end == mlIndex) {
        return "Green Scratch";
      }
    }
    return "Scratch";
  }

  String getTicketAsset(mlIndex) {
    for (int i = 0; i < _journeyService.levels!.length; i++) {
      if (_journeyService.levels![i].end == mlIndex) {
        return Assets.levelUpUnRedeemedScratchCardBG;
      }
    }
    return Assets.unredemmedScratchCardBG;
  }

  Color getTicketColor(mlIndex) {
    for (int i = 0; i < _journeyService.levels!.length; i++) {
      if (_journeyService.levels![i].end == mlIndex) {
        return UiConstants.primaryColor;
      }
    }
    return UiConstants.tertiarySolid;
  }

  @override
  void didChangeDependencies() {
    fetchMilestoneRewards();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("Milestone details Modalsheet closed");
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness24),
                topLeft: Radius.circular(SizeConfig.roundness24)),
            color: UiConstants.gameCardColor),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins * 2),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    if (widget.milestone.shadow != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: SizeConfig.padding54,
                          alignment: Alignment.bottomCenter,
                          child: SourceAdaptiveAssetView(
                            asset: widget.milestone.shadow!.asset,
                            height: SizeConfig.screenWidth! *
                                0.2 *
                                (widget.milestone.shadow!.asset.height /
                                    widget.milestone.asset.height),
                            width: SizeConfig.screenWidth! *
                                0.2 *
                                (widget.milestone.shadow!.asset.width /
                                    widget.milestone.asset.width),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(0, -SizeConfig.padding54),
                        child: SourceAdaptiveAssetView(
                          asset: widget.milestone.asset,
                          height: SizeConfig.screenWidth! * 0.2,
                          width: SizeConfig.screenWidth! * 0.2,
                        ),
                      ),
                    ),
                    if (widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                      Positioned(
                          bottom: SizeConfig.padding40,
                          left: SizeConfig.screenWidth! / 2 -
                              SizeConfig.pageHorizontalMargins * 2,
                          child: const MileStoneCheck())
                  ],
                ),
              ),
              Text(
                locale.jMileStone(widget.milestone.index.toString()),
                style: TextStyles.sourceSansL.body3,
              ),
              SizedBox(height: SizeConfig.padding12),
              Text(
                widget.milestone.steps.first.title!,
                style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.padding4),
              widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED
                  ? Text(
                      locale.mileStoneCompleted,
                      style:
                          TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.milestone.steps.first.subtitle!,
                          style:
                              TextStyles.body3.colour(UiConstants.kTextColor3),
                        ),
                        SizedBox(height: SizeConfig.padding24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                  style: TextStyles.sourceSans.body3,
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.padding3),
                                        child: SvgPicture.asset(
                                          getTicketAsset(
                                              widget.milestone.index),
                                          height: SizeConfig.body3,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " ${locale.winATicket(getTicketType(widget.milestone.index), BaseUtil.getRandomRewardAmount(widget.milestone.index))}",
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
              if (widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                isLoading
                    ? const CircularProgressIndicator(strokeWidth: 1)
                    : ticket == null
                        ? const SizedBox()
                        : (ticket!.isRewarding! &&
                                (ticket!.redeemedTimestamp == null ||
                                    ticket!.redeemedTimestamp ==
                                        TimestampModel(
                                            seconds: 0, nanoseconds: 0)))
                            ? scratchCardWidget(ticket!.isLevelChange!)
                            : rewardWidget(ticket!.rewardArr, context),
              SizedBox(height: SizeConfig.padding24),
              widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED
                  ? const SizedBox()
                  : widget.status == JOURNEY_MILESTONE_STATUS.ACTIVE
                      ? Column(
                          children: [
                            AppPositiveBtn(
                                btnText: locale.btnLetsGo,
                                onPressed: () {
                                  AppState.backButtonDispatcher!.didPopRoute();
                                  if (widget.milestone.actionUri != null &&
                                      widget.milestone.actionUri!.isNotEmpty) {
                                    if ((widget.milestone.value ?? 0) > 0) {
                                      List<String> routes = widget
                                          .milestone.actionUri!
                                          .split('/')
                                          .toList();
                                      if (routes.contains('augBuy')) {
                                        BaseUtil().openRechargeModalSheet(
                                            amt: widget.milestone.value,
                                            investmentType:
                                                InvestmentType.AUGGOLD99);
                                      } else if (routes.contains('lboxBuy')) {
                                        BaseUtil().openRechargeModalSheet(
                                            amt: widget.milestone.value,
                                            investmentType:
                                                InvestmentType.LENDBOXP2P);
                                      } else if (routes.contains('assetBuy')) {
                                        BaseUtil.openDepositOptionsModalSheet(
                                          amount: widget.milestone.value,
                                        );
                                      } else {
                                        AppState.delegate!.parseRoute(Uri.parse(
                                            widget.milestone.actionUri!));
                                      }
                                    } else {
                                      AppState.delegate!.parseRoute(Uri.parse(
                                          widget.milestone.actionUri!));
                                    }
                                  }

                                  try {
                                    _analyticsService.track(
                                        eventName:
                                            AnalyticsEvents.journeyMileStarted,
                                        properties: AnalyticsProperties
                                            .getDefaultPropertiesMap(
                                                extraValuesMap: {
                                              "version": widget.version,
                                              "Capsule text":
                                                  AnalyticsProperties
                                                      .getJouneryCapsuleText(),
                                              "MileStone text":
                                                  AnalyticsProperties
                                                      .getJourneyMileStoneText(),
                                              "MileStone sub Text":
                                                  AnalyticsProperties
                                                      .getJourneyMileStoneSubText(),
                                              "MileStone number":
                                                  widget.milestone.index,
                                            }));
                                  } catch (e) {}
                                },
                                width: SizeConfig.screenWidth),
                            if (widget.milestone.skipCost != null &&
                                widget.milestone.skipCost!.isNotEmpty)
                              Container(
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: Text(
                                    locale.jSkipMileStone,
                                    style: TextStyles.sourceSansL.body3
                                        .colour(Colors.white),
                                  ),
                                  onPressed: () {
                                    BaseUtil.openModalBottomSheet(
                                      addToScreenStack: true,
                                      backgroundColor: Colors.transparent,
                                      isBarrierDismissible: true,
                                      enableDrag: false,
                                      content: SkipMilestoneModalSheet(
                                          milestone: widget.milestone),
                                    );
                                  },
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
              SizedBox(
                  height: SizeConfig.viewInsets.bottom +
                      (SizeConfig.padding24 - SizeConfig.viewInsets.bottom)
                          .abs())
            ]),
      ),
    );
  }

  Widget scratchCardWidget(bool isLevelChange) {
    return Container(
      margin: EdgeInsets.only(
          right: SizeConfig.padding12, top: SizeConfig.padding16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AppState.backButtonDispatcher!.didPopRoute();
              AppState.delegate!.parseRoute(Uri.parse("/myWinnings"));
            },
            child: SvgPicture.asset(
              isLevelChange
                  ? Assets.levelUpUnRedeemedScratchCardBG
                  : Assets.unredemmedScratchCardBG,
              height: SizeConfig.padding40,
              width: SizeConfig.padding40,
            ),
          )
        ],
      ),
    );
  }

  Widget rewardWidget(List<Reward>? rewards, BuildContext context) {
    S locale = S.of(context);
    return (rewards == null || rewards.isEmpty)
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.padding24),
              Text(
                locale.jWon,
                style: TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
              ),
              SizedBox(height: SizeConfig.padding4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  rewards.length,
                  (index) => Container(
                    margin: EdgeInsets.only(right: SizeConfig.padding12),
                    child: Row(
                      children: [
                        getLeadingAsset(rewards[index].type) == Assets.moneyIcon
                            ? Image.asset(
                                getLeadingAsset(rewards[index].type),
                                height: SizeConfig.padding20,
                                width: SizeConfig.padding20,
                              )
                            : SvgPicture.asset(
                                getLeadingAsset(rewards[index].type),
                                height: SizeConfig.padding20,
                                width: SizeConfig.padding20,
                              ),
                        SizedBox(width: SizeConfig.padding4),
                        Text(getPrefix(rewards[index].type),
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white60)),
                        Text(
                          rewards[index].value.toString(),
                          style: TextStyles.rajdhaniB.body1,
                        ),
                        Text(
                          getSuffix(rewards[index].type),
                          style: TextStyles.sourceSans.body3
                              .colour(Colors.white60),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  getLeadingAsset(String? type) {
    switch (type) {
      case Constants.GT_REWARD_FLC:
        return Assets.token;
      case Constants.GT_REWARD_AMT:
        return Assets.moneyIcon;
      case Constants.GT_REWARD_RUPEE:
        return Assets.moneyIcon;
      case Constants.GT_REWARD_GOLD:
        return Assets.digitalGoldBar;
      case Constants.GT_REWARD_TAMBOLA_TICKET:
        return Assets.howToPlayAsset1Tambola;
    }
  }

  getSuffix(
    String? type,
  ) {
    switch (type) {
      case Constants.GT_REWARD_FLC:
        return " ${locale.tokens.toLowerCase()}";
      case Constants.GT_REWARD_AMT:
        return "";
      case Constants.GT_REWARD_RUPEE:
        return "";
      case Constants.GT_REWARD_GOLD:
        return " ${locale.worthOfGold}";
      case Constants.GT_REWARD_TAMBOLA_TICKET:
        return " Ticket";
      default:
        return "";
    }
  }

  getPrefix(String? type) {
    switch (type) {
      case Constants.GT_REWARD_FLC:
        return "";
      case Constants.GT_REWARD_AMT:
        return "₹ ";
      case Constants.GT_REWARD_RUPEE:
        return "₹ ";
      case Constants.GT_REWARD_GOLD:
        return "₹ ";
      default:
        return "";
    }
  }
}
