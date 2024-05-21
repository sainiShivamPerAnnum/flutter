import 'package:felloapp/core/model/sip_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/ui/widgets/sip_transaction_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/notifier_services/user_service.dart';
import '../../home/widgets/no_transaction_widget.dart';
import '../../ui/shared/footer.dart';
import 'widgets/widgets.dart';

class MyFundSection extends StatefulWidget {
  const MyFundSection({
    super.key,
  });

  @override
  State<MyFundSection> createState() => _MyFundSectionState();
}

class _MyFundSectionState extends State<MyFundSection> {
  @override
  void initState() {
    super.initState();
    final fundsBloc = context.read<MyFundsBloc>();
    fundsBloc.fetchFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    final fundsBloc = context.read<MyFundsBloc>();
    final DateTime now = DateTime.now();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        fundsBloc.reset();
      },
      child: BlocBuilder<MyFundsBloc, PaginationState<dynamic, int, Object>>(
        builder: (context, state) {
          if (state.status.isFailedToLoadInitial) {
            return const ErrorPage();
          }

          if (state.status.isFetchingInitialPage) {
            return Center(
              child: SizedBox.square(
                dimension: SizeConfig.padding200,
                child: const AppImage(
                  Assets.fullScreenLoaderLottie,
                ),
              ),
            );
          }
          if (fundsBloc.state.entries.isEmpty &&
              locator<UserService>()
                      .userPortfolio
                      .flo
                      .flexi
                      .balance
                      .toDouble() ==
                  0) {
            return Padding(
              padding: EdgeInsets.only(top: SizeConfig.padding82),
              child: NoTransactions(),
            );
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.padding16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: WalletBalanceCard(
                        fundBloc: fundsBloc,
                      ),
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
                        if (state.entries.length - 1 == index &&
                            !state.status.isFetchingInitialPage &&
                            !state.status.isFetchingSuccessive) {
                          fundsBloc.fetchNextPage();
                        }
                        if (fundsBloc.state.entries[index] is UserTransaction &&
                            (fundsBloc.state.entries[index] as UserTransaction)
                                    .lbMap
                                    .maturityAt !=
                                null &&
                            now.compareTo(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    (fundsBloc.state.entries[index]
                                            as UserTransaction)
                                        .lbMap
                                        .maturityAt!
                                        .millisecondsSinceEpoch,
                                  ),
                                ) <
                                0) {
                          return TransactionCard(
                            transaction: fundsBloc.state.entries[index],
                            fundBloc: fundsBloc,
                          );
                        }
                        if (fundsBloc.state.entries[index] is Subs) {
                          return SIPTransactionCard(
                            transaction: fundsBloc.state.entries[index],
                          );
                        }
                        return null;
                      },
                      itemCount: fundsBloc.state.entries.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: SizeConfig.padding16,
                      ),
                    ),
                  ),
                  if (state.status.isFetchingSuccessive)
                    const SliverToBoxAdapter(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        color: Colors.white24,
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                    ),
                  )
                ],
              ),
              if (fundsBloc.state.entries.isNotEmpty) const Footer(),
            ],
          );
        },
      ),
    );
  }
}
