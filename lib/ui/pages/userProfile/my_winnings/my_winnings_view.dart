import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MyWinningsView extends StatelessWidget {
  final openFirst;
  // final WinViewModel winModel;

  MyWinningsView({this.openFirst = false});
  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              locale.winRewardsTitle,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyles.title4.bold.colour(Colors.white),
            ),
            elevation: 0.0,
            backgroundColor: UiConstants.kBackgroundColor,
            leading: IconButton(
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: UiConstants.kBackgroundColor,
          body: Stack(
            children: [
              NewSquareBackground(),
              NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent) {
                    print("Max extent reached");
                    model.fetchMoreCards();
                  }

                  return true;
                },
                child: RefreshIndicator(
                  backgroundColor: Colors.black,
                  onRefresh: () async {
                    await model.init();
                    return Future.value(true);
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      PrizeClaimCard(),
                      ScratchCardsView(),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: PropertyChangeConsumer<ScratchCardService,
                        ScratchCardServiceProperties>(
                    properties: [ScratchCardServiceProperties.AllScratchCards],
                    builder: (context, service, properties) {
                      return service!.isFetchingScratchCards &&
                              service.allScratchCards.isNotEmpty
                          ? Container(
                              color: UiConstants.kBackgroundColor3,
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.all(SizeConfig.padding12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SpinKitWave(
                                    color: UiConstants.primaryColor,
                                    size: SizeConfig.padding16,
                                  ),
                                  SizedBox(height: SizeConfig.padding4),
                                  Text(
                                    "Loading more tickets",
                                    style: TextStyles.body4.colour(Colors.grey),
                                  )
                                ],
                              ),
                            )
                          : SizedBox();
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
