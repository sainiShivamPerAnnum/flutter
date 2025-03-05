import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expertDetails/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expertDetails/bloc/rating_bloc.dart';
import 'package:felloapp/feature/expertDetails/widgets/rating_sheet.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/shared/marquee_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EaseInFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) {
    final curve = Curves.easeIn.transform(progress);
    return Offset.lerp(begin, end, curve)!;
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return CurvedAnimation(parent: parent, curve: Curves.easeIn);
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return CurvedAnimation(parent: parent, curve: Curves.easeIn);
  }
}

class ExpertsDetailsView extends StatelessWidget {
  final String advisorID;
  const ExpertsDetailsView({
    required this.advisorID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExpertDetailsBloc(
            locator(),
          )..add(LoadExpertsDetails(advisorID)),
        ),
        BlocProvider(
          create: (context) => RatingBloc(
            locator(),
          )..add(LoadRatings(advisorID)),
        ),
      ],
      child: _ExpertProfilePage(
        advisorID: advisorID,
      ),
    );
  }
}

class _ExpertProfilePage extends StatefulWidget {
  const _ExpertProfilePage({
    required this.advisorID,
  });
  final String advisorID;

  @override
  State<_ExpertProfilePage> createState() => _ExpertProfilePageState();
}

class _ExpertProfilePageState extends State<_ExpertProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _previousTabIndex = 0;
  final _analyticsService = locator<AnalyticsService>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _previousTabIndex) {
        BlocProvider.of<ExpertDetailsBloc>(context).add(
          TabChanged(_tabController.index, widget.advisorID),
        );
        _previousTabIndex = _tabController.index;
      }
    });
    _analyticsService.track(
      eventName: AnalyticsEvents.expertProfileView,
      properties: {
        "Expert ID": widget.advisorID,
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertDetailsBloc, ExpertDetailsState>(
      builder: (context, state) {
        if (state is LoadingExpertsDetails) {
          return const BaseScaffold(
            showBackgroundGrid: true,
            body: Center(child: FullScreenLoader()),
          );
        }
        if (state is ExpertDetailsLoaded) {
          final expertDetails = state.expertDetails;
          final isLoading = state.isLoading;
          final recentlive = state.recentLive;
          final shortsData = state.shortsData;
          return BaseScaffold(
            showBackgroundGrid: true,
            floatingActionButtonAnimator: EaseInFloatingActionButtonAnimator(),
            floatingActionButton: GestureDetector(
              onTap: () {
                BaseUtil.openBookAdvisorSheet(
                  advisorId: widget.advisorID,
                  advisorName: state.expertDetails?.name ?? '',
                  isEdit: false,
                );
                _analyticsService.track(
                  eventName: AnalyticsEvents.bookQuick,
                  properties: {
                    "Expert ID": widget.advisorID,
                    "Expert Name": state.expertDetails?.name ?? '',
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      SizeConfig.roundness5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding12,
                    vertical: SizeConfig.padding12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppImage(
                        Assets.book_call,
                        height: SizeConfig.body3,
                        color: UiConstants.kTextColor4,
                      ),
                      SizedBox(
                        width: SizeConfig.padding10,
                      ),
                      Text(
                        'Book a Slot',
                        style: TextStyles.sourceSansSB.body3.colour(
                          UiConstants.kTextColor4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: FAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              titleWidget: Text('Profile', style: TextStyles.rajdhaniSB.body1),
              leading: const BackButton(
                color: Colors.white,
              ),
              showAvatar: false,
              showCoinBar: false,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding20,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: SizeConfig.padding25,
                          ),
                          CircleAvatar(
                            radius: SizeConfig.padding35,
                            backgroundImage: NetworkImage(
                              expertDetails!.image,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding20,
                          ),
                          Text(
                            expertDetails.name,
                            style: TextStyles.sourceSansSB.body0.colour(
                              UiConstants.kTextColor,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding6,
                          ),
                          Text(
                            expertDetails.description,
                            style: TextStyles.sourceSansSB.body4.colour(
                              UiConstants.kTextColor.withOpacity(.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: SizeConfig.padding12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Experience',
                                    style: TextStyles.sourceSansSB.body6.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                  Text(
                                    expertDetails
                                        .experience, // Display experience
                                    style: TextStyles.sourceSansSB.body2.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Sessions',
                                    style: TextStyles.sourceSansSB.body6.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                  Text(
                                    expertDetails.sessionCount.toString(),
                                    style: TextStyles.sourceSansSB.body2.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Rating',
                                    style: TextStyles.sourceSansSB.body6.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                  Text(
                                    expertDetails.rating.toString(),
                                    style: TextStyles.sourceSansSB.body2.colour(
                                      UiConstants.kTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.padding32,
                          ),
                          CustomCarousel(
                            quickActions: expertDetails.QuickActions,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding20,
                      ),
                      sliver: SliverAppBar(
                        pinned: true,
                        toolbarHeight: 0,
                        backgroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        bottom: TabBar(
                          controller: _tabController,
                          indicatorPadding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: UiConstants.grey4,
                          indicatorWeight: 1.5,
                          indicatorColor: UiConstants.kTextColor,
                          labelColor: UiConstants.kTextColor,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          unselectedLabelColor:
                              UiConstants.kTextColor.withOpacity(.6),
                          labelStyle: TextStyles.sourceSansSB.body3,
                          unselectedLabelStyle: TextStyles.sourceSansSB.body3,
                          tabs: const [
                            Tab(text: "About"),
                            Tab(text: "Shorts"),
                            Tab(text: "Popular Live"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: isLoading
                  ? const FullScreenLoader()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: _buildInfoTab(
                            expertDetails!,
                            widget.advisorID,
                            context,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding8,
                          ),
                          child: _buildTabOneData(
                            shortsData,
                            expertDetails.name,
                            context,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: _buildLiveTab(recentlive, context),
                        ),
                      ],
                    ),
            ),
          );
        }
        return BaseScaffold(
          appBar: FAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            titleWidget: Text('Profile', style: TextStyles.rajdhaniSB.body1),
            leading: const BackButton(
              color: Colors.white,
            ),
            showAvatar: false,
            showCoinBar: false,
          ),
          body: NewErrorPage(
            onTryAgain: () {
              BlocProvider.of<ExpertDetailsBloc>(
                context,
                listen: false,
              ).add(
                LoadExpertsDetails(widget.advisorID),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _buildLiveTab(List<VideoData> recentlive, BuildContext context) {
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: EdgeInsets.only(top: SizeConfig.padding12),
      ),
      if (recentlive.isEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            width: SizeConfig.padding252,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.padding18),
                AppImage(
                  Assets.no_live,
                  height: SizeConfig.padding35,
                  width: SizeConfig.padding35,
                ),
                SizedBox(height: SizeConfig.padding12),
                Text(
                  'Currently, there are no live sessions available.',
                  style: TextStyles.sourceSansSB.body0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.padding10),
                Text(
                  'Book a one-on-one for personalized advice!',
                  style: TextStyles.sourceSans.body3.colour(
                    UiConstants.kTextColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final video = recentlive[index];
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                child: LiveCardWidget(
                  fromHome: false,
                  id: video.id,
                  status: 'recent',
                  maxWidth: SizeConfig.padding350,
                  onTap: () async {
                    final preloadBloc = BlocProvider.of<PreloadBloc>(context);
                    final switchCompleter = Completer<void>();

                    preloadBloc.add(
                      PreloadEvent.initializeLiveStream(
                        video,
                        completer: switchCompleter,
                      ),
                    );
                    await switchCompleter.future;
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: LiveShortsPageConfig,
                      state: PageState.addWidget,
                      widget: BaseScaffold(
                        appBar: FAppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          leadingPadding: false,
                          titleWidget: Expanded(
                            child: MarqueeText(
                              infoList: [
                                recentlive[index].title,
                              ],
                              showBullet: false,
                              style: TextStyles.rajdhaniSB.body1,
                            ),
                          ),
                          leading: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              AppState.backButtonDispatcher!.didPopRoute();
                            },
                          ),
                          showAvatar: false,
                          showCoinBar: false,
                          action: BlocBuilder<PreloadBloc, PreloadState>(
                            builder: (context, preloadState) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<PreloadBloc>(
                                      context,
                                      listen: false,
                                    ).add(
                                      const PreloadEvent.toggleVolume(),
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: SizedBox(
                                    height: 24.r,
                                    width: 24.r,
                                    child: Icon(
                                      !preloadState.muted
                                          ? Icons.volume_up_rounded
                                          : Icons.volume_off_rounded,
                                      size: 21.r,
                                      color: UiConstants.kTextColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        body: const ShortsVideoPage(
                          categories: [],
                        ),
                      ),
                    );
                  },
                  title: video.title,
                  startTime: video.timeStamp,
                  subTitle: video.subtitle,
                  author: video.author,
                  advisorId: video.advisorId,
                  category: video.category?.join(', ') ?? '',
                  bgImage: video.thumbnail,
                  liveCount: video.views.toInt(),
                  duration: video.duration.toString(),
                ),
              );
            },
            childCount: recentlive.length,
          ),
        ),
    ],
  );
}

Widget _buildInfoTab(
  ExpertDetails expertDetails,
  String advisorID,
  BuildContext context,
) {
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: SizedBox(
          height: SizeConfig.padding12,
        ),
      ),
      SliverToBoxAdapter(
        child: Text(
          "Licenses",
          style: TextStyles.sourceSansSB.body2,
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: SizeConfig.padding18,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final license = expertDetails.licenses[index];
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.padding8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.padding46,
                    height: SizeConfig.padding46,
                    decoration: BoxDecoration(
                      color: UiConstants.greyVarient,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                    ),
                    child: Center(
                      child: Image.network(
                        license.imageUrl,
                        width: SizeConfig.padding46,
                        height: SizeConfig.padding46,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          license.name,
                          style: TextStyles.sourceSansSB.body3,
                        ),
                        SizedBox(height: SizeConfig.padding2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Issued on ${DateFormat('MMMM d, y').format(license.issueDate)}",
                              style: TextStyles.sourceSansSB.body3.colour(
                                UiConstants.kTextColor.withOpacity(.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                BaseUtil.launchUrl(license.credentials);
                                BlocProvider.of<ExpertDetailsBloc>(context).add(
                                  GetCertificate(license.id, advisorID),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View Credentials",
                                    style: TextStyles.sourceSans.body4
                                        .colour(Colors.white70)
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white70,
                                          decorationThickness: 1,
                                        ),
                                  ),
                                  SizedBox(width: SizeConfig.padding4),
                                  Icon(
                                    Icons.open_in_new,
                                    color: Colors.white70,
                                    size: SizeConfig.body6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: expertDetails.licenses.length,
        ),
      ),
      if (expertDetails.social.isNotEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding24,
          ),
        ),
      if (expertDetails.social.isNotEmpty)
        SliverToBoxAdapter(
          child: Text(
            "Social",
            style: TextStyles.sourceSansSB.body2,
          ),
        ),
      if (expertDetails.social.isNotEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            height: SizeConfig.padding18,
          ),
        ),
      SliverToBoxAdapter(
        child: Row(
          children: expertDetails.social.map((social) {
            return GestureDetector(
              onTap: () {
                BaseUtil.launchUrl(social.url);
              },
              child: Container(
                padding: EdgeInsets.all(SizeConfig.padding14),
                margin: EdgeInsets.only(
                  right: SizeConfig.padding4,
                ),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.roundness8,
                  ),
                ),
                child: AppImage(
                  social.icon,
                  color: UiConstants.kTextColor5,
                  height: SizeConfig.body2,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: SizeConfig.padding24,
        ),
      ),
      SliverToBoxAdapter(
        child: RatingReviewSection(
          ratingInfo: expertDetails.ratingInfo,
          advisorId: advisorID,
        ),
      ),
    ],
  );
}

Widget _buildTabOneData(
  List<VideoData> shortsData,
  String name,
  BuildContext context,
) {
  return CustomScrollView(
    slivers: [
      if (shortsData.isEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            width: SizeConfig.padding252,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.padding30),
                AppImage(
                  Assets.no_shorts,
                  height: SizeConfig.padding35,
                  width: SizeConfig.padding35,
                ),
                SizedBox(height: SizeConfig.padding12),
                Text(
                  '$name hasn’t shared any shorts yet',
                  style: TextStyles.sourceSansSB.body0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.padding10),
                Text(
                  'Book a session to get personal advice directly from them!',
                  style: TextStyles.sourceSans.body3.colour(
                    UiConstants.kTextColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      SliverPadding(
        padding: EdgeInsets.only(top: SizeConfig.padding12),
      ),
      SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final video = shortsData[index];
            return GestureDetector(
              onTap: () async {
                final preloadBloc = BlocProvider.of<PreloadBloc>(context);
                final switchCompleter = Completer<void>();
                final updateUrlsCompleter = Completer<void>();
                final initializeCompleter = Completer<void>();

                preloadBloc.add(
                  PreloadEvent.switchToProfileReels(completer: switchCompleter),
                );
                await switchCompleter.future;
                preloadBloc.add(
                  PreloadEvent.updateUrls(
                    shortsData,
                    completer: updateUrlsCompleter,
                  ),
                );
                await updateUrlsCompleter.future;
                preloadBloc.add(
                  PreloadEvent.initializeAtIndex(
                    index: index,
                    completer: initializeCompleter,
                  ),
                );
                await initializeCompleter.future;
                preloadBloc.add(PreloadEvent.playVideoAtIndex(index));

                AppState.delegate!.appState.currentAction = PageAction(
                  page: ProfileShortsPageConfig,
                  state: PageState.addWidget,
                  widget: BaseScaffold(
                    appBar: FAppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      titleWidget:
                          Text('Profile', style: TextStyles.rajdhaniSB.body1),
                      leading: BackButton(
                        color: Colors.white,
                        onPressed: () {
                          AppState.backButtonDispatcher!.didPopRoute();
                        },
                      ),
                      showAvatar: false,
                      showCoinBar: false,
                      action: BlocBuilder<PreloadBloc, PreloadState>(
                        builder: (context, preloadState) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<PreloadBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  const PreloadEvent.toggleVolume(),
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: SizedBox(
                                height: 24.r,
                                width: 24.r,
                                child: Icon(
                                  !preloadState.muted
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_off_rounded,
                                  size: 21.r,
                                  color: UiConstants.kTextColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    body: const ShortsVideoPage(
                      categories: [],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: UiConstants.greyVarient,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness2),
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.padding8,
                    left: SizeConfig.padding4,
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: UiConstants.kTextColor,
                          size: SizeConfig.body2,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        Text(
                          '${video.views}',
                          style: TextStyles.sourceSansSB.body4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: shortsData.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: SizeConfig.padding4,
          mainAxisSpacing: SizeConfig.padding4,
          childAspectRatio: 0.6,
        ),
      ),
    ],
  );
}

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({required this.quickActions, super.key});
  final List<QuickAction> quickActions;

  @override
  CustomCarouselState createState() => CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.padding60,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: widget.quickActions.map((e) {
              return buildCarouselItem(
                e.heading,
                e.subheading,
                e.buttonText,
                onTap: () {
                  AppState.delegate!.parseRoute(Uri.parse(e.buttonCTA));
                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.bookQuick,
                  );
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        if (widget.quickActions.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.quickActions.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding4,
                  vertical: SizeConfig.padding8,
                ),
                width: SizeConfig.padding4,
                height: SizeConfig.padding4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.white : Colors.grey,
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget buildCarouselItem(
    String title,
    String description,
    String btnTxt, {
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding18,
        vertical: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyles.sourceSansSB.body6.colour(
                  UiConstants.kTabBorderColor,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                description,
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding6,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  SizeConfig.roundness5,
                ),
              ),
              child: Text(
                btnTxt,
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingReviewSection extends StatelessWidget {
  final RatingInfo ratingInfo;
  final String advisorId;

  const RatingReviewSection({
    required this.ratingInfo,
    required this.advisorId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
        return switch (state) {
          LoadingRatingDetails() ||
          UploadingRatingDetails() =>
            const FullScreenLoader(),
          RatingDetailsLoaded() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ratings & Reviews',
                  style: TextStyles.sourceSansSB.body2,
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                Row(
                  children: [
                    Text(
                      ratingInfo.overallRating.toStringAsFixed(1),
                      style: TextStyles.sourceSansSB.title2,
                    ),
                    SizedBox(
                      width: SizeConfig.padding10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          initialRating: ratingInfo.overallRating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          glow: false,
                          ignoreGestures: true,
                          unratedColor: Colors.grey,
                          itemSize: SizeConfig.body6,
                          itemPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding1,
                          ),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: SizeConfig.body6,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        Text(
                          '${ratingInfo.ratingCount} ratings',
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kTextColor.withOpacity(.7)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        AppState.screenStack.add(ScreenItem.modalsheet);
                        BaseUtil.openModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          isBarrierDismissible: true,
                          addToScreenStack: false,
                          content: FeedbackBottomSheet(
                            advisorId: advisorId,
                            onSubmit: (rating, comment) {
                              BlocProvider.of<RatingBloc>(
                                context,
                                listen: false,
                              ).add(
                                PostRating(
                                  advisorId: advisorId,
                                  rating: rating,
                                  comments: comment,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size(0, 0),
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding18,
                            vertical: SizeConfig.padding6,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          const BorderSide(
                            color: UiConstants.kTextColor,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness5),
                            ),
                            side: const BorderSide(
                              color: UiConstants.kTextColor,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        'Rate',
                        style: TextStyles.sourceSansSB.body4
                            .colour(UiConstants.kTextColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding32),
                Column(
                  children: (state.userRatings ?? [])
                      .take(
                    state.viewMore ? (state.userRatings ?? []).length : 2,
                  )
                      .map((userRating) {
                    return ReviewCard(
                      name: userRating.userName,
                      date: userRating.createdAt,
                      rating: userRating.rating,
                      review: userRating.comments,
                      image: userRating.avatarId,
                    );
                  }).toList(),
                ),
                if (state.userRatings != null && state.userRatings!.length > 2)
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<RatingBloc>(
                        context,
                        listen: false,
                      ).add(
                        ViewMoreClicked(
                          !state.viewMore,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.viewMore ? 'View Less' : 'View All',
                          style: TextStyles.sourceSansSB.body4,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: SizeConfig.padding20),
              ],
            )
        };
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final num rating;
  final String review;
  final String image;

  const ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: SizeConfig.padding16,
              child: AppImage(
                "assets/vectors/userAvatars/$image.svg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: SizeConfig.padding8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.sourceSansSB.body3.colour(
                    UiConstants.kTextColor,
                  ),
                ),
                Text(
                  BaseUtil.formatDateTime2(
                    DateTime.tryParse(date) ?? DateTime.now(),
                  ),
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        RatingBar.builder(
          initialRating: rating.toDouble(),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glow: false,
          ignoreGestures: true,
          itemSize: SizeConfig.body6,
          unratedColor: Colors.grey,
          itemPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: SizeConfig.body6,
          ),
          onRatingUpdate: (rating) {},
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        if (review != '')
          Text(
            review,
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.kTextColor.withOpacity(.7),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: review != '' ? SizeConfig.padding16 : SizeConfig.padding4,
          ),
          child: Divider(
            color: UiConstants.kTextColor.withOpacity(.11),
          ),
        ),
      ],
    );
  }
}
