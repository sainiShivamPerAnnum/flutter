import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
                await service.handleTap(type: investmentType);
              },
              child: (service.subscriptionData != null)
                  ? ActiveOrPausedAutosaveCard(service: service)
                  : InitAutosaveCard(service: service),
            )
          : const SizedBox(),
    );
  }
}

class InitAutosaveCard extends HookWidget {
  final SubService service;

  InitAutosaveCard({required this.service, Key? key}) : super(key: key);

  final List<String> images = [
    'assets/svg/iphone.svg',
    'assets/svg/car.svg',
    'assets/svg/trip.svg',
  ];

  final List<String> titles = [
    'Buy an Iphone',
    'Buy a Car',
    'Plan a Trip',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleSubtitleContainer(title: 'SIP with Fello'),
          SizedBox(height: SizeConfig.padding10),
          Container(
            decoration: BoxDecoration(
              // color: UiConstants.kTambolaMidTextColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              gradient: LinearGradient(
                begin: const Alignment(-0.00, -1.00),
                end: const Alignment(0, 1),
                colors: [
                  const Color(0xFF617E8E),
                  const Color(0x00617E8E).withOpacity(0.7)
                ],
                // stops: [0.7, 1.0],
              ),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.padding88,
                        width: SizeConfig.padding90 + SizeConfig.padding6,
                        child: CarouselSlider.builder(
                          itemCount: 3,
                          itemBuilder: (context, index, realIndex) {
                            return SvgPicture.asset(
                              images[index],
                              // width: 75,
                              height: SizeConfig.padding88,
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1,
                            scrollPhysics:
                                const AlwaysScrollableScrollPhysics(),
                            onPageChanged: (index, reason) {
                              currentIndex.value = index;
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -SizeConfig.padding16),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding12,
                                vertical: SizeConfig.padding4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF465963),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              titles[currentIndex.value],
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white),
                            )),
                      ),
                      // add indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            width: SizeConfig.padding6,
                            height: SizeConfig.padding6,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentIndex.value
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: SizeConfig.padding168,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Set Your Financial Goals with Autosave',
                            style: TextStyles.rajdhaniSB.body1
                                .colour(Colors.white)),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        Text(
                          'Invest on Fello to meet your financial Goals',
                          style: TextStyles.sourceSans.body4
                              .colour(const Color(0xFFA9C5D5)),
                        ),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Setup Autosave',
                              style: TextStyles.sourceSansSB.body2
                                  .colour(Colors.white),
                            ),
                            SvgPicture.asset(
                              Assets.chevRonRightArrow,
                              color: Colors.white,
                              height: SizeConfig.padding24,
                              width: SizeConfig.padding24,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveOrPausedAutosaveCard extends StatelessWidget {
  final SubService service;
  final InvestmentType? asset;
  final bool assetSpecificCard;

  const ActiveOrPausedAutosaveCard(
      {required this.service,
      Key? key,
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

  String getTitle() {
    switch (service.autosaveState) {
      case AutosaveState.ACTIVE:
        return 'Started this Autosave on - ${DateFormat('dd MMM yyyy').format(service.subscriptionData!.startDate!.toDate())}';
      case AutosaveState.PAUSED:
        return 'Go here to resume';

      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleSubtitleContainer(
            title: 'Autosave Details',
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          GestureDetector(
            onTap: service.handleTap,
            child: Container(
              // height: SizeConfig.screenWidth! * 0.36,
              // width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding16),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
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
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          getAutosaveStatusText(service.autosaveState) +
                              " Autosave",
                          style: TextStyles.sourceSansB.body0.colour(
                              service.autosaveState == AutosaveState.PAUSED
                                  ? const Color(0xFFEFAF4E)
                                  : Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding12),
                      RichText(
                        text: TextSpan(
                          text: '₹',
                          style: TextStyles.sourceSansSB.body0
                              .colour(UiConstants.kTextColor),
                          children: [
                            TextSpan(
                              text:
                                  "${asset == InvestmentType.AUGGOLD99 ? service.subscriptionData?.augAmt : asset == InvestmentType.LENDBOXP2P ? service.subscriptionData?.lbAmt : service.subscriptionData?.amount ?? 0} ",
                              style: TextStyles.rajdhaniSB.title4
                                  .colour(Colors.white),
                            ),
                            TextSpan(
                              text:
                                  "/${service.subscriptionData?.frequency.toCamelCase().frequencyRename() ?? "day"}",
                              style: TextStyles.sourceSans.body2
                                  .colour(Colors.white.withOpacity(0.4)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding12),
                      SizedBox(
                        width: SizeConfig.screenWidth! * 0.45,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                getTitle(),
                                style: TextStyles.sourceSans.body4.colour(
                                    service.autosaveState ==
                                            AutosaveState.PAUSED
                                        ? Colors.white
                                        : const Color(0xFFA9C5D5)),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            if (service.autosaveState == AutosaveState.PAUSED)
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
