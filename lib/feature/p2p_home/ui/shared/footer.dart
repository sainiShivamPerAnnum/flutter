import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/analytics_events_constants.dart';
import '../../../../core/enums/investment_type.dart';
import '../../../../core/service/analytics/analytics_service.dart';
import '../../../../core/service/notifier_services/user_service.dart';
import '../../../../util/locator.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  void trackSaveDailyButtonTapped() {
    final totalInvestment =
        locator<UserService>().userPortfolio.flo.balance.toDouble();
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.saveDailyTappedOnAssetDetailPage,
      properties: {
        "type": InvestmentType.LENDBOXP2P.name,
        "total_investments": totalInvestment,
      },
    );
  }

  void trackSaveOnceButtonTapped() {
    final totalInvestment =
        locator<UserService>().userPortfolio.flo.balance.toDouble();
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.saveOnceTappedOnAssetDetailPage,
      properties: {
        "type": InvestmentType.LENDBOXP2P.name,
        "total_investments": totalInvestment,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UiConstants.bg,
      padding: EdgeInsets.only(
        left: SizeConfig.padding32,
        right: SizeConfig.padding32,
        bottom: SizeConfig.padding16,
        top: SizeConfig.padding8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(
                Assets.floAsset,
                height: SizeConfig.padding28,
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                '56% of our users have invested in Fello Flo',
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.textGray50,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Expanded(
                child: SecondaryOutlinedButton(
                  label: 'SAVE ONCE',
                  onPressed: () {
                    trackSaveOnceButtonTapped();
                    DefaultTabController.of(context).animateTo(1);
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Expanded(
                child: SecondaryButton(
                  label: 'SAVE DAILY',
                  onPressed: () {
                    trackSaveDailyButtonTapped();
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: SipIntroPageConfig,
                      widget: const SipIntroView(),
                      state: PageState.addWidget,
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
