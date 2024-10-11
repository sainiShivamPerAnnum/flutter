import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/expert/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class ExpertsHomeView extends StatelessWidget {
  const ExpertsHomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpertBloc(
        locator(),
      )..add(const LoadExpertsData()),
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

  final double tabBarHeight = 50.0;

  GlobalKey personalFinanceKey = GlobalKey();
  GlobalKey stockMarketKey = GlobalKey();
  GlobalKey mutualFundsKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertBloc, ExpertState>(
      builder: (context, state) {
        if (state is LoadingExpertsData) {
          return const Center(
            child: FullScreenLoader(),
          );
        } else if (state is ExpertHomeLoaded) {
          final expertsData = state.expertsHome;

          if (expertsData == null) {
            return const Center(
              child: ErrorPage(),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
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
                        zeroPadding: true,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
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
                _buildExpertList(expertsData.our_top_experts),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    currentSection: state.currentSection,
                    scrollToSection: _scrollToSection,
                    stockMarketKey: stockMarketKey,
                    personalFinanceKey: personalFinanceKey,
                    mutualFundsKey: mutualFundsKey,
                  ),
                ),
                SliverToBoxAdapter(
                  key: personalFinanceKey,
                  child: InViewNotifierWidget(
                    id: 'Personal Finance',
                    builder: (context, isInView, child) {
                      if (isInView) {
                        BlocProvider.of<ExpertBloc>(context)
                            .add(const SectionChanged('Personal Finance'));
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding22,
                        ),
                        child: Text(
                          'Personal Finance',
                          style: TextStyles.sourceSansSB.body1,
                        ),
                      );
                    },
                  ),
                ),
                _buildExpertList(
                  expertsData.personal_finace,
                ),
                SliverToBoxAdapter(
                  key: stockMarketKey,
                  child: InViewNotifierWidget(
                    id: 'Stock Market',
                    builder: (context, isInView, child) {
                      if (isInView) {
                        BlocProvider.of<ExpertBloc>(context)
                            .add(const SectionChanged('Stock Market'));
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding22,
                        ),
                        child: Text(
                          'Stock Market',
                          style: TextStyles.sourceSansSB.body1,
                        ),
                      );
                    },
                  ),
                ),
                _buildExpertList(expertsData.stock_market),
                SliverToBoxAdapter(
                  key: mutualFundsKey,
                  child: InViewNotifierWidget(
                    id: 'Mutual Funds',
                    builder: (context, isInView, child) {
                      if (isInView) {
                        BlocProvider.of<ExpertBloc>(context)
                            .add(const SectionChanged('Mutual Funds'));
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding22,
                        ),
                        child: Text(
                          'Mutual Funds',
                          style: TextStyles.sourceSansSB.body1,
                        ),
                      );
                    },
                  ),
                ),
                _buildExpertList(expertsData.mutual_funds),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Failed to load experts data'),
          );
        }
      },
    );
  }

  Widget _buildExpertList(List<Expert> experts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final expert = experts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.padding16),
            child: ExpertCard(
              expert: expert,
              onBookCall: () {},
              onTap: (){},
            ),
          );
        },
        childCount: experts.length,
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String currentSection;
  final GlobalKey personalFinanceKey;
  final GlobalKey stockMarketKey;
  final GlobalKey mutualFundsKey;
  final Function(GlobalKey) scrollToSection;

  _StickyHeaderDelegate({
    required this.currentSection,
    required this.personalFinanceKey,
    required this.stockMarketKey,
    required this.mutualFundsKey,
    required this.scrollToSection,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: UiConstants.bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTabItem(
            'Personal Finance',
            'Personal Finance',
            () => scrollToSection(personalFinanceKey),
          ),
          buildTabItem(
            'Stock Market',
            'Stock Market',
            () => scrollToSection(stockMarketKey),
          ),
          buildTabItem(
            'Mutual Funds',
            'Mutual Funds',
            () => scrollToSection(mutualFundsKey),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 44.0;

  @override
  double get minExtent => 44.0;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.currentSection != currentSection;
  }

  Widget buildTabItem(
    String title,
    String key,
    VoidCallback onSectionTap,
  ) {
    bool isSelected = currentSection == title;
    return GestureDetector(
      onTap: onSectionTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? UiConstants.kTextColor
                  : UiConstants.kTextColor.withOpacity(0.6),
              width: 2.0,
            ),
          ),
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
    );
  }
}
