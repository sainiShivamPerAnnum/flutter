import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/current_winnings_info.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/news_component.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/refer_and_earn_card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/scratch_card_info_strip.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<ScratchCardService,
        ScratchCardServiceProperties>(
      value: locator<ScratchCardService>(),
      child: BaseView<WinViewModel>(
        onModelReady: (model) {
          model.init();
        },
        onModelDispose: (model) {
          model.clear();
        },
        builder: (ctx, model, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: kToolbarHeight),
                const Salutation(),
                const AccountInfoTiles(
                  title: "Profile",
                  uri: "/profile",
                ),
                const AccountInfoTiles(
                  title: "KYC Details",
                  uri: "/kycVerify",
                ),
                const AccountInfoTiles(
                  title: "Bank Account Details",
                  uri: "/bankDetails",
                ),
                //Scratch Cards count and navigation
                const ScratchCardsInfoStrip(),
                //Current Winnings Information
                const CurrentWinningsInfo(),
                //Refer and Earn
                const ReferEarnCard(),
                // Referral Leaderboard
                const ReferralLeaderboard(),
                //Fello News
                FelloNewsComponent(model: model),
                // DEV PURPOSE ONLY
                const CacheClearWidget(),
                const SizedBox(height: 900),
              ],
            ),
          );
        },
      ),
    );
    //   },
    // );
  }
}
