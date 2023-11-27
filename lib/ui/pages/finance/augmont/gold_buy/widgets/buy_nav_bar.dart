import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart' as A;
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyNavBar extends StatelessWidget {
  const BuyNavBar({
    required this.model,
    required this.onTap,
    super.key,
  });

  final GoldBuyViewModel model;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding32,
        vertical: SizeConfig.padding16,
      ),
      color: UiConstants.kArrowButtonBackgroundColor,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹${model.goldAmountController?.text ?? '0'}",
                style: TextStyles.sourceSansSB.title5
                    .copyWith(color: Colors.white),
              ),
              //
              Text('in Digital Gold',
                  style: TextStyles.rajdhaniSB.body3
                      .colour(UiConstants.kTextFieldTextColor)),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              GestureDetector(
                onTap: () {
                  BaseUtil.openModalBottomSheet(
                    isBarrierDismissible: true,
                    backgroundColor: const Color(0xff1A1A1A),
                    addToScreenStack: true,
                    isScrollControlled: true,
                    content: GoldBreakdownView(
                      model: model,
                      showPsp: false,
                    ),
                  );
                },
                child: Text(
                  'View Breakdown',
                  style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.kTextFieldTextColor,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (model.appliedCoupon != null) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                  height: SizeConfig.padding4,
                )
              ],
              model.status == 2
                  ? AppPositiveBtn(
                      width: SizeConfig.screenWidth! * 0.22,
                      height: SizeConfig.screenWidth! * 0.12,
                      onPressed: () {
                        locator<AnalyticsService>().track(
                            eventName: AnalyticsEvents.saveInitiate,
                            properties: {
                              "investmentType": InvestmentType.AUGGOLD99.name,
                            });
                        if (model.isIntentFlow) {
                          BaseUtil.openModalBottomSheet(
                            isBarrierDismissible: true,
                            backgroundColor: const Color(0xff1A1A1A),
                            addToScreenStack: true,
                            isScrollControlled: true,
                            content: GoldBreakdownView(
                              model: model,
                              showBreakDown: AppConfig.getValue(
                                  AppConfigKey.payment_brief_view),
                            ),
                          );
                        } else {
                          onTap();
                        }
                      },
                      btnText: 'Save')
                  : AppNegativeBtn(
                      btnText: 'Save',
                      onPressed: () {},
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
