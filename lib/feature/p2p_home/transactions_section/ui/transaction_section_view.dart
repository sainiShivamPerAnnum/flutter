import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/home/bloc/p2p_home_bloc.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/footer.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
    if (transactionBloc.state.entries.isEmpty) {
      transactionBloc.fetchFirstPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            BlocBuilder<TransactionBloc,
                PaginationState<UserTransaction, int, Object>>(
              bloc: transactionBloc,
              builder: (context, state) {
                return MultiSliver(
                  children: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                        vertical: SizeConfig.padding16,
                      ),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          if (state.entries.length - 1 == index) {
                            transactionBloc.fetchNextPage();
                          }
                          return _TransactionTile(state.entries[index]);
                        },
                        itemCount: state.entries.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: UiConstants.grey2,
                            height: 1,
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
        const Footer()
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile(
    this.transaction,
  );
  final UserTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WITHDRAWL',
                style: TextStyles.rajdhani.body2,
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                '10% Flo on 13May, 2023 at 01:16 AM',
                style: TextStyles.sourceSans.body4.copyWith(
                  color: UiConstants.textGray50,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                '₹300',
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
    );
  }
}
