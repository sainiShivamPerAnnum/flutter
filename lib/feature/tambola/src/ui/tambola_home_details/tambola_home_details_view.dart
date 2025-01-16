import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_tutorial_slot_machine_view.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/header.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/past_week_winners_section.dart';

class TambolaHomeDetailsView extends StatefulWidget {
  const TambolaHomeDetailsView({
    Key? key,
    this.isStandAloneScreen = false,
    this.showPrizeSection = false,
    this.showWinners = false,
    this.showBottomButton = true,
    this.showDemoImage = true,
  }) : super(key: key);
  final bool isStandAloneScreen;
  final bool showPrizeSection;
  final bool showWinners;
  final bool showBottomButton;
  final showDemoImage;

  @override
  State<TambolaHomeDetailsView> createState() => _TambolaHomeDetailsViewState();
}

class _TambolaHomeDetailsViewState extends State<TambolaHomeDetailsView> {
  // ScrollController? _scrollController;

  @override
  void initState() {
    // _scrollController = ScrollController();

    if (widget.showPrizeSection) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        RootController.controller.animateTo(SizeConfig.screenWidth! * 1.7,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    if (widget.showWinners) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        RootController.controller.animateTo(SizeConfig.screenWidth! * 2.6,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    super.initState();
  }

  // @override
  // void dispose() {
  //   _scrollController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);

    return BaseView<TambolaHomeDetailsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0x0f2a2a2a),
          appBar: widget.isStandAloneScreen
              ? AppBar(
                  elevation: 0,
                  backgroundColor: const Color(0XFF141414),
                   surfaceTintColor: const Color(0XFF141414),
                )
              : null,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                controller: RootController.controller,
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
                          SvgPicture.asset(
                            Assets.tambolaCardAsset,
                            width: SizeConfig.screenWidth! * 0.4,
                          ),
                          Text(
                            "Tickets",
                            style: TextStyles.rajdhaniB.title1,
                            textAlign: TextAlign.center,
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
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2,
                    ),
                    if (widget.showDemoImage) const TambolaDemoImage(),
                    TicketsRewardCategoriesWidget(
                        isOpen: true,
                        color: UiConstants.kTambolaMidTextColor,
                        highlightRow: false),
                    const TambolaLeaderboardView(),
                    const TermsAndConditions(url: Constants.tambolatnc),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.25,
                    )
                  ],
                ),
              ),
              if (widget.showBottomButton)
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
                        AppPositiveBtn(
                          style: TextStyles.rajdhaniSB.body0,
                          btnText: 'Unlock your first ticket now',
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

                                timer: 0);
                          },
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

class TambolaDemoImage extends StatelessWidget {
  const TambolaDemoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/blurred_ticket.png",
                width: SizeConfig.screenWidth! * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: SizeConfig.padding54,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: SizeConfig.iconSize1 * 2,
                    color: Colors.white,
                    weight: 700,
                    grade: 200,
                    opticalSize: 48,
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    "Unlock your first ticket by saving\n₹${AppConfig.getValue(AppConfigKey.tambola_cost)} on Fello",
                    style: TextStyles.rajdhaniB.body1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
          width: SizeConfig.screenWidth! * 0.9,
          child: Text(
            '15 numbers on a ticket. 21 numbers picked every week. Cross all numbers to get rewarded!',
            textAlign: TextAlign.center,
            style: TextStyles.rajdhaniSB.body2
                .colour(UiConstants.kProfileBorderColor.withOpacity(0.41)),
          ),
        ),
        SizedBox(height: SizeConfig.padding20),
      ],
    );
  }
}
