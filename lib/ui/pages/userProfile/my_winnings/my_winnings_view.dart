import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MyWinningsView extends StatelessWidget {
  const MyWinningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: UiConstants.kTambolaMidTextColor,
          ),
          child: Consumer<ScratchCardService>(
            builder: (context, gtmodel, child) {
              return BaseScaffold(
                showBackgroundGrid: false,
                backgroundColor: UiConstants.bg,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  leading: const BackButton(color: UiConstants.kTextColor),
                  title: Text(
                    'Fello Reward Points',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyles.rajdhaniSB.body1
                        .colour(UiConstants.kTextColor),
                  ),
                ),
                body: model.state.isBusy
                    ? const Center(
                        child: FullScreenLoader(),
                      )
                    : Stack(
                        children: [
                          SafeArea(
                            child: RefreshIndicator(
                              backgroundColor: Colors.black,
                              onRefresh: () async {
                                model.init();
                                await locator<UserService>()
                                    .getUserFundWalletData();
                                return Future.value(null);
                              },
                              notificationPredicate: (notification) {
                                return notification.depth == 2;
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const PrizeClaimCard(),
                                    gtmodel.isFetchingScratchCards &&
                                            gtmodel.allScratchCards.isEmpty
                                        ? const Center(
                                            child: FullScreenLoader(),
                                          )
                                        : gtmodel.allScratchCards.isEmpty
                                            ? const NoScratchCardsFound()
                                            : ScratchCardsView(model: gtmodel),
                                  ],
                                ),
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
                                        padding: EdgeInsets.all(
                                          SizeConfig.padding12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SpinKitWave(
                                              color: UiConstants.primaryColor,
                                              size: SizeConfig.padding16,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.padding4,
                                            ),
                                            Text(
                                              locale.loadingScratchCards,
                                              style: TextStyles.body4
                                                  .colour(Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
