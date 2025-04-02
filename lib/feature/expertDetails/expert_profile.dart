import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/feature/expert/widgets/expert_card_v2.dart';
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
import 'package:felloapp/util/local_actions_state.dart';
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
            showBackgroundGrid: false,
            backgroundColor: UiConstants.bg,
            body: Center(child: FullScreenLoader()),
          );
        }
        if (state is ExpertDetailsLoaded) {
          final expertDetails = state.expertDetails;
          final isLoading = state.isLoading;
          final recentlive = state.recentLive;
          final shortsData = state.shortsData;
          return BaseScaffold(
            showBackgroundGrid: false,
            backgroundColor: UiConstants.bg,
            floatingActionButtonAnimator: EaseInFloatingActionButtonAnimator(),
            floatingActionButton: GestureDetector(
              onTap: () {
                BaseUtil.openBookAdvisorSheet(
                  advisorId: widget.advisorID,
                  advisorName: state.expertDetails?.name ?? '',
                  advisorImage: state.expertDetails?.image ?? '',
                  isEdit: false,
                );
                context.read<CartBloc>().add(
                      AddToCart(
                        advisor: Expert(
                          advisorId: widget.advisorID,
                          name: state.expertDetails!.name,
                          experience: state.expertDetails!.experience,
                          rating: state.expertDetails!.rating,
                          expertise: '',
                          qualifications: '',
                          rate: 0,
                          rateNew: '',
                          image: state.expertDetails!.image,
                          isFree: false,
                        ),
                      ),
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
                    Radius.circular(5.r),
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
                      horizontal: 20.w,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          GestureDetector(
                            onTap: expertDetails!.shorts.isEmpty
                                ? null
                                : () async {
                                    final preloadBloc =
                                        BlocProvider.of<PreloadBloc>(context);
                                    final switchCompleter = Completer<void>();
                                    final updateUrlsCompleter =
                                        Completer<void>();
                                    final initializeCompleter =
                                        Completer<void>();

                                    preloadBloc.add(
                                      PreloadEvent.switchToProfileReels(
                                          completer: switchCompleter),
                                    );
                                    await switchCompleter.future;
                                    preloadBloc.add(
                                      PreloadEvent.updateUrls(
                                        expertDetails.shorts,
                                        completer: updateUrlsCompleter,
                                      ),
                                    );
                                    await updateUrlsCompleter.future;
                                    preloadBloc.add(
                                      PreloadEvent.initializeAtIndex(
                                        index: 0,
                                        completer: initializeCompleter,
                                      ),
                                    );
                                    await initializeCompleter.future;
                                    preloadBloc.add(
                                      const PreloadEvent.playVideoAtIndex(0),
                                    );

                                    AppState.delegate!.appState.currentAction =
                                        PageAction(
                                      page: ProfileShortsPageConfig,
                                      state: PageState.addWidget,
                                      widget: BaseScaffold(
                                        showBackgroundGrid: false,
                                        backgroundColor: UiConstants.bg,
                                        appBar: FAppBar(
                                          backgroundColor: Colors.transparent,
                                          centerTitle: true,
                                          titleWidget: Text(
                                            'Introduction',
                                            style: TextStyles.rajdhaniSB.body1,
                                          ),
                                          leading: BackButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              AppState.backButtonDispatcher!
                                                  .didPopRoute();
                                            },
                                          ),
                                          showAvatar: false,
                                          showCoinBar: false,
                                          action: BlocBuilder<PreloadBloc,
                                              PreloadState>(
                                            builder: (context, preloadState) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  right: 10.w,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                        PreloadBloc>(
                                                      context,
                                                      listen: false,
                                                    ).add(
                                                      const PreloadEvent
                                                          .toggleVolume(),
                                                    );
                                                  },
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  child: SizedBox(
                                                    height: 24.r,
                                                    width: 24.r,
                                                    child: Icon(
                                                      !preloadState.muted
                                                          ? Icons
                                                              .volume_up_rounded
                                                          : Icons
                                                              .volume_off_rounded,
                                                      size: 21.r,
                                                      color: UiConstants
                                                          .kTextColor,
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
                              alignment: Alignment.topCenter,
                              children: [
                                SizedBox(
                                  width: 85.r,
                                  height: 85.r,
                                  child: introVideosIndicator(
                                    expertDetails.shorts,
                                    context,
                                  ),
                                ),
                                ClipOval(
                                  child: SizedBox(
                                    width: 80.r,
                                    height: 80.r,
                                    child: AppImage(
                                      expertDetails.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (expertDetails.shorts.isNotEmpty)
                                  Transform.translate(
                                    offset: Offset(0, -15.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 9.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: UiConstants.bg,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.r),
                                        ),
                                        border: Border.all(
                                          color: UiConstants.grey6,
                                          width: 1.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Click to know',
                                        style: TextStyles.sourceSansM.body4,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            expertDetails.name,
                            style: TextStyles.sourceSansSB.body0.colour(
                              UiConstants.kTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                            expertDetails.description,
                            style: TextStyles.sourceSansSB.body4.colour(
                              UiConstants.kTextColor.withOpacity(.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 12.h,
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
                            height: 26.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ExpertDetailsBloc>(
                                      context,
                                      listen: false,
                                    ).add(
                                      FollowAdvisor(
                                        widget.advisorID,
                                        LocalActionsState.getAdvisorFollowed(
                                          widget.advisorID,
                                          expertDetails.isFollowed,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.kProfileBorderColor
                                          .withOpacity(.06),
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                        color: UiConstants.kTextColor6
                                            .withOpacity(.1),
                                        width: 2.w,
                                      ),
                                    ),
                                    child: LocalActionsState.getAdvisorFollowed(
                                      widget.advisorID,
                                      expertDetails.isFollowed,
                                    )
                                        ? Text(
                                            'Following',
                                            style:
                                                TextStyles.sourceSansSB.body4,
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            'Follow',
                                            style:
                                                TextStyles.sourceSansSB.body4,
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                          AddToCart(
                                            advisor: Expert(
                                              advisorId: widget.advisorID,
                                              name: state.expertDetails!.name,
                                              experience: state
                                                  .expertDetails!.experience,
                                              rating:
                                                  state.expertDetails!.rating,
                                              expertise: '',
                                              qualifications: '',
                                              rate: 0,
                                              rateNew: '',
                                              image: state.expertDetails!.image,
                                              isFree: false,
                                            ),
                                          ),
                                        );
                                    BaseUtil.openBookAdvisorSheet(
                                      advisorId: widget.advisorID,
                                      advisorName:
                                          state.expertDetails?.name ?? '',
                                      advisorImage:
                                          state.expertDetails?.image ?? '',
                                      isEdit: false,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.kProfileBorderColor
                                          .withOpacity(.06),
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                        color: UiConstants.kTextColor6
                                            .withOpacity(.1),
                                        width: 2.w,
                                      ),
                                    ),
                                    child: Text(
                                      'Book a Call',
                                      style: TextStyles.sourceSansSB.body4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
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
                        horizontal: 20.w,
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
                  : IndexedStack(
                      index: _tabController.index,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                          ),
                          child: _buildInfoTab(
                            expertDetails!,
                            widget.advisorID,
                            context,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                          ),
                          child: _buildTabOneData(
                            shortsData,
                            expertDetails.name,
                            context,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                          ),
                          child: _buildLiveTab(recentlive, context),
                        ),
                      ],
                    ),
            ),
          );
        }
        return BaseScaffold(
          showBackgroundGrid: false,
          backgroundColor: UiConstants.bg,
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
        padding: EdgeInsets.only(top: 12.h),
      ),
      if (recentlive.isEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            width: 252.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 18.h),
                AppImage(
                  Assets.no_live,
                  height: 35.h,
                  width: 35.w,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Currently, there are no live sessions available.',
                  style: TextStyles.sourceSansSB.body0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
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
                padding: EdgeInsets.only(bottom: 16.h),
                child: LiveCardWidget(
                  fromHome: false,
                  id: video.id,
                  status: 'recent',
                  maxWidth: 350.w,
                  advisorImg: video.advisorImg,
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
                        showBackgroundGrid: false,
                        backgroundColor: UiConstants.bg,
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
          height: 12.h,
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
          height: 18.h,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final license = expertDetails.licenses[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: UiConstants.greyVarient,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Image.network(
                        license.imageUrl,
                        width: 46.w,
                        height: 46.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          license.name,
                          style: TextStyles.sourceSansSB.body3,
                        ),
                        SizedBox(height: 2.h),
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
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.open_in_new,
                                    color: Colors.white70,
                                    size: 16.r,
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
            height: 24.h,
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
            height: 18.h,
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
                padding: EdgeInsets.all(14.w),
                margin: EdgeInsets.only(
                  right: 4.w,
                ),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                ),
                child: AppImage(
                  social.icon,
                  color: UiConstants.kTextColor5,
                  height: 20.h,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 24.h,
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
            width: 252.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                AppImage(
                  Assets.no_shorts,
                  height: 35.h,
                  width: 35.w,
                ),
                SizedBox(height: 12.h),
                Text(
                  '$name hasn’t shared any shorts yet',
                  style: TextStyles.sourceSansSB.body0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
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
        padding: EdgeInsets.only(top: 12.h),
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
                    showBackgroundGrid: false,
                    backgroundColor: UiConstants.bg,
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
                      borderRadius: BorderRadius.circular(2.r),
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    left: 4.w,
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: UiConstants.kTextColor,
                          size: 20.r,
                        ),
                        SizedBox(width: 4.w),
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
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.h,
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
          height: 60.h,
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
          height: 12.h,
        ),
        if (widget.quickActions.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.quickActions.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 8.h,
                ),
                width: 4.w,
                height: 4.h,
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
        horizontal: 18.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(12.r),
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
                height: 4.h,
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
                horizontal: 8.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  5.r,
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
                  height: 18.h,
                ),
                Row(
                  children: [
                    Text(
                      ratingInfo.overallRating.toStringAsFixed(1),
                      style: TextStyles.sourceSansSB.title2,
                    ),
                    SizedBox(
                      width: 10.w,
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
                          itemSize: 6.r,
                          itemPadding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                          ),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 6.r,
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
                            horizontal: 18.w,
                            vertical: 6.h,
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
                              Radius.circular(5.r),
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
                SizedBox(height: 32.h),
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
                SizedBox(height: 20.h),
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
              radius: 16.r,
              child: AppImage(
                "assets/vectors/userAvatars/$image.svg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8.w),
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
          height: 10.h,
        ),
        RatingBar.builder(
          initialRating: rating.toDouble(),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glow: false,
          ignoreGestures: true,
          itemSize: 6.r,
          unratedColor: Colors.grey,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 6.r,
          ),
          onRatingUpdate: (rating) {},
        ),
        SizedBox(
          height: 10.h,
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
            vertical: review != '' ? 16.h : 4.h,
          ),
          child: Divider(
            color: UiConstants.kTextColor.withOpacity(.11),
          ),
        ),
      ],
    );
  }
}
