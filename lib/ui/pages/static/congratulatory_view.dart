import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/seprator.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CongratulatoryView extends StatelessWidget {
  CongratulatoryView({Key key}) : super(key: key);
  final TransactionService _txnService = locator<TransactionService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/temp/congratulation_dialog_logo.png",
            width: SizeConfig.screenWidth * 0.56,
            height: SizeConfig.screenWidth * 0.4933,
          ),
          SizedBox(height: SizeConfig.padding64),
          Text(
            "Congratulations!",
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Text(
            "Your recharge was successfully processed",
            style: TextStyles.sourceSans.body2.setOpecity(0.7),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: UiConstants.kRechargeModalSheetAmountSectionBackgroundColor
                  .withOpacity(0.8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding24,
                    vertical: SizeConfig.padding20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Invested",
                        style: TextStyles.sourceSans.body3.setOpecity(0.5),
                      ),
                      Spacer(),
                      Text(
                        "₹${_txnService.depositFcmResponseModel.amount}",
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ],
                  ),
                ),
                Separator(
                  color: UiConstants.kTextColor.withOpacity(0.2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding24,
                    vertical: SizeConfig.padding6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Total Digital Gold",
                        style: TextStyles.sourceSans.body3.setOpecity(0.5),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        'assets/temp/digital_gold.svg',
                        height: SizeConfig.screenWidth * 0.12,
                        width: SizeConfig.screenWidth * 0.12,
                      ),
                      Text(
                        "${_txnService.depositFcmResponseModel.augmontGoldQty}g",
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
