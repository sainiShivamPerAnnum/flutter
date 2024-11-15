import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/expert/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/upcoming_bookings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
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
  late AutoScrollController _autoScrollController;
  Map<String, GlobalKey> sectionKeys = {};

  @override
  void initState() {
    super.initState();
    _autoScrollController = AutoScrollController();
  }
  @override
  void dispose() {
    _autoScrollController.dispose();
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
                    autoScrollController: _autoScrollController,
                    scrollbarThumbVisibility: false,
                    tabController: DefaultTabController.of(tabContext!),
                    listItemData: [
                      ...expertsData.list.where(
                        (section) => !section.toLowerCase().contains('top'),
                      ),
                    ],
                    verticalScrollPosition: VerticalScrollPosition.begin,
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
                      const SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TitleSubtitleContainer(
                              title: "Experts",
                              zeroPadding: false,
                              largeFont: true,
                            ),
                          ],
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
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding20,
                        ),
                        sliver: SliverAppBar(
                          pinned: true,
                          toolbarHeight: 0,
                          backgroundColor: UiConstants.bg,
                          surfaceTintColor: UiConstants.bg,
                          bottom: TabBar(
                            indicatorPadding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: UiConstants.grey4,
                            indicatorWeight: 1.5,
                            padding: EdgeInsets.zero,
                            indicatorColor: UiConstants.kTextColor,
                            labelColor: UiConstants.kTextColor,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            unselectedLabelColor:
                                UiConstants.kTextColor.withOpacity(.6),
                            labelStyle: TextStyles.sourceSansSB.body3,
                            unselectedLabelStyle: TextStyles.sourceSansSB.body3,
                            tabs: [
                              ...expertsData.list
                                  .where(
                                (section) =>
                                    !section.toLowerCase().contains('top'),
                              )
                                  .map(
                                (value) {
                                  return Tab(text: value);
                                },
                              ),
                            ],
                            onTap: VerticalScrollableTabBarStatus.setIndex,
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
        _buildExpertList(experts, isFree),
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
                  isEdit: false,
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
  ) {
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
                isEdit: false,
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
            },
          ),
        );
      }).toList(),
    );
  }
}
