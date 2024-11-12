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
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';

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
  final ScrollController _scrollController = ScrollController();
  Map<String, GlobalKey> sectionKeys = {};

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!);
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
            return Center(child: NewErrorPage(
              onTryAgain: () {
                BlocProvider.of<ExpertBloc>(
                  context,
                  listen: false,
                ).add(
                  const LoadExpertsData(),
                );
              },
            ));
          }
          sectionKeys = {
            for (final section in expertsData.list)
              if (!section.toLowerCase().contains('top')) section: GlobalKey(),
          };
          final topSectionKey = expertsData.list
              .firstWhere((section) => section.toLowerCase().contains('top'));

          return RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: UiConstants.primaryColor,
            backgroundColor: Colors.black,
            onRefresh: () async {
              BlocProvider.of<ExpertBloc>(context, listen: false)
                  .add(const LoadExpertsData());
            },
            child: InViewNotifierCustomScrollView(
              controller: _scrollController,
              isInViewPortCondition: (deltaTop, deltaBottom, vpHeight) {
                return deltaTop < (0.5 * vpHeight) &&
                    deltaBottom > (0.5 * vpHeight);
              },
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
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding22),
                      child: Text(
                        'Our top experts',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                  sliver: _buildTopExpertList(
                    expertsData.values[topSectionKey]?.take(3).toList() ?? [],
                    expertsData.isAnyFreeCallAvailable,
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      sections: expertsData.list,
                      currentSection: state.currentSection,
                      scrollToSection: _scrollToSection,
                      sectionKeys: sectionKeys,
                      context: context,
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      expertsData.list
                          .where(
                            (section) => !section.toLowerCase().contains('top'),
                          )
                          .map(
                            (section) => _buildInViewSection(
                              section,
                              expertsData.values[section] ?? [],
                              expertsData.isAnyFreeCallAvailable,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
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
                          height: SizeConfig.screenHeight! * 0.324,
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
    final sectionKey = sectionKeys[section];
    return InViewNotifierWidget(
      id: sectionKey.toString(),
      builder: (context, isInView, child) {
        if (isInView) {
          BlocProvider.of<ExpertBloc>(context).add(SectionChanged(section));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSectionContent(section),
            _buildExpertList(experts, isFree),
          ],
        );
      },
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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final expert = experts[index];
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
        },
        childCount: experts.length,
      ),
    );
  }

  Widget _buildExpertList(
    List<Expert> experts,
    bool isFree,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.padding16),
          child: ExpertCard(
            isFree: isFree,
            expert: experts[index],
            onBookCall: () {
              BaseUtil.openBookAdvisorSheet(
                advisorId: experts[index].advisorId,
                advisorName: experts[index].name,
                isEdit: false,
              );
            },
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: ExpertDetailsPageConfig,
                state: PageState.addWidget,
                widget: ExpertsDetailsView(advisorID: experts[index].advisorId),
              );
            },
          ),
        );
      },
      itemCount: experts.length,
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String currentSection;
  final List<String> sections;
  final Map<String, GlobalKey> sectionKeys;
  final Function(GlobalKey) scrollToSection;
  final BuildContext context;

  _StickyHeaderDelegate({
    required this.currentSection,
    required this.sections,
    required this.sectionKeys,
    required this.scrollToSection,
    required this.context,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.bg,
        border: Border(
          bottom: BorderSide(
            color: UiConstants.kTextColor.withOpacity(0.6),
            width: 2.0,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: sections
              .where((section) => !section.toLowerCase().contains('top'))
              .map((section) {
            return buildTabItem(
              section,
              sectionKeys[section],
              () => scrollToSection(sectionKeys[section]!),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent =>
      TextStyles.sourceSansSB.body3.fontSize! + SizeConfig.padding26;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.currentSection != currentSection;
  }

  Widget buildTabItem(String title, GlobalKey? key, VoidCallback onSectionTap) {
    bool isSelected = currentSection == title;
    return GestureDetector(
      onTap: onSectionTap,
      child: Transform.translate(
        offset: const Offset(0, 2),
        child: Container(
          margin: EdgeInsets.only(right: SizeConfig.padding16),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    bottom:
                        BorderSide(color: UiConstants.kTextColor, width: 2.0),
                  )
                : null,
          ),
          child: Text(
            title,
            style: TextStyles.sourceSansSB.body3.colour(
              isSelected
                  ? UiConstants.kTextColor
                  : UiConstants.kTextColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
