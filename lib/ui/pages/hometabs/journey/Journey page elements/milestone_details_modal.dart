import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/skip_milestone_modal.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
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

  JourneyMilestoneDetailsModalSheet(
      {@required this.milestone, @required this.status});
  @override
  State<JourneyMilestoneDetailsModalSheet> createState() =>
      _JourneyMilestoneDetailsModalSheetState();
}

class _JourneyMilestoneDetailsModalSheetState
    extends State<JourneyMilestoneDetailsModalSheet> {
  final double scaleFactor = 2.5;
  final double pageHeight = SizeConfig.screenWidth * 2.165;
  final GoldenTicketRepository _gtService = locator<GoldenTicketRepository>();
  bool _isLoading = false;
  GoldenTicket ticket;

  get isLoading => this._isLoading;

  set isLoading(value) {
    if (mounted)
      setState(() {
        this._isLoading = value;
      });
  }

  Future<void> fetchMilestoneRewards() async {
    if (widget.status != JOURNEY_MILESTONE_STATUS.COMPLETED) return;
    isLoading = true;
    final res =
        await _gtService.getGTByPrizeSubtype(widget.milestone.prizeSubType);
    if (res.isSuccess())
      ticket = res.model;
    else
      BaseUtil.showNegativeAlert(res.errorMessage, "");
    isLoading = false;
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
                            asset: widget.milestone.shadow.asset,
                            height: SizeConfig.screenWidth *
                                0.2 *
                                (widget.milestone.shadow.asset.height /
                                    widget.milestone.asset.height),
                            width: SizeConfig.screenWidth *
                                0.2 *
                                (widget.milestone.shadow.asset.width /
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
                          height: SizeConfig.screenWidth * 0.2,
                          width: SizeConfig.screenWidth * 0.2,
                        ),
                      ),
                    ),
                    if (widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                      Positioned(
                          bottom: SizeConfig.padding40,
                          left: SizeConfig.screenWidth / 2 -
                              SizeConfig.pageHorizontalMargins * 2,
                          child: MileStoneCheck())
                  ],
                ),
              ),
              Text(
                "Milestone ${widget.milestone.index}",
                style: TextStyles.sourceSansL.body3,
              ),
              SizedBox(height: SizeConfig.padding4),
              Text(
                widget.milestone.steps.first.title,
                style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.padding12),
              Text(
                widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED
                    ? "Wohoo, you completed this milestone"
                    : widget.milestone.steps.first.subtitle,
                style: TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
              ),
              SizedBox(height: SizeConfig.padding24),
              if (widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                isLoading
                    ? CircularProgressIndicator(strokeWidth: 1)
                    : ticket == null
                        ? SizedBox()
                        : (ticket.isRewarding &&
                                (ticket.redeemedTimestamp == null ||
                                    ticket.redeemedTimestamp ==
                                        TimestampModel(
                                            seconds: 0, nanoseconds: 0)))
                            ? goldenTicketWidget()
                            : rewardWidget(ticket.rewardArr),
              SizedBox(height: SizeConfig.padding24),
              widget.status == JOURNEY_MILESTONE_STATUS.COMPLETED
                  ? SizedBox()
                  : widget.status == JOURNEY_MILESTONE_STATUS.ACTIVE
                      ? Column(
                          children: [
                            AppPositiveBtn(
                                btnText: "Let's Go",
                                onPressed: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                  if (widget.milestone.index == 1)
                                    return AppState
                                            .delegate.appState.currentAction =
                                        PageAction(
                                            page: UserProfileDetailsConfig,
                                            state: PageState.addWidget,
                                            widget: UserProfileDetails(
                                                isNewUser: true));
                                  if (widget.milestone.actionUri != null &&
                                      widget.milestone.actionUri.isNotEmpty)
                                    AppState.delegate.parseRoute(
                                        Uri.parse(widget.milestone.actionUri));
                                },
                                width: SizeConfig.screenWidth),
                            if (widget.milestone.skipCost != null &&
                                widget.milestone.skipCost.isNotEmpty)
                              Container(
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: Text(
                                    "SKIP MILESTONE",
                                    style: TextStyles.sourceSansL.body3
                                        .colour(Colors.white),
                                  ),
                                  onPressed: () {
                                    AppState.screenStack
                                        .add(ScreenItem.modalsheet);
                                    log("Current Screen Stack: ${AppState.screenStack}");
                                    return showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isDismissible: true,
                                      enableDrag: false,
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (ctx) {
                                        return SkipMilestoneModalSheet(
                                            milestone: widget.milestone);
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        )
                      : SizedBox(),
              SizedBox(
                  height: SizeConfig.viewInsets.bottom +
                      (SizeConfig.padding24 - SizeConfig.viewInsets.bottom)
                          .abs())
            ]),
      ),
    );
  }

  Widget goldenTicketWidget() {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.parseRoute(Uri.parse("/myWinnings"));
            },
            child: SvgPicture.asset(
              Assets.unredemmedGoldenTicketBG,
              height: SizeConfig.padding40,
              width: SizeConfig.padding40,
            ),
          )
        ],
      ),
    );
  }

  Widget rewardWidget(List<Reward> rewards) {
    return (rewards == null || rewards.isEmpty)
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.padding24),
              Text(
                "YOU WON",
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

  getLeadingAsset(String type) {
    switch (type) {
      case 'flc':
        return Assets.token;
      case 'amt':
        return Assets.moneyIcon;
      case 'rupee':
        return Assets.moneyIcon;
      case 'gold':
        return Assets.digitalGoldBar;
    }
  }

  getSuffix(String type) {
    switch (type) {
      case 'flc':
        return " tokens";
      case 'amt':
        return "";
      case 'rupee':
        return "";
      case 'gold':
        return " worth of gold";
    }
  }

  getPrefix(String type) {
    switch (type) {
      case 'flc':
        return "";
      case 'amt':
        return "₹ ";
      case 'rupee':
        return "₹ ";
      case 'gold':
        return "₹ ";
    }
  }
}
