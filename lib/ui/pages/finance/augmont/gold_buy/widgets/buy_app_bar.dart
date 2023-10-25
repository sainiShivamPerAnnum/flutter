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
        children: [
          Container(
            width: SizeConfig.screenWidth! * 0.158,
            height: SizeConfig.screenWidth! * 0.158,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  UiConstants.primaryColor.withOpacity(0.4),
                  UiConstants.primaryColor.withOpacity(0.2),
                  UiConstants.primaryColor.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              Assets.digitalGoldBar,
              width: SizeConfig.screenWidth! * 0.27,
              height: SizeConfig.screenWidth! * 0.27,
            ),
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(
            'Save in Digital Gold',
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
    );
  }
}
