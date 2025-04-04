import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expert/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/expert/widgets/scroll_to_index.dart';
import 'package:felloapp/feature/expert/widgets/vertical_scrollable_widget.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/upcoming_bookings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../navigator/router/ui_pages.dart';

class ExpertsHomeView extends StatelessWidget {
  const ExpertsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ExpertBloc>()..add(const LoadExpertsData()),
      child: const _ExpertHome(),
    );
  }
}

class _ExpertHome extends StatefulWidget {
  const _ExpertHome();

  @override
  State<_ExpertHome> createState() => __ExpertHomeState();
}

class __ExpertHomeState extends State<_ExpertHome>
    with SingleTickerProviderStateMixin {
  BuildContext? tabContext;
  Map<String, GlobalKey> sectionKeys = {};
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final AutoScrollController _chipsScrollController = AutoScrollController();
  final Map<String, double> _chipPositions = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus();
    });
  }

  @override
  void dispose() {
    RootController.autoScrollController.dispose();
    _chipsScrollController.dispose();
    _searchFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void resetState() {
    _controller.clear();
    BlocProvider.of<ExpertBloc>(
      context,
      listen: false,
    ).add(const LoadExpertsData());
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        resetState();
        return true;
      },
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: UiConstants.primaryColor,
        backgroundColor: Colors.black,
        onRefresh: () async {
          BlocProvider.of<ExpertBloc>(context, listen: false)
              .add(const LoadExpertsData());
        },
        child: BlocBuilder<ExpertBloc, ExpertState>(
          builder: (context, state) {
            switch (state) {
              case LoadingExpertsData():
                return Column(
                  children: [
                    _appBar(''),
                    const Center(child: FullScreenLoader()),
                  ],
                );
              case ExpertHomeLoaded():
                _controller.text = state.query;
                final expertsData = state.expertsHome;
                if (expertsData == null || expertsData.list.isEmpty) {
                  return Center(
                    child: NewErrorPage(
                      onTryAgain: () {
                        BlocProvider.of<ExpertBloc>(
                          context,
                          listen: false,
                        ).add(
                          const LoadExpertsData(),
                        );
                      },
                    ),
                  );
                }

                sectionKeys = {
                  for (final section in expertsData.list)
                    if (!section.toLowerCase().contains('top'))
                      section: GlobalKey(),
                };
                final topSection = expertsData.list.firstWhere(
                  (section) => section.toLowerCase().contains('top'),
                );
                final otherSections = expertsData.list
                    .where((section) => !section.toLowerCase().contains('top'))
                    .toList();
                RootController.expertsSections = otherSections;
                return state.query != '' && state.searchResults.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _appBar(state.query),
                          SizedBox(
                            height: 150.h,
                          ),
                          Icon(
                            Icons.search_rounded,
                            size: 41.r,
                            color: Colors.white70,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            'No results found',
                            style: TextStyles.sourceSansM.body0,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          SizedBox(
                            width: 294.w,
                            child: Text(
                              'We found 0 results for your search “${state.query}”',
                              style: TextStyles.sourceSans.body2
                                  .colour(UiConstants.kTextColor5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : state.query != ''
                        ? Column(
                            children: [
                              _appBar(state.query),
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                      EdgeInsets.only(bottom: 80.h, top: 20.h),
                                  itemCount: state.searchResults.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      child: _buildExpertList(
                                        state.searchResults,
                                        expertsData.isAnyFreeCallAvailable,
                                        'Search',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : DefaultTabController(
                            length: otherSections.length,
                            child: Builder(
                              builder: (context) {
                                tabContext = context;
                                return ImprovedVerticalScrollableTabView(
                                  autoScrollController:
                                      RootController.autoScrollController,
                                  thumbVisibility: false,
                                  tabController:
                                      DefaultTabController.of(tabContext!),
                                  onTabChanged: (index) {
                                    if (state.currentSection !=
                                        otherSections[index]) {
                                      BlocProvider.of<ExpertBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        SectionChanged(otherSections[index]),
                                      );
                                      String selectedSection =
                                          otherSections[index];
                                      double targetPosition =
                                          _chipPositions[selectedSection]!;
                                      if (_chipPositions
                                              .containsKey(selectedSection) &&
                                          _chipPositions[selectedSection] !=
                                              null) {
                                        double currentScrollPosition =
                                            _chipsScrollController
                                                .position.pixels;
                                        double viewportWidth =
                                            _chipsScrollController
                                                .position.viewportDimension;
                                        double visibleEndPosition =
                                            currentScrollPosition +
                                                viewportWidth;
                                        double chipWidth = 120.w;

                                        double chipStart = targetPosition;
                                        double chipMidpoint =
                                            chipStart + (chipWidth / 2);

                                        bool isChipMidpointVisible =
                                            chipMidpoint >=
                                                    currentScrollPosition &&
                                                chipMidpoint <=
                                                    visibleEndPosition;
                                        if (!isChipMidpointVisible) {
                                          _chipsScrollController.animateTo(
                                            targetPosition,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      }
                                    }
                                  },
                                  listItemData: [
                                    ...expertsData.list.where(
                                      (section) => !section
                                          .toLowerCase()
                                          .contains('top'),
                                    ),
                                  ],
                                  verticalScrollPosition:
                                      VerticalScrollPosition.begin,
                                  eachItemChild: (object, index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding20,
                                    ),
                                    child: _buildInViewSection(
                                      otherSections[index],
                                      expertsData
                                              .values[otherSections[index]] ??
                                          [],
                                      expertsData.isAnyFreeCallAvailable,
                                    ),
                                  ),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: _appBar(state.query),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(
                                        left: SizeConfig.padding20,
                                      ),
                                      sliver: _buildUpcomingBookings(),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding20,
                                      ),
                                      sliver: SliverToBoxAdapter(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: SizeConfig.padding22,
                                          ),
                                          child: Text(
                                            'Our top experts',
                                            style:
                                                TextStyles.sourceSansSB.body1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding20,
                                      ),
                                      sliver: _buildTopExpertList(
                                        expertsData.values[topSection]
                                                ?.take(3)
                                                .toList() ??
                                            [],
                                        expertsData.isAnyFreeCallAvailable,
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(
                                        left: 18.w,
                                      ),
                                      sliver: SliverAppBar(
                                        pinned: true,
                                        toolbarHeight: 0,
                                        flexibleSpace: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {},
                                        ),
                                        backgroundColor: UiConstants.bg,
                                        surfaceTintColor: UiConstants.bg,
                                        bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(
                                            172.h,
                                          ),
                                          child: Transform.translate(
                                            offset: Offset(0, -20.h),
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {},
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 20.w,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                              bottom: 12.h,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  color: UiConstants
                                                                      .kTextColor,
                                                                  width: 2.h,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'All Experts',
                                                              style: TextStyles
                                                                  .sourceSansSB
                                                                  .body1,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: Divider(
                                                              color: UiConstants
                                                                  .kTextColor5
                                                                  .withOpacity(
                                                                .3,
                                                              ),
                                                              thickness: 1,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 24.h,
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    controller:
                                                        _chipsScrollController,
                                                    child: SizedBox(
                                                      width: 2 *
                                                              (120.w *
                                                                  ((expertsData
                                                                              .list
                                                                              .length /
                                                                          2) /
                                                                      2)) +
                                                          (8.w *
                                                              (expertsData.list
                                                                      .length -
                                                                  1)),
                                                      child: Wrap(
                                                        spacing: 8.w,
                                                        runSpacing: 8.w,
                                                        children:
                                                            expertsData.list
                                                                .where(
                                                          (section) => !section
                                                              .toLowerCase()
                                                              .contains('top'),
                                                        )
                                                                .map(
                                                          (value) {
                                                            return GestureDetector(
                                                              behavior:
                                                                  HitTestBehavior
                                                                      .opaque,
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                    ExpertBloc>(
                                                                  context,
                                                                  listen: false,
                                                                ).add(
                                                                  SectionChanged(
                                                                      value),
                                                                );

                                                                int sectionIndex =
                                                                    otherSections
                                                                        .indexOf(
                                                                  value,
                                                                );
                                                                if (sectionIndex !=
                                                                    -1) {
                                                                  VerticalScrollableTabBarStatus
                                                                      .setIndex(
                                                                    sectionIndex,
                                                                  );
                                                                }
                                                              },
                                                              child:
                                                                  LayoutBuilder(
                                                                builder: (
                                                                  context,
                                                                  constraints,
                                                                ) {
                                                                  WidgetsBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (_) {
                                                                    final RenderBox
                                                                        box =
                                                                        context.findRenderObject()
                                                                            as RenderBox;
                                                                    final position =
                                                                        box
                                                                            .localToGlobal(
                                                                              Offset.zero,
                                                                            )
                                                                            .dx;
                                                                    _chipPositions[
                                                                            value] =
                                                                        position -
                                                                            20;
                                                                  });
                                                                  return Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: state.currentSection ==
                                                                              value
                                                                          ? const Color(0xff62E3C4).withOpacity(
                                                                              .1)
                                                                          : const Color(0xffD9D9D9)
                                                                              .withOpacity(.1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius
                                                                            .circular(
                                                                          6.r,
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: state.currentSection ==
                                                                                value
                                                                            ? const Color(
                                                                                0xff62E3C4,
                                                                              ).withOpacity(
                                                                                .5,
                                                                              )
                                                                            : const Color(
                                                                                0xffCACBCC,
                                                                              ).withOpacity(
                                                                                .07,
                                                                              ),
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          16.w,
                                                                      vertical:
                                                                          8.h,
                                                                    ),
                                                                    child: Text(
                                                                      value,
                                                                      style: TextStyles
                                                                          .sourceSansM
                                                                          .body4
                                                                          .colour(
                                                                        state.currentSection ==
                                                                                value
                                                                            ? const Color(
                                                                                0xff62E3C4,
                                                                              )
                                                                            : UiConstants.kTextColor,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
              case LoadingExpertsFailed():
                return Center(
                  child: NewErrorPage(
                    onTryAgain: () {
                      BlocProvider.of<ExpertBloc>(
                        context,
                        listen: false,
                      ).add(
                        const LoadExpertsData(),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: locator<SaveViewModel>(),
        builder: (context, child) {
          return Selector<SaveViewModel, List<Booking>>(
            selector: (_, model) => model.upcomingBookings,
            builder: (_, upcomingBookings, __) {
              return upcomingBookings.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.padding24,
                        ),
                        const TitleSubtitleContainer(
                          title: "Your upcoming calls",
                          zeroPadding: true,
                        ),
                        Container(
                          height: SizeConfig.padding275,
                          margin: EdgeInsets.only(top: SizeConfig.padding10),
                          padding: EdgeInsets.only(top: SizeConfig.padding8),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: upcomingBookings.length,
                            scrollDirection: Axis.horizontal,
                            physics: upcomingBookings.length > 1
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(
                                right: SizeConfig.padding18,
                              ),
                              child: ScheduleCard(
                                booking: upcomingBookings[index],
                                width: upcomingBookings.length > 1
                                    ? SizeConfig.padding325
                                    : SizeConfig.padding350,
                                fromHome: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _appBar(String query) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.bg,
            Color(0xff212B2D),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.padding14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experts',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                  Text(
                    'Book a call with an expert instantly',
                    style: TextStyles.sourceSans.body3.colour(
                      UiConstants.kTextColor.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          SizedBox(
            height: 38.h,
            child: TextField(
              controller: _controller,
              focusNode: _searchFocusNode,
              autofocus: false,
              onSubmitted: (query) {
                if (query.trim().length >= 3) {
                  BlocProvider.of<ExpertBloc>(
                    context,
                  ).add(SearchExperts(query));
                  _searchFocusNode.unfocus();
                } else {
                  BaseUtil.showNegativeAlert(
                    'Input Error',
                    'Please enter at least 3 characters',
                  );
                }
              },
              textAlign: TextAlign.justify,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyles.sourceSans.body3.colour(
                  UiConstants.kTextColor.withOpacity(.7),
                ),
                filled: true,
                fillColor: const Color(0xffD9D9D9).withOpacity(.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                  borderSide: BorderSide(
                    color: const Color(
                      0xffCACBCC,
                    ).withOpacity(.07),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                  borderSide: BorderSide(
                    color: const Color(
                      0xffCACBCC,
                    ).withOpacity(.07),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                  borderSide: BorderSide(
                    color: const Color(
                      0xffCACBCC,
                    ).withOpacity(.07),
                  ),
                ),
                suffixIcon: query != ""
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          BlocProvider.of<ExpertBloc>(
                            context,
                            listen: false,
                          ).add(
                            const LoadExpertsData(),
                          );
                          _searchFocusNode.unfocus();
                        },
                        icon: Icon(
                          Icons.close,
                          color: UiConstants.kTextColor.withOpacity(
                            .7,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.search,
                        color: UiConstants.kTextColor.withOpacity(.7),
                      ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
        ],
      ),
    );
  }

  Widget _buildInViewSection(
    String section,
    List<Expert> experts,
    bool isFree,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSectionContent(section),
        _buildExpertList(experts, isFree, section),
      ],
    );
  }

  Widget _buildSectionContent(String section) {
    return Container(
      key: sectionKeys[section],
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding22),
      child: Text(section, style: TextStyles.sourceSansSB.body1),
    );
  }

  Widget _buildTopExpertList(
    List<Expert> experts,
    bool isFree,
  ) {
    final analytics = locator<AnalyticsService>();
    return SliverToBoxAdapter(
      child: Column(
        children: experts.map((expert) {
          return Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.padding16),
            child: ExpertCard(
              isFree: isFree,
              expert: expert,
              onBookCall: () {
                BaseUtil.openBookAdvisorSheet(
                  advisorId: expert.advisorId,
                  advisorName: expert.name,
                  advisorImage: expert.image,
                  isEdit: false,
                );
                analytics.track(
                  eventName: AnalyticsEvents.bookACall,
                  properties: {
                    "Section": "Our top expert",
                    "Expert ID": expert.advisorId,
                    "Expert name": expert.name,
                  },
                );
              },
              onTap: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  page: ExpertDetailsPageConfig,
                  state: PageState.addWidget,
                  widget: ExpertsDetailsView(
                    advisorID: expert.advisorId,
                  ),
                );
                analytics.track(
                  eventName: AnalyticsEvents.topExperts,
                  properties: {
                    "Expert sequence": expert.advisorId,
                    "Expert name": expert.name,
                  },
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpertList(
    List<Expert> experts,
    bool isFree,
    String section,
  ) {
    final analytics = locator<AnalyticsService>();
    return Column(
      children: experts.map((expert) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.padding16),
          child: ExpertCard(
            isFree: isFree,
            expert: expert,
            onBookCall: () {
              BaseUtil.openBookAdvisorSheet(
                advisorId: expert.advisorId,
                advisorName: expert.name,
                advisorImage: expert.image,
                isEdit: false,
              );
              analytics.track(
                eventName: AnalyticsEvents.bookACall,
                properties: {
                  "Section": section,
                  "Expert ID": expert.advisorId,
                  "Expert name": expert.name,
                },
              );
            },
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: ExpertDetailsPageConfig,
                state: PageState.addWidget,
                widget: ExpertsDetailsView(
                  advisorID: expert.advisorId,
                ),
              );
              analytics.track(
                eventName: "$section - Experts",
                properties: {
                  "Expert sequence": expert.advisorId,
                  "Expert name": expert.name,
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class CustomScrollableTabBar extends StatelessWidget {
  final List<dynamic> items;
  final TabController tabController;
  final Widget Function(dynamic item, bool isSelected, int index) tabBuilder;
  final Function(int) onTabChanged;

  const CustomScrollableTabBar({
    required this.items,
    required this.tabController,
    required this.tabBuilder,
    required this.onTabChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimatedBuilder(
        animation: tabController,
        builder: (context, _) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                final isSelected = tabController.index == index;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    VerticalScrollableTabBarStatus.setIndex(index);
                    onTabChanged(index);
                  },
                  child: tabBuilder(item, isSelected, index),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
