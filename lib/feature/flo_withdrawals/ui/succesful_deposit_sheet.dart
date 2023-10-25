import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessfulDepositSheet extends StatelessWidget {
  const SuccessfulDepositSheet({
    required this.investAmount,
    required this.maturityAmount,
    required this.maturityDate,
    required this.reInvestmentDate,
    required this.fdDuration,
    required this.roiPerc,
    required this.title,
    required this.topChipText,
    required this.footer,
    required this.fundType,
    super.key,
  });

  final String investAmount;
  final String maturityAmount;
  final String maturityDate;
  final String reInvestmentDate;
  final String fdDuration;
  final String roiPerc;
  final String title;
  final String topChipText;
  final String footer;
  final String fundType;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding22,
          vertical: SizeConfig.padding18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff023C40),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    AppState.backButtonDispatcher?.didPopRoute();
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.crossTappedOnPendingActions,
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: SizeConfig.padding24,
                  ),
                ),
              ],
            ),
            // SizedBox(height: SizeConfig.padding8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/svg/fello_flo.svg',
                  height: SizeConfig.padding64,
                  // width: SizeConfig.padding4,
                  // fit: BoxFit.cover,
                ),
                SizedBox(width: SizeConfig.padding8),
                Text(title,
                    style: TextStyles.rajdhaniSB.body0.colour(Colors.white))
              ],
            ),
            SizedBox(height: SizeConfig.padding30),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding18,
                      vertical: SizeConfig.padding20),
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Re-investment on',
                                style: TextStyles.sourceSans.body3
                                    .colour(const Color(0xFFBDBDBE)),
                              ),
                              SizedBox(height: SizeConfig.padding4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding8,
                                    vertical: SizeConfig.padding4),
                                decoration: ShapeDecoration(
                                  color:
                                      const Color(0xFFD9D9D9).withOpacity(0.20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12)),
                                ),
                                child: Text(
                                  reInvestmentDate,
                                  style: TextStyles.sourceSans.body4
                                      .colour(Colors.white),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Matures on',
                                style: TextStyles.sourceSans.body3
                                    .colour(const Color(0xFFBDBDBE)),
                              ),
                              SizedBox(height: SizeConfig.padding4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding8,
                                    vertical: SizeConfig.padding4),
                                decoration: ShapeDecoration(
                                  color:
                                      const Color(0xFFD9D9D9).withOpacity(0.20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12)),
                                ),
                                child: Text(
                                  maturityDate,
                                  style: TextStyles.sourceSans.body4
                                      .colour(Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Invested',
                                style: TextStyles.sourceSans.body3
                                    .colour(const Color(0xFFBDBDBE)),
                              ),
                              SizedBox(height: SizeConfig.padding4),
                              Text(
                                '₹$investAmount',
                                style: TextStyles.sourceSansSB.title5
                                    .colour(Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.padding56,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  fdDuration,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.sourceSans.body3
                                      .colour(Colors.white),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/Arrow.svg',
                                  width: SizeConfig.padding64,
                                ),
                                Text(
                                  '@$roiPerc P.A',
                                  style: TextStyles.sourceSansSB.body4.colour(
                                    const Color(0xFF3DFFD0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Maturity',
                                style: TextStyles.sourceSans.body3
                                    .colour(const Color(0xFFBDBDBE)),
                              ),
                              SizedBox(height: SizeConfig.padding4),
                              Text(
                                '₹$maturityAmount',
                                style: TextStyles.sourceSansSB.title5
                                    .colour(const Color(0xFF1AFFD5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(0, -SizeConfig.padding12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF62E3C4),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness16),
                      ),
                      child: topChipText.beautify(
                        boldStyle: TextStyles.sourceSansB.body4.colour(
                          const Color(0xFF013B3F),
                        ),
                        style: TextStyles.sourceSansSB.body4.colour(
                          const Color(0xFF013B3F),
                        ),
                        alignment: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding30),
            Text(
              footer,
              textAlign: TextAlign.center,
              style:
                  TextStyles.sourceSans.body3.colour(const Color(0xFFBDBDBE)),
            ),
            SizedBox(height: SizeConfig.padding12),
            MaterialButton(
                minWidth: SizeConfig.screenWidth,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.padding44,
                child: Text(
                  "GO TO TRANSACTIONS",
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
                onPressed: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher?.didPopRoute();

                  AppState.delegate!.appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    page: SaveAssetsViewConfig,
                    widget: AssetSectionView(
                      type: InvestmentType.LENDBOXP2P,
                    ),
                  );

                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.goToTransactionsTapped,
                    properties: {
                      'asset': fundType,
                      "Maturity Date": maturityDate,
                      "Maturity Amount": maturityAmount,
                      "principal amount": investAmount,
                    },
                  );
                }),
            SizedBox(height: SizeConfig.padding12),
          ],
        ),
      ),
    );
  }
}
