import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/rewards/earn_rewards/rewards_details.dart';
import 'package:felloapp/ui/pages/rewards/earn_rewards/rewards_intro.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
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

class MyWinningsView extends StatefulWidget {
  final openFirst;
  // final WinViewModel winModel;

  const MyWinningsView({this.openFirst = false, Key? key}) : super(key: key);

  @override
  State<MyWinningsView> createState() => _MyWinningsViewState();
}

class _MyWinningsViewState extends State<MyWinningsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  child: SafeArea(
                    child: RefreshIndicator.adaptive(
                      backgroundColor: Colors.black,
                      onRefresh: () async {
                        model.init();
                        await locator<UserService>().getUserFundWalletData();
                        return Future.value(null);
                      },
                      child: NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          return <Widget>[
                            SliverAppBar(
                              backgroundColor: UiConstants.kTambolaMidTextColor,
                              centerTitle: false,
                              title: Text(
                                "Scratch Cards",
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
                              child: SizedBox(height: SizeConfig.padding24),
                            ),
                            SliverAppBar(
                              pinned: true,
                              toolbarHeight: 0,
                              bottom: ColoredTabBar(
                                UiConstants.kBackgroundColor,
                                TabBar(
                                  controller: _tabController,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorWeight: SizeConfig.padding4,
                                  labelColor: Colors.white,
                                  isScrollable: false,
                                  onTap: (value) {
                                    setState(() {});
                                  },
                                  tabs: [
                                    Tab(
                                        child: Text(
                                      'Your Rewards',
                                      style: TextStyles.sourceSansSB.body1,
                                    )),
                                    Tab(
                                        child: Text(
                                      'Earn Rewards',
                                      style: TextStyles.sourceSansSB.body1,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Consumer<ScratchCardService>(
                            builder: (context, model, child) {
                          if (!model.isFetchingScratchCards &&
                              model.allScratchCards.isEmpty &&
                              _tabController.previousIndex == 0) {
                            _tabController.animateTo(1,
                                curve: Curves.easeInOut);
                          }
                          return model.isFetchingScratchCards &&
                                  model.allScratchCards.isEmpty
                              ? const Center(child: FullScreenLoader())
                              : TabBarView(
                                  controller: _tabController,
                                  children: [
                                    const ScratchCardsView(),
                                    model.allScratchCards.isNotEmpty
                                        ? const EarnRewardsDetails()
                                        : const EarnRewardsIntro(),
                                  ],
                                );
                        }),
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

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar, {super.key});

  @override
  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
