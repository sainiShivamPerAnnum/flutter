import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;

class NudgeSection extends StatelessWidget {
  const NudgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final amount = AppConfig.getValue(AppConfigKey.revamped_referrals_config)?[
            'rewardValues']?['invest1k'] ??
        50;
    return Container(
      padding: EdgeInsets.all(SizeConfig.padding12),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
        color: UiConstants.grey4,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(.15),
            blurRadius: 6,
            spreadRadius: 2,
          ),
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.30),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          AppImage(
            Assets.giftGameAsset,
            height: SizeConfig.padding26,
          ),
          SizedBox(
            width: SizeConfig.padding16,
          ),
          Text(
            locale.referralNudgeMessage(amount),
            style: TextStyles.rajdhaniSB.body2,
          ),
          const Spacer(),
          const AppImage(
            Assets.chevRonRightArrow,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
