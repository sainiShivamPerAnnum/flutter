import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/autosave/segmate_chip.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AutosaveCard extends StatelessWidget {
  final ValueKey locationKey;
  AutosaveCard({required this.locationKey});

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
                  ? ActiveOrPausedAutosaveCard(
                      service: service,
                      innerTapActive: false,
                    )
                  : InitAutosaveCard(
                      service: service,
                    ),
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
              title: 'Start Autosaving',
              subTitle:
                  'Save in Digital Gold automatically and win added rewards',
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
                        child: Text(locale.saveAutoSaveTitle,
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
              height: SizeConfig.padding32,
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
  final bool innerTapActive;
  const ActiveOrPausedAutosaveCard(
      {Key? key, required this.service, this.asset, this.innerTapActive = true})
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
    return GestureDetector(
      onTap: () {
        if (innerTapActive) service.handleTap();
      },
      child: Container(
        height: SizeConfig.screenWidth! * 0.20,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
        decoration: BoxDecoration(
          color: UiConstants.kBackgroundColor2,
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              service.subscriptionData != null &&
                      service.subscriptionData!.status ==
                          Constants.SUBSCRIPTION_ACTIVE
                  ? Assets.autoSaveOngoing
                  : Assets.autoSavePaused,
              height: SizeConfig.padding44,
              width: SizeConfig.padding44,
            ),
            SizedBox(
              width: SizeConfig.padding6,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Autosave " + getAutosaveStatusText(service.autosaveState),
                style: TextStyles.sourceSansB.body1.colour(
                    service.autosaveState == AutosaveState.ACTIVE
                        ? UiConstants.primaryColor
                        : UiConstants.tertiarySolid),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(),
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
                        (service.subscriptionData?.frequency.toCamelCase() ??
                            ""),
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor2),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                service.handleTap();
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
