// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerSupportWidget extends StatelessWidget {
  const CustomerSupportWidget({
    required this.config,
    super.key,
  });

  final LendboxAssetConfiguration config;

  void _onTapBanner(LendboxAssetConfiguration config) {
    final portfolio = locator<UserService>().userPortfolio;
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.helpInFloSlabTapped,
      properties: {
        "asset name": "${config.interest}% Flo",
        "new user":
            locator<UserService>().userSegments.contains(Constants.NEW_USER),
        "total invested amount": switch (config.fundType) {
          FundType.UNI_FIXED_6 => portfolio.flo.fixed1.principle,
          FundType.UNI_FIXED_3 => portfolio.flo.fixed2.principle,
          FundType.UNI_FIXED_1 => portfolio.flo.fixed2.principle,
          FundType.UNI_FLEXI => portfolio.flo.flexi.principle,
          _ => portfolio.flo.assetInfo[config.fundType.name]?.principle,
        },
        "total current amount": switch (config.fundType) {
          FundType.UNI_FIXED_6 => portfolio.flo.fixed1.balance,
          FundType.UNI_FIXED_3 => portfolio.flo.fixed2.balance,
          FundType.UNI_FIXED_1 => portfolio.flo.fixed2.balance,
          FundType.UNI_FLEXI => portfolio.flo.flexi.balance,
          _ => portfolio.flo.assetInfo[config.fundType.name]?.balance,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kSaveStableFelloCardBg,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness16,
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      margin: EdgeInsets.all(
        SizeConfig.pageHorizontalMargins,
      ),
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: SizeConfig.padding200 + SizeConfig.padding4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We’ll be happy to assist",
                  style: TextStyles.rajdhaniSB.body1,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Text(
                  "Get in touch with the experts at Fello to assist you in your savings",
                  style: TextStyles.body3.colour(Colors.white),
                )
              ],
            ),
          ),
          Stack(
            children: [
              SvgPicture.asset(
                'assets/svg/customer_help.svg',
                height: SizeConfig.padding104,
              ),
              Transform.translate(
                offset: Offset(0, SizeConfig.padding54),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: OutlinedButton(
                    onPressed: () {
                      Haptic.vibrate();
                      AppState.delegate!.appState.currentAction = PageAction(
                        state: PageState.addPage,
                        page: FreshDeskHelpPageConfig,
                      );
                      _onTapBanner(config);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(
                          0xFF01656B,
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Text(
                      "ASK FELLO",
                      style: TextStyles.rajdhaniB.body2.colour(Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
