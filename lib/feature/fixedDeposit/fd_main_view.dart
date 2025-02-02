import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/feature/fixedDeposit/fundsSection/fd_funds.dart';
import 'package:felloapp/feature/fixedDeposit/myDeposits/my_deposits.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/lazy_load_indexed_stack.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FdMainView extends StatelessWidget {
  const FdMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FdHomeView();
  }
}

class FdHomeView extends StatefulWidget {
  const FdHomeView({super.key});

  @override
  State<FdHomeView> createState() => _FdHomeViewState();
}

class _FdHomeViewState extends State<FdHomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> tabs = <String>[
    'Invest',
    'My Deposits',
    'Transactions',
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const _AppBar(),
      showBackgroundGrid: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: SizeConfig.padding136,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      UiConstants.teal5,
                      UiConstants.teal7.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding24,
                    vertical: SizeConfig.padding16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: SizeConfig.padding232,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assured returns with low risk',
                              style: TextStyles.rajdhaniSB.title5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: UiConstants.grey5,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    SizeConfig.roundness8,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding16,
                                vertical: SizeConfig.padding4,
                              ),
                              child: Text(
                                '📈 Upto 9.5% Returns',
                                style: TextStyles.sourceSans.body3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppImage(
                        Assets.fdIcon,
                        width: SizeConfig.padding78,
                        height: SizeConfig.padding78,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: _TabBar(
                tabs: tabs,
                controller: _tabController,
              ),
            ),
          ];
        },
        body: LazyLoadIndexedStack(
          index: _currentIndex,
          children: [
            const ALLfdsSection(),
            const MyDepositsSection(),
            Container(
              color: Colors.blue,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: BackButton(
        color: UiConstants.kTextColor,
        onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
      ),
      backgroundColor: UiConstants.kTambolaMidTextColor,
      surfaceTintColor: UiConstants.kTambolaMidTextColor,
      title: Text(
        'Fixed Deposit',
        style: TextStyles.rajdhani.title4.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: const [
        Row(children: [FaqPill(type: FaqsType.flo)]),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.controller,
  });

  final List<String> tabs;
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 0,
      backgroundColor: UiConstants.grey5,
      surfaceTintColor: UiConstants.grey5,
      bottom: TabBar(
        controller: controller,
        indicatorColor: UiConstants.teal3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyles.sourceSans.body2,
        labelColor: UiConstants.teal3,
        unselectedLabelColor: UiConstants.textGray70,
        dividerColor: UiConstants.grey5,
        unselectedLabelStyle: TextStyles.sourceSans.body2,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
        isScrollable: false,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
