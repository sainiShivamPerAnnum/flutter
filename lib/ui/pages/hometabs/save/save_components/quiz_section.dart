import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/service_elements/quiz/quiz_web_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class QuizSection extends StatelessWidget {
  const QuizSection({super.key});

  void _onTapQuizCard() {
    AppState.delegate!.appState.currentAction = PageAction(
      page: QuizWebViewConfig,
      state: PageState.addWidget,
      widget: const QuizWebView(),
    );

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.quizBannerTapped,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          'Total Invested Amount': AnalyticsProperties.getGoldInvestedAmount() +
              AnalyticsProperties.getFelloFloAmount(),
          "Gold Invested": AnalyticsProperties.getGoldInvestedAmount(),
          "Flo Invested": AnalyticsProperties.getFelloFloAmount(),
          "Total Tambola Tickets": AnalyticsProperties.getTambolaTicketCount(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizSectionData = AppConfig.getValue(AppConfigKey.quiz_config);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSubtitleContainer(
            title: quizSectionData["title"],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          GestureDetector(
            onTap: _onTapQuizCard,
            child: Container(
              height: SizeConfig.screenWidth! * 0.32,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                border: Border.all(color: Colors.white12),
                image: DecorationImage(
                  image: NetworkImage(
                    quizSectionData["image"],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
