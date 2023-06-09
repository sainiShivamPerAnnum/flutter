import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/header.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/prizes_section.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket_cost_info.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcaseview.dart';

import '../widgets/past_week_winners_section.dart';

class TambolaHomeDetailsView extends StatefulWidget {
  const TambolaHomeDetailsView({
    Key? key,
    this.isStandAloneScreen = false,
    this.showPrizeSection = false,
    this.showWinners = false,
  }) : super(key: key);
  final bool isStandAloneScreen;
  final bool showPrizeSection;
  final bool showWinners;

  @override
  State<TambolaHomeDetailsView> createState() => _TambolaHomeDetailsViewState();
}

class _TambolaHomeDetailsViewState extends State<TambolaHomeDetailsView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    if (widget.showPrizeSection) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController?.animateTo(SizeConfig.screenWidth! * 1.7,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    if (widget.showWinners) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController?.animateTo(SizeConfig.screenWidth! * 2.6,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);

    return BaseView<TambolaHomeDetailsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF141414),
          appBar: widget.isStandAloneScreen
              ? AppBar(
                  elevation: 0,
                  backgroundColor: const Color(0XFF141414),
                )
              : null,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: SizeConfig.padding14),
                      padding: EdgeInsets.only(top: SizeConfig.padding20),
                      decoration: const BoxDecoration(
                          color: Color(0XFF141414),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/lotties/1cr_thar.json',
                            height: SizeConfig.screenHeight! * 0.2,
                          ),
                          SizedBox(
                            height: SizeConfig.padding14,
                          ),
                          TambolaHeader(
                            uri: model.tambolaGameData?.walkThroughUri ??
                                "https://d37gtxigg82zaw.cloudfront.net/walkthroughs/choose-asset-720p.mp4",
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                      child: const TambolaTicketInfo(),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                      width: SizeConfig.screenWidth! * 0.9,
                      child: Text(
                        model.tambolaGameData?.description ?? "Tambola",
                        textAlign: TextAlign.center,
                        style: TextStyles.rajdhaniSB.body2.colour(
                            UiConstants.kProfileBorderColor.withOpacity(0.41)),
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding20),
                    const TambolaPrize(),
                    TambolaLeaderBoard(),
                    const TermsAndConditions(url: Constants.tambolatnc),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.25,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 14, bottom: 24, left: 32, right: 32),
                  width: double.infinity,
                  color: UiConstants.kBackgroundColor,
                  // height: SizeConfig.screenHeight! * 0.17,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(Assets.sparklingStar),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              model.tambolaGameData?.highLight ?? '',
                              style: TextStyles.sourceSans.body4
                                  .colour(const Color(0xffA7A7A8)),
                            ),
                          ],
                        ),
                      ),
                      Showcase(
                        key: ShowCaseKeys.TambolaButton,
                        description: 'You get a ticket on every ₹500 you save!',
                        child: AppPositiveBtn(
                          btnText: 'Save & Get Free Tickets',
                          onPressed: () {
                            locator<AnalyticsService>().track(
                                eventName: (locator<TambolaService>()
                                            .bestTickets
                                            ?.data !=
                                        null)
                                    ? AnalyticsEvents.tambolaSaveTapped
                                    : AnalyticsEvents
                                        .tambolaGetFirstTicketTapped,
                                properties: AnalyticsProperties
                                    .getDefaultPropertiesMap(extraValuesMap: {
                                  "Time left for draw Tambola (mins)":
                                      AnalyticsProperties
                                          .getTimeLeftForTambolaDraw(),
                                  "Tambola Tickets Owned": AnalyticsProperties
                                      .getTambolaTicketCount(),
                                  "Number of Tickets": locator<TambolaService>()
                                          .bestTickets
                                          ?.data
                                          ?.totalTicketCount ??
                                      0,
                                  "Amount": 500,
                                }));
                            BaseUtil.openDepositOptionsModalSheet(
                                amount: 500, //model.ticketSavedAmount,
                                subtitle:
                                    'Save ₹500 in any of the asset & get 1 Free Tambola Ticket',
                                timer: 0);
                          },
                        ),
                      ),
                      // if (!widget.isStandAloneScreen)
                      //   SizedBox(
                      //     height: SizeConfig.navBarHeight,
                      //   )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
