import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/service_elements/quiz/quiz_web_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class QuizSection extends StatefulWidget {
  const QuizSection({super.key});

  @override
  State<QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends State<QuizSection> {
  @override
  void initState() {
    super.initState();
  }

  String _onTapQuizSection(String deeplink) {
    final jwt = JWT(
      {'uid': locator<UserService>().baseUser!.uid},
    );
    String token = jwt.sign(
        SecretKey(
            '3565d165c367a0f1c615c27eb957dddfef33565b3f5ad1dda3fe2efd07326c1f'),
        expiresIn: const Duration(hours: 1));
    return token;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> quizSectionData =
        AppConfig.getValue(AppConfigKey.quiz_config);

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
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: QuizWebViewConfig,
                state: PageState.addWidget,
                widget: const QuizWebView(),
              );

              locator<AnalyticsService>().track(
                eventName: AnalyticsEvents.quizBannerTapped,
                properties: AnalyticsProperties.getDefaultPropertiesMap(
                  extraValuesMap: {
                    'Total Invested Amount':
                        AnalyticsProperties.getGoldInvestedAmount() +
                            AnalyticsProperties.getFelloFloAmount(),
                    "Gold Invested":
                        AnalyticsProperties.getGoldInvestedAmount(),
                    "Flo Invested": AnalyticsProperties.getFelloFloAmount(),
                    "Total Tambola Tickets":
                        AnalyticsProperties.getTambolaTicketCount(),
                  },
                ),
              );
            },
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
