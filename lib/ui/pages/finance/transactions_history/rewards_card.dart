import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:felloapp/util/assets.dart';

enum RewardType {
  sc(asset: Assets.scratchCard), // golden ticket | scratch card.
  tt(
    asset: Assets.tambolaTicket,
  ); // tambola ticket.

  const RewardType({
    required this.asset,
  });

  final String asset;
}

class RewardsCard extends StatelessWidget {
  const RewardsCard({
    super.key,
    required this.rewardType,
    required this.rewardQuantity,
    required this.txnType,
    this.isRewardTypeTicket = false,
  });

  final String txnType;
  final bool isRewardTypeTicket;

  final String rewardQuantity;
  final RewardType rewardType;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff212B31),
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding16, vertical: SizeConfig.padding8),
        margin: isRewardTypeTicket
            ? const EdgeInsets.only(right: 8)
            : EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (txnType == UserTransaction.TRAN_TYPE_WITHDRAW &&
                    isRewardTypeTicket)
                  Text(
                    "-  ",
                    style: TextStyles.rajdhaniSB.body1,
                  ),
                SvgPicture.asset(
                  rewardType.asset,
                  height: SizeConfig.padding16,
                ),
                SizedBox(
                  width: SizeConfig.padding4,
                ),
                Text(
                  rewardQuantity,
                  style: TextStyles.rajdhaniSB.body2,
                ),
              ],
            ),
            SizedBox(
              width: SizeConfig.padding4,
            ),
            Text(
              isRewardTypeTicket ? "Ticket(s)" : locale.scratchCard,
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniSB.body4,
            ),
          ],
        ),
      ),
    );
  }
}
