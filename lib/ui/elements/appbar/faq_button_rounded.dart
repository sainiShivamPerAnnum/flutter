import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class FaqButtonRounded extends StatelessWidget {
  final FaqsType? type;
  const FaqButtonRounded({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyticsService? _analyticsService = locator<AnalyticsService>();

    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: SizeConfig.avatarRadius,
      child: IconButton(
        icon: Icon(
          Icons.support_agent,
          color: Colors.white,
          size: SizeConfig.avatarRadius * 0.8,
        ),
        onPressed: () {
          Haptic.vibrate();
          _analyticsService!.track(
              eventName: AnalyticsEvents.questionMarkTaoped,
              properties: {"Location": getQuestionMarkTapLocation(type)});
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FaqPageConfig,
            widget: FAQPage(
              type: type,
            ),
          );
        },
      ),
    );
  }

  getQuestionMarkTapLocation(FaqsType? type) {
    if (type == FaqsType.gettingStarted)
      return "Getting Started Screen";
    else if (type == FaqsType.yourAccount)
      return "Your Account Screen";
    else if (type == FaqsType.savings)
      return "Save screen";
    else if (type == FaqsType.autosave)
      return "SIP Autosave SCreen";
    else if (type == FaqsType.withdrawals)
      return "Withdrawl";
    else if (type == FaqsType.play)
      return "Play Section";
    else if (type == FaqsType.winnings)
      return "Win Section";
    else if (type == FaqsType.gold)
      return "Digital Gold Asset Screen";
    else if (type == FaqsType.flo)
      return "Fello Flo Asset Screen";
    else if (type == FaqsType.journey)
      return "Journey View";
    else
      return "";
  }
}
