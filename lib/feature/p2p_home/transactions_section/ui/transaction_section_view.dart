import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/home/widgets/no_transaction_widget.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/transactions_section/bloc/sip_transaction_bloc.dart';
import 'package:felloapp/feature/p2p_home/transactions_section/bloc/transaction_bloc.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/footer.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/analytics_events_constants.dart';
import '../../../../core/service/analytics/analytics_service.dart';
import '../../../../core/service/notifier_services/transaction_history_service.dart';
import '../../ui/shared/error_state.dart';
import '../../ui/shared/tab_slider.dart';

class TransactionSection extends StatefulWidget {
  const TransactionSection({
    super.key,
  });

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection>
    with SingleTickerProviderStateMixin {
  List<String> tabOptions = ['One Time', 'SIP'];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabOptions.length, vsync: this);
    final transactionBloc = context.read<TransactionBloc>();
    final sipTransactionBloc = context.read<SIPTransactionBloc>();
    transactionBloc.fetchFirstPage();
    sipTransactionBloc.fetchFirstPage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>();
    final sipTransactionBloc = context.read<SIPTransactionBloc>();

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        transactionBloc.reset();
        sipTransactionBloc.reset();
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding50),
                    child: TabSlider<String>(
                      tabs: tabOptions,
                      controller: _tabController,
                      labelBuilder: (label) => label,
                      onTap: (current, i) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              if (_tabController.index == 0)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                  ),
                  sliver: BlocBuilder<TransactionBloc,
                      PaginationState<UserTransaction, int, Object>>(
                    bloc: transactionBloc,
                    builder: (context, state) {
                      if (state.status.isFailedToLoadInitial) {
                        return const SliverToBoxAdapter(child: ErrorPage());
                      }

                      if (state.status.isFetchingInitialPage) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: SizedBox.square(
                              dimension: SizeConfig.padding200,
                              child: const AppImage(
                                Assets.fullScreenLoaderLottie,
                              ),
                            ),
                          ),
                        );
                      }
                      if (state.entries.isEmpty) {
                        return SliverToBoxAdapter(child: NoTransactions());
                      }

                      return SliverList.separated(
                        itemBuilder: (context, index) {
                          if (state.entries.length - 1 == index &&
                              !state.status.isFetchingInitialPage &&
                              !state.status.isFetchingSuccessive) {
                            transactionBloc.fetchNextPage();
                          }

                          return state.entries.length - 1 == index &&
                                  state.status.isFetchingSuccessive
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 15,
                                    color: Colors.white24,
                                  ),
                                )
                              : _TransactionTile(
                                  state.entries[index],
                                  transactionBloc: transactionBloc,
                                );
                        },
                        itemCount: state.entries.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: UiConstants.grey2,
                            height: 1,
                          );
                        },
                      );
                    },
                  ),
                ),
              if (_tabController.index == 1)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                  ),
                  sliver: BlocBuilder<
                      SIPTransactionBloc,
                      PaginationState<SubscriptionTransactionModel, int,
                          Object>>(
                    bloc: sipTransactionBloc,
                    builder: (context, state) {
                      if (state.status.isFailedToLoadInitial) {
                        return const SliverToBoxAdapter(child: ErrorPage());
                      }
                      if (state.status.isFetchingInitialPage) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: SizedBox.square(
                              dimension: SizeConfig.padding200,
                              child: const AppImage(
                                Assets.fullScreenLoaderLottie,
                              ),
                            ),
                          ),
                        );
                      }
                      if (state.entries.isEmpty) {
                        return SliverToBoxAdapter(child: NoTransactions());
                      }
                      return SliverList.separated(
                        itemBuilder: (context, index) {
                          if (state.entries.length - 1 == index &&
                              !state.status.isFetchingInitialPage &&
                              !state.status.isFetchingSuccessive) {
                            sipTransactionBloc.fetchNextPage();
                          }
                          return state.entries.length - 1 == index &&
                                  state.status.isFetchingSuccessive
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 15,
                                    color: Colors.white24,
                                  ),
                                )
                              : _TransactionSIPTile(
                                  txn: state.entries[index],
                                );
                        },
                        itemCount: state.entries.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: UiConstants.grey2,
                            height: 1,
                          );
                        },
                      );
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: SizeConfig.padding124,
                ),
              )
            ],
          ),
          const Footer()
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile(this.transaction, {required this.transactionBloc});
  final UserTransaction transaction;
  final TransactionBloc transactionBloc;
  void trackTransactionTileTapped({required String assetName}) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.transactionDetailsScreen,
      properties: {
        "transaction_date": DateFormat("ddMMyyyy").format(
          DateTime.fromMillisecondsSinceEpoch(
            transaction.timestamp!.millisecondsSinceEpoch,
          ),
        ),
        "amount": transaction.amount.round(),
        "transaction_type": transaction.type,
        "asset": assetName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(" 'on' ddMMM, yyyy 'at' hh:mm a").format(
      DateTime.fromMillisecondsSinceEpoch(
        transaction.timestamp!.millisecondsSinceEpoch,
      ),
    );
    final assetInformation = AppConfigV2.instance.lendBoxP2P.firstWhere(
      (e) => e.fundType == transaction.lbMap.fundType,
    );
    final locale = locator<S>();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding16,
      ),
      child: GestureDetector(
        onTap: () {
          final fundBloc = context.read<MyFundsBloc>();
          Haptic.vibrate();
          trackTransactionTileTapped(assetName: assetInformation.assetName);
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: TransactionDetailsPageConfig,
            widget: TransactionDetailsPage(
              txn: transaction,
              onUpdatePrefrence: () {
                fundBloc.reset();
                transactionBloc.reset();
              },
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type ?? '',
                  style: TextStyles.rajdhani.body2,
                ),
                SizedBox(
                  height: SizeConfig.padding4,
                ),
                Text(
                  assetInformation.assetName + formattedDate,
                  style: TextStyles.sourceSans.body4.copyWith(
                    color: UiConstants.textGray50,
                  ),
                )
              ],
            ),
            Row(
              children: [
                TransactionStatusChip(
                  color: getTileColor(transaction.tranStatus),
                  status: transaction.tranStatus,
                ),
                Text(
                  locale.amount(transaction.amount.abs().round().toString()),
                  style: TextStyles.sourceSansSB.body2,
                ),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Color getTileColor(String? type) {
  if (type == UserTransaction.TRAN_STATUS_CANCELLED ||
      type == UserTransaction.TRAN_STATUS_FAILED) {
    return Colors.redAccent;
  } else if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
    return UiConstants.kTabBorderColor;
  } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
    return Colors.amber;
  } else if (type == UserTransaction.TRAN_STATUS_PROCESSING) {
    return Colors.amber;
  } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
    return Colors.blue;
  }
  return Colors.black54;
}

class _TransactionSIPTile extends StatelessWidget {
  final SubscriptionTransactionModel? txn;
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();

  _TransactionSIPTile({
    required this.txn,
  });

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return ListTile(
      onTap: Haptic.vibrate,
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        locale.btnDeposit.toUpperCase(),
        style: TextStyles.sourceSans.body3,
      ),
      subtitle: Text(
        _txnHistoryService.getFormattedSIPDate(
          DateTime.parse(txn!.createdOn.toDate().toString()),
        ),
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
      ),
      trailing: Wrap(
        children: [
          TransactionStatusChip(
            color: _txnHistoryService.getTileColor(txn!.status),
            status: txn!.status,
          ),
          Text(
            _txnHistoryService.getFormattedTxnAmount(
              double.tryParse(txn!.lbMap?.amount.toString() ?? '0') ?? 0,
            ),
            style: TextStyles.sourceSansM.body3,
          ),
        ],
      ),
    );
  }
}
