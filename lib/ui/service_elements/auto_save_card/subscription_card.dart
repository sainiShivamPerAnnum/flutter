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

class AutosaveCard extends StatelessWidget {
  final InvestmentType? investmentType;
  const AutosaveCard({super.key, this.investmentType});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubService>(
      builder: (context, service, child) => service.autosaveVisible
          ? GestureDetector(
              onTap: () async {
                if (context.read<ConnectivityService>().connectivityStatus ==
                    ConnectivityStatus.Offline) {
                  return BaseUtil.showNoInternetAlert();
                }
                await service.handleTap();
              },
              child: (service.subscriptionData != null)
                  ? ActiveOrPausedAutosaveCard(service: service)
                  : InitAutosaveCard(service: service),
            )
          : const SizedBox(),
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
            const TitleSubtitleContainer(
              title: 'Introducing Autosave',
              // subTitle: 'Automated payments for Fello Flo & Digital Gold',
            ),
            SizedBox(height: SizeConfig.padding16),
            Container(
              decoration: BoxDecoration(
                color: UiConstants.kTambolaMidTextColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding20,
                  vertical: SizeConfig.padding32),
              child: Column(
                children: [
                  Row(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth! * 0.5,
                              ),
                              child: Text("Get started with a daily/weekly SIP",
                                  style: TextStyles.rajdhani.bold.body1),
                            ),
                            SizedBox(
                              height: SizeConfig.padding20,
                            ),
                            Text(
                              "Invest safely with our Auto SIP to win tokens",
                              style: TextStyles.body3.colour(Colors.grey[600]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.scratchCard,
                        width: SizeConfig.padding24,
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "  Win a scratch card on successful autosave setup",
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                                  text:
                                      "/${service.subscriptionData?.frequency.toCamelCase().frequencyRename() ?? ""}",
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
