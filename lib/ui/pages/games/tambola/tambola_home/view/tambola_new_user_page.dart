import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_home_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_header.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_prize.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_ticket_info.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../widgets/tambola_leader_board.dart';



class TambolaNewUserPage extends StatefulWidget {
  const TambolaNewUserPage(
      {Key? key,
        required this.model,
        this.showPrizeSection = false,
        this.showWinners = false,
        this.isFromNavigation = false})
      : super(key: key);
  final TambolaHomeViewModel model;
  final bool showPrizeSection;
  final bool isFromNavigation;
  final bool showWinners;
  @override
  State<TambolaNewUserPage> createState() => _TambolaNewUserPageState();
}

class _TambolaNewUserPageState extends State<TambolaNewUserPage> {
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
  Widget build(BuildContext context) {
    S locale = S.of(context);

    isFromNavigation = widget.isFromNavigation;
    return Scaffold(
      appBar: FAppBar(
        showAvatar: isFromNavigation,
        showCoinBar: false,
        showHelpButton: isFromNavigation,
        title: isFromNavigation ? null : locale.tTicket,
        type: FaqsType.play,
        backgroundColor: const Color(0XFF141414),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
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
                      SvgPicture.asset(
                        Assets.cr1_Tambola,
                        height: SizeConfig.screenHeight! * 0.2,
                      ),
                      SizedBox(
                        height: SizeConfig.padding14,
                      ),
                      TambolaHeader(
                        model: widget.model,
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
                    widget.model.game!.description!,
                    textAlign: TextAlign.center,
                    style: TextStyles.rajdhaniSB.body2
                        .colour(const Color(0xffD9D9D9).withOpacity(0.41)),
                  ),
                ),
                SizedBox(height: SizeConfig.padding20),
                TambolaPrize(
                  model: widget.model,
                ),
                TambolaLeaderBoard(
                  model: widget.model,
                ),
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
                          widget.model.game?.highLight ?? '',
                          style: TextStyles.sourceSans.body4
                              .colour(const Color(0xffA7A7A8)),
                        ),
                      ],
                    ),
                  ),
                  Showcase(
                    key: ShowCaseKeys.TambolaButton,
                    description: 'You get a ticket on every ₹500 you invest!',
                    child: AppPositiveBtn(
                      btnText: (widget.model.activeTambolaCardCount ?? 0) >= 1
                          ? locale.getTickets
                          : locale.tgetFirstTkt,
                      onPressed: () {
                        locator<AnalyticsService>().track(
                            eventName:
                            (widget.model.activeTambolaCardCount ?? 0) >= 1
                                ? AnalyticsEvents.tambolaSaveTapped
                                : AnalyticsEvents
                                .tambolaGetFirstTicketTapped,
                            properties: AnalyticsProperties
                                .getDefaultPropertiesMap(extraValuesMap: {
                              "Time left for draw Tambola (mins)":
                              AnalyticsProperties
                                  .getTimeLeftForTambolaDraw(),
                              "Tambola Tickets Owned":
                              AnalyticsProperties.getTambolaTicketCount(),
                              "Number of Tickets":
                              widget.model.activeTambolaCardCount ?? 0,
                              "Amount": widget.model.ticketSavedAmount,
                            }));
                        widget.model.updateTicketSavedAmount(1);
                        BaseUtil().openDepositOptionsModalSheet(
                            amount: widget.model.ticketSavedAmount);
                      },
                    ),
                  ),
                  if (isFromNavigation)
                    SizedBox(
                      height: SizeConfig.navBarHeight,
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
