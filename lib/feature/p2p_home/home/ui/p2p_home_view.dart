import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/p2p_home/home/widgets/percentage_chip.dart';
import 'package:felloapp/feature/p2p_home/invest_section/ui/invest_section_view.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/ui/my_funds_section_view.dart';
import 'package:felloapp/feature/p2p_home/transactions_section/bloc/transaction_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../ui/pages/hometabs/journey/elements/jMilestones.dart';
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
        BlocProvider(
          create: (context) => MyFundsBloc(
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
      initialIndex: 1,
      child: BaseScaffold(
        appBar: const _AppBar(),
        backgroundColor: UiConstants.bg,
        showBackgroundGrid: false,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child:
                    Selector<UserService, Tuple2<Portfolio, UserFundWallet?>>(
                  builder: (_, value, child) => value.item1.flo.balance > 0
                      ? _InvestedHeader(
                          portfolio: value.item1.flo,
                          tickets: value.item2?.tickets,
                        )
                      : CachedNetworkImage(
                          imageUrl: Assets.p2pHomeBanner,
                        ),
                  selector: (_, userService) => Tuple2(
                      userService.userPortfolio, userService.userFundWallet),
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

class _InvestedHeader extends StatelessWidget {
  const _InvestedHeader(
      {required this.portfolio, required this.tickets, super.key});
  final FloTiers portfolio;
  final Map<String, dynamic>? tickets;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [UiConstants.kFloContainerColor, Color(0xff297264)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding25,
          ),
          Text(
            locale.floPortFolio,
            style: TextStyles.rajdhaniSB.body2
                .colour(UiConstants.kTextColor.withOpacity(0.5)),
          ),
          Text(locale.amount(BaseUtil.formatCompactRupees(portfolio.balance)),
              style:
                  TextStyles.rajdhaniSB.title1.colour(UiConstants.kTextColor)),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
            ),
            child: _MyInvestedAmount(
              totalInvestment: portfolio.principle,
              currentValue: portfolio.absGain,
              tickets: tickets?['fromFlo'],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
        ],
      ),
    );
  }
}

class _MyInvestedAmount extends StatelessWidget {
  const _MyInvestedAmount({
    required this.totalInvestment,
    required this.currentValue,
    required this.tickets,
    super.key,
  });
  final num totalInvestment;
  final num currentValue;
  final num? tickets;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.floInvested,
                style: TextStyles.sourceSans.body3.colour(UiConstants.greyBg)),
            SizedBox(height: SizeConfig.padding4),
            Text(locale.amount(BaseUtil.formatCompactRupees(totalInvestment)),
                style: TextStyles.sourceSansSB.body1
                    .colour(UiConstants.kTextColor))
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.floCurrentReturn,
                style: TextStyles.sourceSans.body3.colour(UiConstants.greyBg)),
            SizedBox(height: SizeConfig.padding4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: locale
                          .amount(BaseUtil.formatCompactRupees(currentValue)),
                      style: TextStyles.sourceSansSB.body1
                          .colour(UiConstants.kTextColor)),
                  WidgetSpan(
                    child: PercentageChip(
                      value: (currentValue / totalInvestment) * 100.toDouble(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.ticketsEarnedflo,
                  style: TextStyles.sourceSans.body3.colour(UiConstants.greyBg),
                ),
                SizedBox(
                  width: SizeConfig.padding2,
                ),
                Tooltip(
                  margin:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                  padding: const EdgeInsets.all(15),
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: TooltipShapeBorder(
                      arrowArc: 0.2,
                      radius: 10,
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  showDuration: const Duration(seconds: 10),
                  message: locale.ticketsTooltip,
                  child: Icon(
                    Icons.info_outline,
                    size: SizeConfig.padding14,
                    color: UiConstants.greyBg,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding4,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '$tickets ',
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor)),
                  WidgetSpan(
                    child: AppImage(
                      Assets.singleTambolaTicket,
                      height: SizeConfig.padding16,
                    ),
                  ),
                  TextSpan(
                      text: locale.everyWeek,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
