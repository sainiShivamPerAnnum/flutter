import 'package:felloapp/core/model/sip_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/ui/widgets/sip_transaction_card.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/ui/widgets/statment_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/widgets.dart';

class MyFundSection extends StatefulWidget {
  const MyFundSection({
    super.key,
  });

  @override
  State<MyFundSection> createState() => _MyFundSectionState();
}

class _MyFundSectionState extends State<MyFundSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final fundsBloc = context.read<MyFundsBloc>();
    fundsBloc.fetchFirstPage();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final state = fundsBloc.state;

      // Trigger next page when user scrolls near bottom and not already fetching
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !state.status.isFetchingInitialPage &&
          !state.status.isFetchingSuccessive) {
        fundsBloc.fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fundsBloc = context.read<MyFundsBloc>();
    final DateTime now = DateTime.now();

    return RefreshIndicator.adaptive(
      onRefresh: () async => fundsBloc.reset(),
      child: BlocBuilder<MyFundsBloc, PaginationState<dynamic, int, Object>>(
        builder: (context, state) {
          if (state.status.isFailedToLoadInitial) {
            return const ErrorPage();
          }

          if (state.status.isFetchingInitialPage) {
            return Center(
              child: SizedBox.square(
                dimension: SizeConfig.padding200,
                child: const AppImage(Assets.fullScreenLoaderLottie),
              ),
            );
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                    ).copyWith(top: SizeConfig.padding16),
                    sliver: SliverToBoxAdapter(
                      child: WalletBalanceCard(fundBloc: fundsBloc),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.padding16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: StatementCard(fundBloc: fundsBloc),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.pageHorizontalMargins,
                      right: SizeConfig.pageHorizontalMargins,
                      bottom: SizeConfig.pageHorizontalMargins,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) {
                        final entry = fundsBloc.state.entries[index];

                        if (entry is UserTransaction &&
                            entry.lbMap.maturityAt != null &&
                            now.isBefore(entry.lbMap.maturityAt! as DateTime)) {
                          return TransactionCard(
                            transaction: entry,
                            fundBloc: fundsBloc,
                          );
                        }

                        if (entry is Subs) {
                          return SIPTransactionCard(transaction: entry);
                        }

                        return const SizedBox.shrink();
                      },
                      separatorBuilder: (_, __) => SizedBox(
                        height: SizeConfig.padding16
                        ),
                      itemCount: fundsBloc.state.entries.length,
                    ),
                  ),
                  if (state.status.isFetchingSuccessive)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CupertinoActivityIndicator(
                          radius: 15, 
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              // if (fundsBloc.state.entries.isNotEmpty) const Footer(),
            ],
          );
        },
      ),
    );
  }
}
