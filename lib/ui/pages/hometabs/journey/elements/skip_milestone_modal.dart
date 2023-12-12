import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class SkipMilestoneModalSheet extends StatefulWidget {
  final MilestoneModel? milestone;
  const SkipMilestoneModalSheet({this.milestone});
  @override
  State<SkipMilestoneModalSheet> createState() =>
      _SkipMilestoneModalSheetState();
}

class _SkipMilestoneModalSheetState extends State<SkipMilestoneModalSheet> {
  final ScratchCardRepository _scratchCardRepo =
      locator<ScratchCardRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  bool _skippingInProgress = false;
  S locale = locator<S>();
  get skippingInProgress => _skippingInProgress;

  set skippingInProgress(value) {
    setState(() {
      _skippingInProgress = value;
    });
  }

  onTokenSkipPressed() async {
    AppState.screenStack.add(ScreenItem.loader);
    skippingInProgress = true;
    final res = await _scratchCardRepo.skipMilestone();
    if (res.isSuccess()) {
      _userCoinService.getUserCoinBalance();
      skippingInProgress = false;
      AppState.screenStack.removeLast();
      while (AppState.screenStack.length > 1) {
        AppState.backButtonDispatcher!.didPopRoute();
      }

      BaseUtil.showPositiveAlert(
          locale.skipMileStoneSuccessTitle, locale.skipMileStoneSuccessSubtile);
      _journeyService.updateAvatarIndexDirectly();
      _journeyService.checkAndAnimateAvatar();
    } else {
      skippingInProgress = false;
      AppState.screenStack.removeLast();
      AppState.backButtonDispatcher!.didPopRoute();
      AppState.backButtonDispatcher!.didPopRoute();
      BaseUtil.showNegativeAlert("", res.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.pageHorizontalMargins * 0.5,
                  right: SizeConfig.pageHorizontalMargins * 0.5,
                ),
                width: SizeConfig.screenWidth,
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: skippingInProgress
                        ? () {}
                        : () => AppState.backButtonDispatcher!.didPopRoute(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: SizeConfig.iconSize0,
                    )),
              ),
              Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.jSkipMilestoneSecondary,
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    Text(
                      locale.jSkipMileStoneDesc,
                      style:
                          TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
                    ),
                    SizedBox(height: SizeConfig.padding40),
                    if (widget.milestone!.skipCost!.containsKey('rupee'))
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.jInvestAmountTitile,
                              style: TextStyles.body3
                                  .colour(Colors.grey.withOpacity(0.6)),
                            ),
                            SizedBox(height: SizeConfig.padding6),
                            Row(children: [
                              Image.asset(Assets.moneyIcon,
                                  height: SizeConfig.iconSize1),
                              SizedBox(width: SizeConfig.padding10),
                              Text(
                                "₹ ${widget.milestone!.skipCost!['rupee']}",
                                style: TextStyles.rajdhaniSB.title4
                                    .colour(Colors.white),
                              ),
                            ]),
                            SizedBox(height: SizeConfig.padding24),
                          ]),
                    if (widget.milestone!.skipCost!.length == 1 &&
                        widget.milestone!.skipCost!.containsKey('flc'))
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.tokensRequired,
                              style: TextStyles.body3
                                  .colour(Colors.grey.withOpacity(0.6)),
                            ),
                            SizedBox(height: SizeConfig.padding6),
                            Row(
                              children: [
                                SvgPicture.asset(Assets.token,
                                    height: SizeConfig.iconSize1),
                                SizedBox(width: SizeConfig.padding6),
                                Text(
                                  widget.milestone!.skipCost!['flc'].toString(),
                                  style: TextStyles.rajdhaniSB.title4
                                      .colour(Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.padding24),
                          ]),
                    skippingInProgress
                        ? SizedBox(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.padding24,
                            child: Center(
                              child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: SizeConfig.padding20),
                            ),
                          )
                        : Column(
                            children: [
                              if (widget.milestone!.skipCost!
                                  .containsKey('rupee'))
                                AppPositiveBtn(
                                    btnText: locale.btnSaveNow,
                                    onPressed: () {
                                      AppState.backButtonDispatcher!
                                          .didPopRoute();
                                      AppState.backButtonDispatcher!
                                          .didPopRoute();
                                      return BaseUtil
                                          .openDepositOptionsModalSheet(
                                        isSkipMl: true,
                                        amount: widget
                                            .milestone!.skipCost!['rupee'],
                                      );
                                    },
                                    width: SizeConfig.screenWidth),
                              if (widget.milestone!.skipCost!
                                  .containsKey('flc'))
                                widget.milestone!.skipCost!.length == 1
                                    ? AppNegativeBtn(
                                        btnText: locale.btnSkipWithTokens,
                                        width: SizeConfig.screenWidth,
                                        onPressed: onTokenSkipPressed,
                                      )
                                    : Container(
                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                          child: Text(
                                            locale.skipWithtokenCost(widget
                                                .milestone!.skipCost!['flc']),
                                            style: TextStyles.sourceSansL.body3
                                                .colour(Colors.white),
                                          ),
                                          onPressed: onTokenSkipPressed,
                                        ),
                                      ),
                            ],
                          ),
                    SizedBox(
                        height: SizeConfig.viewInsets.bottom +
                            (SizeConfig.padding24 -
                                    SizeConfig.viewInsets.bottom)
                                .abs())
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
