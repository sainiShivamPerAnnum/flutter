import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TransactionSection extends StatelessWidget {
  const TransactionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding16,
          ),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              return const _TransactionTile();
            },
            itemCount: 10,
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
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile();

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
