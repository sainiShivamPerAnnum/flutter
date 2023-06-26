import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/assets.dart' as A;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewBreakdown extends StatelessWidget {
  const ViewBreakdown({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GoldBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding28,
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding28,
          ),
          Row(
            children: [
              Text("Invested Amount", style: TextStyles.sourceSans.body2),
              const Spacer(),
              Text(
                "₹${model.goldAmountController?.text ?? '0'}",
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Text(
                "GST (${model.goldRates?.igstPercent}%)",
                style: TextStyles.sourceSans.body2,
              ),
              const Spacer(),
              Text(
                "₹${((model.goldRates?.igstPercent)! / 100 * double.parse(model.goldAmountController?.text ?? '0')).toStringAsFixed(2)}",
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Text("Digital Gold Amount", style: TextStyles.sourceSans.body2),
              const Spacer(),
              Text(
                "₹${(int.tryParse(model.goldAmountController?.text ?? '0')! - ((model.goldRates?.igstPercent)! / 100 * double.parse(model.goldAmountController?.text ?? '0'))).toStringAsFixed(2)}",
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Text(
                "Grams of Gold",
                style: TextStyles.sourceSans.body2,
              ),
              const Spacer(),
              Text(
                "${model.goldAmountInGrams}gms",
                style: TextStyles.sourceSansSB.body2,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          if ((model.totalTickets ?? 0) > 0) ...[
            Container(
              height: 1,
              color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Row(
              children: [
                SizedBox(
                  height: SizeConfig.padding28,
                  width: SizeConfig.padding28,
                  child: SvgPicture.asset(
                    Assets.howToPlayAsset1Tambola,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                Text(
                  "Total Tickets",
                  style: TextStyles.sourceSansSB.body1,
                ),
                const Spacer(),
                Text(
                  "${model.totalTickets}",
                  style: TextStyles.sourceSansSB.body1,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            if (model.showHappyHour && model.happyHourTickets != null) ...[
              Row(
                children: [
                  Text(
                    "Happy Hour Tickets",
                    style: TextStyles.sourceSans.body2,
                  ),
                  const Spacer(),
                  Text(
                    "${model.happyHourTickets}",
                    style: TextStyles.sourceSans.body2,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                children: [
                  Text(
                    "Lifetime Tickets",
                    style: TextStyles.sourceSans.body2,
                  ),
                  const Spacer(),
                  Text(
                    "${model.numberOfTambolaTickets}",
                    style: TextStyles.sourceSans.body2,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
            ],
          ],
          if (model.appliedCoupon != null) ...[
            Container(
              height: 1,
              color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  A.Assets.ticketTilted,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.appliedCoupon?.code} coupon applied',
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTealTextColor),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding12,
            )
          ],
          AppPositiveBtn(
            width: SizeConfig.screenWidth!,
            onPressed: () {
              if (!model.isGoldBuyInProgress) {
                FocusScope.of(context).unfocus();
                model.initiateBuy();
              }

              AppState.backButtonDispatcher?.didPopRoute();
            },
            btnText: model.status == 2 ? "Save" : 'unavailable'.toUpperCase(),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
        ],
      ),
    );
  }
}
