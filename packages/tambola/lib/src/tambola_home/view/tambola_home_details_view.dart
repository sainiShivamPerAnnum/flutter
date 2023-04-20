import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/models/prizes_model.dart';
import 'package:tambola/src/tambola_home/widgets/header.dart';
import 'package:tambola/src/tambola_home/widgets/prizes_section.dart';
import 'package:tambola/src/tambola_home/widgets/ticket_cost_info.dart';
import 'package:tambola/src/utils/assets.dart';
import 'package:tambola/src/utils/styles/styles.dart';

import '../widgets/past_week_winners_section.dart';

class TambolaHomeDetailsView extends StatefulWidget {
  const TambolaHomeDetailsView({
    Key? key,
    // required this.model,
    this.showPrizeSection = false,
    this.showWinners = false,
  }) : super(key: key);
  // final TambolaHomeViewModel model;
  final bool showPrizeSection;
  final bool showWinners;

  @override
  State<TambolaHomeDetailsView> createState() => _TambolaHomeDetailsViewState();
}

class _TambolaHomeDetailsViewState extends State<TambolaHomeDetailsView> {
  ScrollController? _scrollController;
  bool isFromNavigation = false;

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

    // isFromNavigation = widget.isFromNavigation;
    return Stack(
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
                    SvgPicture.asset(
                      Assets.cr1_Tambola,
                      height: SizeConfig.screenHeight! * 0.2,
                    ),
                    SizedBox(
                      height: SizeConfig.padding14,
                    ),
                    TambolaHeader(
                      uri: "",
                      // model: widget.model,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                child: const TambolaTicketInfo(),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                width: SizeConfig.screenWidth! * 0.9,
                child: Text(
                  // widget.model.game!.description!,
                  "qwertyuiop",
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.body2.colour(
                      UiConstants.kProfileBorderColor.withOpacity(0.41)),
                ),
              ),
              SizedBox(height: SizeConfig.padding20),
              TambolaPrize(
                prizes: PrizesModel(),
                // model: widget.model,
              ),
              TambolaLeaderBoard(winners: []),
              // const TermsAndConditions(url: Constants.tambolatnc),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.25,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding:
                const EdgeInsets.only(top: 14, bottom: 24, left: 32, right: 32),
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
                        // widget.model.game?.highLight ??
                        '',
                        style: TextStyles.sourceSans.body4
                            .colour(const Color(0xffA7A7A8)),
                      ),
                    ],
                  ),
                ),
                //TODO: REVERT WHEN PACAKGE IS SETUP
                // Showcase(
                //   key: ShowCaseKeys.TambolaButton,
                //   description: 'You get a ticket on every ₹500 you invest!',
                //   child: AppPositiveBtn(
                //     btnText: 'Save & Get Free Tickets',
                //     onPressed: () {
                //       // locator<AnalyticsService>().track(
                //       //     eventName:
                //       //         (widget.model.activeTambolaCardCount ?? 0) >= 1
                //       //             ? AnalyticsEvents.tambolaSaveTapped
                //       //             : AnalyticsEvents.tambolaGetFirstTicketTapped,
                //       //     properties: AnalyticsProperties
                //       //         .getDefaultPropertiesMap(extraValuesMap: {
                //       //       "Time left for draw Tambola (mins)":
                //       //           AnalyticsProperties.getTimeLeftForTambolaDraw(),
                //       //       "Tambola Tickets Owned":
                //       //           AnalyticsProperties.getTambolaTicketCount(),
                //       //       "Number of Tickets":
                //       //           widget.model.activeTambolaCardCount ?? 0,
                //       //       "Amount": widget.model.ticketSavedAmount,
                //       //     }));
                //       widget.model.updateTicketSavedAmount(1);
                //       BaseUtil.openDepositOptionsModalSheet(
                //           amount: widget.model.ticketSavedAmount,
                //           subtitle:
                //               'Save ₹500 in any of the asset & get 1 Free Tambola Ticket',
                //           timer: 0);
                //     },
                //   ),
                // ),
                if (isFromNavigation)
                  SizedBox(
                    height: SizeConfig.navBarHeight,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
