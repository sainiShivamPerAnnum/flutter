import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/autosave/segmate_chip.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AutosaveCard extends StatelessWidget {
  final InvestmentType? investmentType;
  AutosaveCard({this.investmentType});

  bool showAutosaveCard(SubService service) {
    if (investmentType != null) {
      if (service.subscriptionData!.status == "PAUSE_FROM_APP_FOREVER") {
        return false;
      } else {
        if (investmentType == InvestmentType.AUGGOLD99) {
          return !((service.subscriptionData!.augAmt ?? "").isEmpty ||
              service.subscriptionData!.augAmt == "0");
        } else {
          return !((service.subscriptionData!.lbAmt ?? "").isEmpty ||
              service.subscriptionData!.lbAmt == "0");
        }
      }
    } else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubService>(
      builder: (context, service, child) => service.autosaveVisible
          ? GestureDetector(
              onTap: () async {
                if (context.read<ConnectivityService>().connectivityStatus ==
                    ConnectivityStatus.Offline)
                  return BaseUtil.showNoInternetAlert();
                await service.handleTap();
              },
              child: (service.subscriptionData != null)
                  ? ActiveOrPausedAutosaveCard(service: service)
                  : InitAutosaveCard(service: service),
            )
          : SizedBox(),
    );
  }
}

class InitAutosaveCard extends StatelessWidget {
  final SubService service;
  const InitAutosaveCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      color: UiConstants.kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleSubtitleContainer(
              title: 'Introducing Autosave',
              subTitle: 'Automated payments for Fello Flo & Digital Gold',
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.padding24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: UiConstants.kSecondaryBackgroundColor,
                    child: SvgPicture.asset(
                      Assets.autoSaveDefault,
                      width: 75,
                      height: 70,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: SizeConfig.screenWidth! * 0.5,
                        ),
                        child: Text("Setup Autosave Now",
                            style: TextStyles.sourceSans.bold.body1),
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      Row(
                        children: [
                          Shimmer(
                              gradient: new LinearGradient(
                                colors: [
                                  UiConstants.kTextColor2,
                                  Colors.white,
                                  UiConstants.kTextColor2
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              child: Text(locale.btnStart.toUpperCase(),
                                  style: TextStyles.rajdhaniSB.body3)),
                          SizedBox(
                            height: SizeConfig.padding4,
                          ),
                          SvgPicture.asset(
                            Assets.chevRonRightArrow,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding54,
              child: Row(
                children: [
                  SizedBox(width: SizeConfig.pageHorizontalMargins * 1.6),
                  SvgPicture.asset(
                    Assets.scratchCard,
                    width: SizeConfig.padding24,
                  ),
                  Text(
                    "  Win a scratch card on successful autosave setup",
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor2),
                  ),
                ],
              ),
            ),
            Divider(color: UiConstants.kTextColor2.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class ActiveOrPausedAutosaveCard extends StatelessWidget {
  final SubService service;
  final InvestmentType? asset;
  final bool assetSpecificCard;
  const ActiveOrPausedAutosaveCard(
      {Key? key,
      required this.service,
      this.asset,
      this.assetSpecificCard = true})
      : super(key: key);

  getAutosaveStatusText(AutosaveState state) {
    switch (state) {
      case AutosaveState.ACTIVE:
        return "Active";
      case AutosaveState.INIT:
        return "Processing";
      case AutosaveState.PAUSED:
        return "Paused";
      default:
        return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.padding10,
        bottom: SizeConfig.padding16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSubtitleContainer(
            title: 'Autosave Details',
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          GestureDetector(
            onTap: service.handleTap,
            child: Container(
              height: SizeConfig.screenWidth! * 0.36,
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                border: Border.all(color: Colors.white12),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        service.subscriptionData != null &&
                                service.subscriptionData!.status ==
                                    Constants.SUBSCRIPTION_ACTIVE
                            ? Assets.autoSaveOngoing
                            : Assets.autoSavePaused,
                        height: SizeConfig.padding90,
                        width: SizeConfig.padding90,
                      ),
                      SizedBox(
                        width: SizeConfig.padding20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              getAutosaveStatusText(service.autosaveState) +
                                  " Autosave",
                              style: TextStyles.sourceSansB.body0
                                  .colour(Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          RichText(
                            text: TextSpan(
                              text: '₹',
                              style: TextStyles.sourceSansSB.body0
                                  .colour(UiConstants.kTextColor),
                              children: [
                                TextSpan(
                                  text:
                                      "${asset == InvestmentType.AUGGOLD99 ? service.subscriptionData?.augAmt : asset == InvestmentType.LENDBOXP2P ? service.subscriptionData?.lbAmt : service.subscriptionData?.amount ?? 0} ",
                                  style: TextStyles.sourceSansSB.body0
                                      .colour(UiConstants.kTextColor),
                                ),
                                TextSpan(
                                  text: "/" +
                                      (service.subscriptionData?.frequency
                                              .toCamelCase()
                                              .frequencyRename() ??
                                          ""),
                                  style: TextStyles.sourceSans.body4
                                      .colour(UiConstants.kTextColor2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding12),
                      child: SvgPicture.asset(
                        Assets.chevRonRightArrow,
                        width: SizeConfig.iconSize0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
