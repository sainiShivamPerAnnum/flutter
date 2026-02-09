import 'package:felloapp/core/service/payments/silver_transaction_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontSilverTransactionService txnService;
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
        surfaceTintColor: Colors.transparent,
      leading: txnService.isSilverBuyInProgress
          ? const SizedBox()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.4),),
              onPressed: trackCloseTapped,
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           SizedBox(
            width: 35,
            height: 35,
            child: SvgPicture.asset(
              Assets.silverAsset,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(
            'Digital Silver',
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
    );
  }
}
