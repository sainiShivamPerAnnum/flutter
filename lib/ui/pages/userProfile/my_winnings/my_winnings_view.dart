import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MyWinningsView extends StatelessWidget {
  final openFirst;
  // final WinViewModel winModel;

  const MyWinningsView({this.openFirst = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: UiConstants.kTambolaMidTextColor,
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                const NewSquareBackground(),
                NotificationListener<ScrollEndNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent) {
                      model.fetchMoreCards();
                    }

                    return true;
                  },
                  child: RefreshIndicator(
                    backgroundColor: Colors.black,
                    onRefresh: () async {
                      model.init();
                      await locator<UserService>().getUserFundWalletData();
                      return Future.value(null);
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins,
                          ),
                          color: UiConstants.kTambolaMidTextColor,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  AppState.backButtonDispatcher!.didPopRoute();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.padding20,
                              ),
                              Text(
                                "Scratch Cards",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style:
                                    TextStyles.title4.bold.colour(Colors.white),
                              ),
                              const Spacer(),
                              const FaqPill(
                                type: FaqsType.rewards,
                              )
                            ],
                          ),
                        ),
                        const PrizeClaimCard(),
                        const ScratchCardsView(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Consumer<ScratchCardService>(
                      builder: (context, service, properties) {
                    return service.isFetchingScratchCards &&
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
                        : const SizedBox();
                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
