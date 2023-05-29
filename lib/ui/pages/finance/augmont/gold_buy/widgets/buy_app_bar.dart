import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontTransactionService txnService;
  final VoidCallback trackCloseTapped;

  const RechargeModalSheetAppBar({
    super.key,
    required this.txnService,
    required this.trackCloseTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: txnService.isGoldBuyInProgress
          ? const SizedBox()
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: trackCloseTapped,
            ),
      title: Row(
        children: [
          // SvgPicture.asset(),
          Text(
            'Save with Fello',
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
    );
  }
}
