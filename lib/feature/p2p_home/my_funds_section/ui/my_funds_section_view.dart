import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../../ui/shared/footer.dart';
import 'widgets/widgets.dart';

class MyFundSection extends StatelessWidget {
  const MyFundSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
                vertical: SizeConfig.padding16,
              ),
              sliver: const SliverToBoxAdapter(
                child: WalletBalanceCard(),
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
                  return const TransactionCard();
                },
                itemCount: 10,
                separatorBuilder: (context, index) => SizedBox(
                  height: SizeConfig.padding16,
                ),
              ),
            ),
          ],
        ),
        const Footer(),
      ],
    );
  }
}
