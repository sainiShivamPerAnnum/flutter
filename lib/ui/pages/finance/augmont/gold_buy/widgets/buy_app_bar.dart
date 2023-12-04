import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontTransactionService txnService;
  final VoidCallback trackCloseTapped;

  const RechargeModalSheetAppBar({
    required this.txnService,
    required this.trackCloseTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: txnService.isGoldBuyInProgress
          ? const SizedBox()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.4)),
              onPressed: trackCloseTapped,
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.digitalGoldBar,
            width: 45,
            height: 45,
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(
            'Digital Gold',
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
    );
  }
}
