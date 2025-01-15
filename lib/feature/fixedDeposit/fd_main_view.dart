import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fixedDeposit/fundsSection/fd_funds.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/analytics_events_constants.dart';
import '../../../../core/service/analytics/analytics_service.dart';

class FdMainView extends StatelessWidget {
  const FdMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FdHomeView();
  }
}

class FdHomeView extends StatelessWidget {
  const FdHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final List<String> tabs = <String>[
      'Invest',
      'My Deposits',
      locale.transactionSection,
    ];
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: BaseScaffold(
        appBar: const _AppBar(),
        backgroundColor: UiConstants.bg,
        showBackgroundGrid: false,
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
                sliver: _TabBar(tabs: tabs),
              ),
            ];
          },
          body: TabBarView(
            children: [
              const ALLfdsSection(),
              Container(),
              Container(),
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
  });

  final List<String> tabs;

  void trackFelloFloTabChanged(String changedTab) {
    final totalInvestment =
        locator<UserService>().userPortfolio.flo.balance.toDouble();
    final props = {
      "new_tab": changedTab,
      "total_invested": totalInvestment,
      "kyc_verified": locator<UserService>().baseUser!.isSimpleKycVerified,
    };

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.felloFloTabChanged,
      properties: props,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 0,
      backgroundColor: UiConstants.grey5,
      surfaceTintColor: UiConstants.grey5,
      bottom: TabBar(
        indicatorColor: UiConstants.teal3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyles.sourceSans.body2,
        labelColor: UiConstants.teal3,
        unselectedLabelColor: UiConstants.textGray70,
        dividerColor: UiConstants.grey5,
        unselectedLabelStyle: TextStyles.sourceSans.body2,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
        isScrollable: false,
        onTap: (value) {
          trackFelloFloTabChanged(tabs[value]);
        },
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
