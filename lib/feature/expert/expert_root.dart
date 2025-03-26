import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expert/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/feature/shortsHome/bloc/shorts_home_bloc.dart';
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
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

import '../../navigator/router/ui_pages.dart';

class ExpertsHomeView extends StatelessWidget {
  const ExpertsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpertBloc(locator())..add(const LoadExpertsData()),
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
    _searchFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertBloc, ExpertState>(
      builder: (context, state) {
        if (state is LoadingExpertsData) {
          return const Center(child: FullScreenLoader());
        } else if (state is ExpertHomeLoaded) {
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
              if (!section.toLowerCase().contains('top')) section: GlobalKey(),
          };
          final topSection = expertsData.list
              .firstWhere((section) => section.toLowerCase().contains('top'));
          final otherSections = expertsData.list
              .where((section) => !section.toLowerCase().contains('top'))
              .toList();

          return RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: UiConstants.primaryColor,
            backgroundColor: Colors.black,
            onRefresh: () async {
              BlocProvider.of<ExpertBloc>(context, listen: false)
                  .add(const LoadExpertsData());
            },
            child: DefaultTabController(
              length: otherSections.length,
              child: Builder(
                builder: (context) {
                  tabContext = context;
                  return VerticalScrollableTabView(
                    autoScrollController: RootController.autoScrollController,
                    scrollbarThumbVisibility: false,
                    tabController: DefaultTabController.of(tabContext!),
                    listItemData: [
                      ...expertsData.list.where(
                        (section) => !section.toLowerCase().contains('top'),
                      ),
                    ],
                    verticalScrollPosition: VerticalScrollPosition.middle,
                    eachItemChild: (object, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding20,
                      ),
                      child: _buildInViewSection(
                        otherSections[index],
                        expertsData.values[otherSections[index]] ?? [],
                        expertsData.isAnyFreeCallAvailable,
                      ),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: SizeConfig.padding14),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [UiConstants.bg, Color(0xff212B2D)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Experts',
                                        style: TextStyles.sourceSansSB.body1,
                                      ),
                                      Text(
                                        'Book a call with an expert instantly',
                                        style:
                                            TextStyles.sourceSans.body3.colour(
                                          UiConstants.kTextColor
                                              .withOpacity(.7),
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
                                      BlocProvider.of<ShortsHomeBloc>(context)
                                          .add(SearchShorts(query));
                                      _searchFocusNode.unfocus();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please enter at least 3 characters',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle:
                                        TextStyles.sourceSans.body3.colour(
                                      UiConstants.kTextColor.withOpacity(.7),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffD9D9D9)
                                        .withOpacity(.04),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: const Color(0xffCACBCC)
                                            .withOpacity(.07),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: const Color(0xffCACBCC)
                                            .withOpacity(.07),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: const Color(0xffCACBCC)
                                            .withOpacity(.07),
                                      ),
                                    ),
                                    suffixIcon: '' != ""
                                        ? GestureDetector(
                                            onTap: () {
                                              _controller.clear();
                                              BlocProvider.of<ShortsHomeBloc>(
                                                context,
                                                listen: false,
                                              ).add(const LoadHomeData());
                                              _searchFocusNode.unfocus();
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: UiConstants.kTextColor
                                                  .withOpacity(.7),
                                            ),
                                          )
                                        : Icon(
                                            Icons.search,
                                            color: UiConstants.kTextColor
                                                .withOpacity(.7),
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
                        ),
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
                              style: TextStyles.sourceSansSB.body1,
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding20,
                        ),
                        sliver: _buildTopExpertList(
                          expertsData.values[topSection]?.take(3).toList() ??
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
                          backgroundColor: UiConstants.bg,
                          surfaceTintColor: UiConstants.bg,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(
                              172.h,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: UiConstants.kTextColor,
                                              width: 2.h,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'All Experts',
                                          style: TextStyles.sourceSansSB.body1,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.zero,
                                        child: Divider(
                                          color: UiConstants.kTextColor5
                                              .withOpacity(.3),
                                          thickness: 1,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 24.h,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 2.sw,
                                    child: Wrap(
                                      spacing: 8.w,
                                      runSpacing: 8.h,
                                      children: expertsData.list
                                          .where(
                                        (section) => !section
                                            .toLowerCase()
                                            .contains('top'),
                                      )
                                          .map(
                                        (value) {
                                          return GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<ExpertBloc>(
                                                context,
                                                listen: false,
                                              ).add(
                                                SectionChanged(value),
                                              );

                                              int sectionIndex =
                                                  otherSections.indexOf(value);
                                              if (sectionIndex != -1) {
                                                VerticalScrollableTabBarStatus
                                                    .setIndex(sectionIndex);
                                                DefaultTabController.of(context)
                                                    .animateTo(sectionIndex);
                                                if (sectionKeys[value] !=
                                                    null) {
                                                  Scrollable.ensureVisible(
                                                    sectionKeys[value]!
                                                        .currentContext!,
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: state.currentSection ==
                                                        value
                                                    ? const Color(0xff62E3C4)
                                                        .withOpacity(.1)
                                                    : const Color(0xffD9D9D9)
                                                        .withOpacity(.1),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(6.r),
                                                ),
                                                border: Border.all(
                                                  color: state.currentSection ==
                                                          value
                                                      ? const Color(0xff62E3C4)
                                                          .withOpacity(.5)
                                                      : const Color(0xffCACBCC)
                                                          .withOpacity(.07),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 8.h,
                                              ),
                                              child: Text(
                                                value,
                                                style: TextStyles
                                                    .sourceSansM.body4
                                                    .colour(
                                                  state.currentSection == value
                                                      ? const Color(0xff62E3C4)
                                                      : UiConstants.kTextColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return NewErrorPage(
            onTryAgain: () {
              BlocProvider.of<ExpertBloc>(
                context,
                listen: false,
              ).add(
                const LoadExpertsData(),
              );
            },
          );
        }
      },
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
