import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
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

  const ActiveOrPausedAutosaveCard({Key? key, required this.service})
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
        "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24, vertical: SizeConfig.padding20),
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth! * 0.38,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding14),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        service.subscriptionData != null &&
                                service.subscriptionData!.status ==
                                    Constants.SUBSCRIPTION_ACTIVE
                            ? Assets.autoSaveOngoing
                            : Assets.autoSavePaused,
                        height: SizeConfig.padding80,
                        width: SizeConfig.padding80,
                      ),
                      SizedBox(
                        width: SizeConfig.padding24,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getAutosaveStatusText(service.autosaveState),
                              style: TextStyles.sourceSansB.body0.colour(
                                  service.autosaveState == AutosaveState.ACTIVE
                                      ? UiConstants.primaryColor
                                      : UiConstants.tertiarySolid),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: SizeConfig.padding6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Investing',
                                      style: TextStyles.sourceSans.body4
                                          .colour(UiConstants.kTextColor2),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: '₹ ',
                                        style: TextStyles.sourceSansSB.body0
                                            .colour(UiConstants.kTextColor),
                                        children: [
                                          TextSpan(
                                            text:
                                                "${service.subscriptionData?.amount ?? 0} ",
                                            style: TextStyles.sourceSansSB.body0
                                                .colour(UiConstants.kTextColor),
                                          ),
                                          TextSpan(
                                            text: "/" +
                                                (service.subscriptionData
                                                        ?.frequency
                                                        .toCamelCase() ??
                                                    ""),
                                            style: TextStyles.sourceSans.body4
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(SizeConfig.padding12),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: SizeConfig.padding24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
