import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PreferredPaymentOption extends StatelessWidget {
  final AppUse? appUse;
  final VoidCallback? onPressed;

  const PreferredPaymentOption({
    required this.appUse,
    this.onPressed,
    super.key,
  });

  String _getAssetAppAsset(AppUse appUse) {
    switch (appUse) {
      case AppUse.GOOGLE_PAY:
        return Assets.gPay;
      case AppUse.PAYTM:
        return Assets.paytm;
      case AppUse.PHONE_PE:
        return Assets.phonePe;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appUse == null) return const SizedBox.shrink();
    return InkWell(
      onTap: onPressed,
      child: Ink(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Save Using',
                  style: TextStyles.sourceSans.body3.colour(
                    UiConstants.kModalSheetMutedTextBackgroundColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  Assets.arrow,
                  height: 8,
                  color: UiConstants.kModalSheetMutedTextBackgroundColor,
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.padding6,
            ),
            SizedBox(
              height: SizeConfig.padding32,
              child: SvgPicture.asset(
                _getAssetAppAsset(appUse!),
              ),
            )
          ],
        ),
      ),
    );
  }
}
