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
  const FaqButtonRounded({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyticsService analyticsService = locator<AnalyticsService>();

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
          analyticsService.track(
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

  String getQuestionMarkTapLocation(FaqsType? type) {
    switch (type) {
      case FaqsType.gettingStarted:
        return "Getting Started Screen";
      case FaqsType.yourAccount:
        return "Your Account Screen";
      case FaqsType.savings:
        return "Save screen";
      case FaqsType.autosave:
        return "SIP Autosave Screen";
      case FaqsType.withdrawals:
        return "Withdrawal";
      case FaqsType.play:
        return "Play Section";
      case FaqsType.winnings:
        return "Win Section";
      case FaqsType.gold:
        return "Digital Gold Asset Screen";
      case FaqsType.flo:
        return "Fello Flo Asset Screen";
      case FaqsType.journey:
        return "Journey View";
      case FaqsType.tambola:
        return "Tambola View";
      case FaqsType.goldPro:
        return 'GoldPro View';
      case FaqsType.onboarding:
        return 'Onboarding View';
      case FaqsType.powerPlay:
        return 'PowerPlay View';
      case FaqsType.rewards:
        return 'ScratchCard view';
      case FaqsType.referrals:
        return 'Referrals View';
      case null:
        return '';
    }
  }
}
