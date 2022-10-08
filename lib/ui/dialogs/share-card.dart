import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ShareCard extends StatelessWidget {
  final String dpUrl;
  final double prizeAmount;
  final PrizeClaimChoice claimChoice;

  ShareCard({
    this.claimChoice,
    this.dpUrl,
    this.prizeAmount,
  });

  getImage() {
    switch (claimChoice) {
      case PrizeClaimChoice.AMZ_VOUCHER:
        return Assets.amazonGiftVoucher;
        break;
      case PrizeClaimChoice.GOLD_CREDIT:
        return Assets.augmontShare;
        break;
      default:
        return Assets.felloRewards;
    }
  }

  getTitle() {
    switch (claimChoice) {
      case PrizeClaimChoice.AMZ_VOUCHER:
        return "You've won an Amazon Gift Voucher\n worth";
        break;
      case PrizeClaimChoice.GOLD_CREDIT:
        return "I've won ₹${prizeAmount.toInt()} as\nDigital Gold on Fello!";
        break;
      default:
        return "You've won Fello Rewards\n worth";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          top: SizeConfig.padding40,
          bottom: SizeConfig.padding80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness16),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(SizeConfig.padding12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: UiConstants.kBlogCardRandomColor3,
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
                child: Image.asset(
                  Assets.redeemSucessfullAssetPNG,
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
          Text(
            getTitle(),
            style: TextStyles.rajdhaniSB.title3.colour(Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            'Play fun games and get a chance to\nwin rewards as Digital Gold!',
            style: TextStyles.sourceSans.body3.colour(Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
        ],
      ),
    );
  }
}
