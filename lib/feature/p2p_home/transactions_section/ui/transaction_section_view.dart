import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/transactions_section/bloc/transaction_bloc.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/footer.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
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

class TransactionSection extends StatefulWidget {
  const TransactionSection({
    super.key,
  });

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  @override
  void initState() {
    super.initState();
    final transactionBloc = context.read<TransactionBloc>();
    transactionBloc.fetchFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>();

    return BlocBuilder<TransactionBloc,
        PaginationState<UserTransaction, int, Object>>(
      bloc: transactionBloc,
      builder: (context, state) {
        if (state.status.isFailedToLoadInitial) {
          ///TODO(@DK070202): Error widget here.
        }

        if (state.status.isFetchingInitialPage) {
          return const Center(
            child: SizedBox.square(
              dimension: 30,
              child: CircularProgressIndicator(
                color: UiConstants.primaryColor,
              ),
            ),
          );
        }
        if (state.entries.isEmpty) {
          return GestureDetector(
            onTap: () => DefaultTabController.of(context).animateTo(1),
            child: const AppImage(Assets.p2pNonInvest),
          );
        }

        return Stack(
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
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      if (state.entries.length - 1 == index &&
                          !state.status.isFetchingInitialPage) {
                        transactionBloc.fetchNextPage();
                      }
                      return _TransactionTile(
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
            const Footer()
          ],
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile(this.transaction, {required this.transactionBloc});
  final UserTransaction transaction;
  final TransactionBloc transactionBloc;
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(" 'on' ddMMM, yyyy 'at' hh:mm a").format(
        DateTime.fromMillisecondsSinceEpoch(
            transaction.timestamp!.millisecondsSinceEpoch));
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
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: TransactionDetailsPageConfig,
            widget: TransactionDetailsPage(
              txn: transaction,
              fundBloc: fundBloc,
              transactionBloc: transactionBloc,
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
                Text(
                  locale.amount(transaction.amount.round().toString()),
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
