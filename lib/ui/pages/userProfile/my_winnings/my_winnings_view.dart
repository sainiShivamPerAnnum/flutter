import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/rewards/earn_rewards/rewards_details.dart';
import 'package:felloapp/ui/pages/rewards/earn_rewards/rewards_intro.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
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
          child:
              Consumer<ScratchCardService>(builder: (context, gtmodel, child) {
            final initialIndex =
                !model.state.isBusy && gtmodel.allScratchCards.isEmpty ? 1 : 0;
            return model.state.isBusy
                ? Scaffold(
                    appBar: AppBar(
                      backgroundColor: UiConstants.kTambolaMidTextColor,
                      centerTitle: false,
                      title: Text(
                        locale.scratchCardText,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyles.rajdhaniSB.title5
                            .colour(UiConstants.kTextColor),
                      ),
                    ),
                    backgroundColor: UiConstants.kBackgroundColor,
                    body: const Center(child: FullScreenLoader()))
                : DefaultTabController(
                    length: 2,
                    initialIndex: initialIndex,
                    child: Scaffold(
                      backgroundColor: UiConstants.kBackgroundColor,
                      body: Stack(
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
                              child: NestedScrollView(
                                headerSliverBuilder: (context, value) {
                                  return <Widget>[
                                    SliverAppBar(
                                      elevation: 0,
                                      toolbarHeight: 54,
                                      backgroundColor:
                                          UiConstants.kTambolaMidTextColor,
                                      centerTitle: false,
                                      title: Text(
                                        locale.scratchCardText,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyles.rajdhaniSB.title5
                                            .colour(UiConstants.kTextColor),
                                      ),
                                    ),
                                    const SliverToBoxAdapter(
                                      child: PrizeClaimCard(),
                                    ),
                                    SliverToBoxAdapter(
                                      child: SizedBox(
                                          height: SizeConfig.padding24),
                                    ),
                                    SliverOverlapAbsorber(
                                      handle: NestedScrollView
                                          .sliverOverlapAbsorberHandleFor(
                                              context),
                                      sliver: SliverAppBar(
                                        pinned: true,
                                        toolbarHeight: 0,
                                        backgroundColor:
                                            UiConstants.kBackgroundColor,
                                        bottom: TabBar(
                                          indicatorColor: Colors.white,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          indicatorWeight: SizeConfig.padding4,
                                          labelColor: Colors.white,
                                          isScrollable: false,
                                          onTap: (value) {
                                            model.trackTabClicked(value == 0
                                                ? 'Your Rewards'
                                                : 'Earn Rewards');
                                          },
                                          tabs: [
                                            Tab(
                                                child: Text(
                                              locale.sctab1,
                                              style:
                                                  TextStyles.sourceSansSB.body1,
                                            )),
                                            Tab(
                                                child: Text(
                                              locale.sctab2,
                                              style:
                                                  TextStyles.sourceSansSB.body1,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                                body: TabBarView(
                                  children: [
                                    Builder(builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                            handle: NestedScrollView
                                                .sliverOverlapAbsorberHandleFor(
                                                    context),
                                          ),
                                          const SliverToBoxAdapter(
                                            child: ScratchCardsView(),
                                          )
                                        ],
                                      );
                                    }),
                                    Builder(builder: (context) {
                                      return CustomScrollView(
                                        slivers: [
                                          SliverOverlapInjector(
                                            handle: NestedScrollView
                                                .sliverOverlapAbsorberHandleFor(
                                                    context),
                                          ),
                                          SliverToBoxAdapter(
                                            child: gtmodel
                                                    .allScratchCards.isNotEmpty
                                                ? EarnRewardsDetails(
                                                    model: model,
                                                    gtService: gtmodel,
                                                  )
                                                : EarnRewardsIntro(
                                                    model: model,
                                                    gtService: gtmodel,
                                                  ),
                                          )
                                        ],
                                      );
                                    }),
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
                                      padding:
                                          EdgeInsets.all(SizeConfig.padding12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SpinKitWave(
                                            color: UiConstants.primaryColor,
                                            size: SizeConfig.padding16,
                                          ),
                                          SizedBox(height: SizeConfig.padding4),
                                          Text(
                                            locale.loadingScratchCards,
                                            style: TextStyles.body4
                                                .colour(Colors.grey),
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
          }),
        );
      },
    );
  }
}
