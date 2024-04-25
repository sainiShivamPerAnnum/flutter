import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/feature/p2p_home/home/bloc/p2p_home_bloc.dart';
import 'package:felloapp/feature/p2p_home/invest_section/ui/invest_section_view.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/ui/my_funds_section_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../transactions_section/ui/transaction_section_view.dart';

class P2PHomePage extends StatelessWidget {
  const P2PHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionBloc(
            transactionHistoryRepo: locator(),
          ),
        ),
      ],
      child: const P2PHomeView(),
    );
  }
}

class P2PHomeView extends StatelessWidget {
  const P2PHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final List<String> tabs = <String>[
      locale.myFundsSection,
      locale.investSection,
      locale.transactionSection,
    ];
    return DefaultTabController(
      length: tabs.length,
      child: BaseScaffold(
        appBar: const _AppBar(),
        backgroundColor: UiConstants.bg,
        showBackgroundGrid: false,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: CachedNetworkImage(
                  imageUrl: Assets.p2pHomeBanner,
                ),
              ),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: _TabBar(tabs: tabs),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              MyFundSection(),
              InvestSection(),
              TransactionSection(),
            ],
          ),
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
    final locale = locator<S>();
    return AppBar(
      elevation: 0,
      leading: BackButton(
        onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
      ),
      backgroundColor: UiConstants.kTambolaMidTextColor,
      title: Text(
        locale.felloP2P,
        style: TextStyles.rajdhani.title4.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: const [
        Row(children: [FaqPill(type: FaqsType.yourAccount)]),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
  });

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 0,
      backgroundColor: UiConstants.grey5,
      bottom: TabBar(
        indicatorColor: UiConstants.teal3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyles.sourceSans.body2,
        labelColor: UiConstants.teal3,
        unselectedLabelColor: UiConstants.textGray70,
        unselectedLabelStyle: TextStyles.sourceSans.body2,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
        isScrollable: false,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
