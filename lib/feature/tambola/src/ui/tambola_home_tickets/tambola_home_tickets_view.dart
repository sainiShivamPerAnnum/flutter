import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/tambola_offers_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_tutorial_slot_machine_view.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/tambola_home_tickets_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/tickets_home/components/tickets_picks_widget.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/buy_ticket_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/next_week_info_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/past_week_winners_section.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_section.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/walkthrough_video_section.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TambolaHomeTicketsView extends StatefulWidget {
  const TambolaHomeTicketsView({
    Key? key,
  }) : super(key: key);

  @override
  State<TambolaHomeTicketsView> createState() => _TambolaHomeTicketsViewState();
}

class _TambolaHomeTicketsViewState extends State<TambolaHomeTicketsView> {
  ScrollController? _scrollController;
  final GlobalKey<AnimatedBuyTambolaTicketCardState> tambolaBuyTicketCardKey =
      GlobalKey<AnimatedBuyTambolaTicketCardState>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeTicketsViewModel>(
        onModelReady: (model) => model.init(),
        onModelDispose: (model) => model.dispose(),
        builder: (context, model, child) {
          return model.state == ViewState.Busy
              ? const Center(
                  child: FullScreenLoader(),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.padding16),
                          //1 Cr Lottie
                          TambolaRewardLottieStrip(),
                          //Weekly/Daily Picks Card
                          // const TodayWeeklyPicksCard(),
                          const TicketsPicksWidget(),
                          //Tickets Section
                          const TicketSection(),

                          const NextWeekTicketInfo(),
                          const TicketsOffersSection(),
                          const TicketMultiplierOptionsWidget(),
                          TicketsRewardCategoriesWidget(
                              color: UiConstants.kTambolaMidTextColor,
                              highlightRow: false),
                          const TambolaVideosSection(),
                          const TambolaLeaderboardView(),
                          // LottieBuilder.network(Assets.bottomBannerLottie),
                          SizedBox(height: SizeConfig.navBarHeight),
                        ],
                      ),
                    ),
                  ],
                );
        });
  }
}

class TicketsOffersSection extends StatelessWidget {
  const TicketsOffersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, List<TicketsOffers>?>(
      selector: (p0, p1) => p1.ticketsOffers,
      builder: (context, offers, child) {
        return (offers ?? []).isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSubtitleContainer(
                      title: "How Tickets Work",
                      padding: EdgeInsets.only(
                          top: SizeConfig.padding12,
                          left: SizeConfig.pageHorizontalMargins,
                          right: SizeConfig.pageHorizontalMargins,
                          bottom: SizeConfig.padding12)),
                  SizedBox(
                    height: SizeConfig.screenWidth! * 0.36,
                    child: ListView.builder(
                      itemCount: offers!.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins -
                              SizeConfig.padding10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () {
                          AppState.delegate!
                              .parseRoute(Uri.parse(offers[i].deep_uri));
                        },
                        child: Container(
                          height: SizeConfig.padding128,
                          width: SizeConfig.screenWidth! -
                              SizeConfig.pageHorizontalMargins * 2,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding10),
                          child: getChild(offers[i].image),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding10)
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget getChild(String asset) {
    final String ext = asset.split('.').last;

    if (ext == "svg") {
      return SvgPicture.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.cover,
      );
    } else if (ext == "json") {
      return Lottie.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.contain,
      );
    } else {
      return Image.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.cover,
      );
    }
  }
}

class TicketMultiplierOptionsWidget extends StatelessWidget {
  const TicketMultiplierOptionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Tuple2<int, int>> multipliers = [
      const Tuple2(
        12,
        5,
      ),
      const Tuple2(10, 3),
      const Tuple2(8, 1),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
          title: "Tickets Multiplier",
          leadingPadding: true,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding12,
              horizontal: SizeConfig.pageHorizontalMargins),
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.36,
          child: ListView.builder(
            itemCount: multipliers.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins - SizeConfig.padding10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) => (multipliers[i].item1 == 8 &&
                    locator<UserService>()
                        .userSegments
                        .contains(Constants.US_FLO_OLD))
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      switch (multipliers[i].item1) {
                        case 12:
                          return BaseUtil.openFloBuySheet(
                              floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6);
                        case 10:
                          return locator<UserService>()
                                  .userSegments
                                  .contains(Constants.US_FLO_OLD)
                              ? BaseUtil.openFloBuySheet(
                                  floAssetType: Constants.ASSET_TYPE_FLO_FELXI)
                              : BaseUtil.openFloBuySheet(
                                  floAssetType:
                                      Constants.ASSET_TYPE_FLO_FIXED_3);
                        case 8:
                          return BaseUtil.openFloBuySheet(
                              floAssetType: Constants.ASSET_TYPE_FLO_FELXI);
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                      ),
                      color: UiConstants.kSaveStableFelloCardBg,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            child: SizedBox(
                              height: SizeConfig.screenWidth! * 0.36,
                              width: SizeConfig.screenWidth! * 0.33,
                              child: const GoldShimmerWidget(
                                size: ShimmerSizeEnum.medium,
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! * 0.33,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding16,
                                vertical: SizeConfig.padding10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '${multipliers[i].item1}%',
                                            style: TextStyles
                                                .sourceSansSB.title4
                                                .colour(Colors.white)),
                                        TextSpan(
                                            text: ' Flo',
                                            style: TextStyles.sourceSans.body3
                                                .colour(Colors.white)),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Get",
                                        style: TextStyles.body4
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: SvgPicture.asset(
                                                Assets.singleTambolaTicket,
                                                width: SizeConfig.padding20,
                                              ),
                                            ),
                                            TextSpan(
                                                text:
                                                    '  ${multipliers[i].item2}X tickets',
                                                style: TextStyles
                                                    .sourceSansB.body2
                                                    .colour(UiConstants
                                                        .kSelectedDotColor)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text(
                                        "on saving",
                                        style: TextStyles.body4
                                            .colour(Colors.white),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: SizeConfig.padding10)
      ],
    );
  }
}

class TambolaRewardLottieStrip extends StatefulWidget {
  TambolaRewardLottieStrip({
    super.key,
  });

  @override
  State<TambolaRewardLottieStrip> createState() =>
      _TambolaRewardLottieStripState();
}

class _TambolaRewardLottieStripState extends State<TambolaRewardLottieStrip> {
  final List<String> _goldMarquee = [
    'Get more tickets now',
    'Know how Tickets work',
    'Know about Ticket Rewards',
  ];

  final List<String> icon = [
    Assets.tambolaCardAsset,
    'assets/svg/trophy_banner.svg',
    'assets/svg/question.svg',
  ];

  void onTap(int index) {
    switch (index) {
      case 0:
        AppState.delegate!.appState.currentAction = PageAction(
          page: AssetSelectionViewConfig,
          state: PageState.addWidget,
          widget: const AssetSelectionPage(
            showOnlyFlo: false,
          ),
        );
        break;
      case 1:
      case 2:
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: TambolaNewUser,
          widget: TambolaHomeDetailsView(
            isStandAloneScreen: true,
            showPrizeSection: index == 2,
            showBottomButton: false,
            showDemoImage: false,
          ),
        );
        break;
    }
  }

  late final PageController _controller = PageController(initialPage: 0);

  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentPage < 3) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_controller.hasClients) {
          _controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kFloContainerColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      margin: EdgeInsets.only(
        bottom: SizeConfig.padding10,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
      ),
      height: SizeConfig.padding48,
      width: SizeConfig.screenWidth,
      child: PageView.builder(
        controller: _controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.tambolaCarousel,
                  properties: {
                    'order': index + 1,
                  });
              onTap(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10,
                  vertical: SizeConfig.padding12),
              child: Row(
                children: [
                  SizedBox(
                    height: SizeConfig.padding26,
                    width: SizeConfig.padding32,
                    child: SvgPicture.asset(
                      icon[index],
                      height: SizeConfig.padding26,
                      width: SizeConfig.padding32,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  Text(_goldMarquee[index],
                      style: TextStyles.rajdhaniSB.body0.colour(Colors.white)),
                  const Spacer(),
                  SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: UiConstants.primaryColor,
                    height: SizeConfig.padding24,
                    width: SizeConfig.padding24,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
