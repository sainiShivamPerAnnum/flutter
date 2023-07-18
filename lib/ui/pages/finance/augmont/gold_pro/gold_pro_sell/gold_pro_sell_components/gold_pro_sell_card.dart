import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoldProSellCard extends StatelessWidget {
  const GoldProSellCard({required this.data, super.key});

  final GoldProSellCardModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BaseUtil.openModalBottomSheet(
          isBarrierDismissible: false,
          addToScreenStack: true,
          isScrollControlled: true,
          hapticVibrate: true,
          content: GoldProSellConfirmationModalSheet(data: data),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding14),
        decoration: BoxDecoration(
          color: UiConstants.kArrowButtonBackgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gold Amount",
                    style: TextStyles.rajdhaniM.body1.colour(Colors.grey),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    "₹${data.amount}",
                    style: TextStyles.sourceSansSB.body0
                        .colour(UiConstants.kGoldProPrimary),
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Gold Value",
                    style: TextStyles.rajdhaniM.body1.colour(Colors.grey),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    "${data.value}gms",
                    style: TextStyles.sourceSansSB.body0
                        .colour(UiConstants.kGoldProPrimary),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding12),
          Row(
            children: [
              Text(
                "Leased On",
                style: TextStyles.sourceSans.body2
                    .colour(UiConstants.kFAQDividerColor),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM, yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        data.leasedOn.millisecondsSinceEpoch)),
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding12),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "will gain extra ",
                  style: TextStyles.body3
                      .colour(UiConstants.KGoldProPrimaryDark)
                      .setHeight(1.3),
                  children: [
                    TextSpan(
                        text: "${data.extraGold}g gold",
                        style:
                            TextStyles.sourceSans.body2.colour(Colors.white)),
                    TextSpan(
                      text:
                          "\non ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(data.maturityOn.millisecondsSinceEpoch))}",
                    )
                  ],
                ),
              ),
              const Spacer(),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.white),
                  ),
                  onPressed: () {
                    BaseUtil.openModalBottomSheet(
                      isBarrierDismissible: false,
                      addToScreenStack: true,
                      isScrollControlled: true,
                      hapticVibrate: true,
                      content: GoldProSellConfirmationModalSheet(data: data),
                    );
                  },
                  child: Text(
                    "UN-LEASE",
                    style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
                  ))
            ],
          )
        ]),
      ),
    );
  }
}

class GoldProSellConfirmationModalSheet extends StatelessWidget {
  const GoldProSellConfirmationModalSheet({
    super.key,
    required this.data,
  });

  final GoldProSellCardModel data;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.02,
      child: Container(
        height: SizeConfig.screenWidth! * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
            color: UiConstants.KGoldProPrimaryDark,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.roundness24),
          color: UiConstants.kGoldProBgColor,
        ),
        child: Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: GoldShimmerWidget(size: ShimmerSizeEnum.large),
            ),
            Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to un-lease your Gold?",
                    style: TextStyles.rajdhaniM.body2.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  Text(
                    "You will miss out on",
                    style: TextStyles.rajdhaniM.title3
                        .colour(UiConstants.kGoldProPrimary),
                  ),
                  SizedBox(height: SizeConfig.padding8),
                  Text(
                    "0.5g gold",
                    style: TextStyles.sourceSansSB.title3.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    "to be credited in your account on ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(data.maturityOn.millisecondsSinceEpoch))}",
                    style: TextStyles.sourceSans.body3.colour(Colors.white70),
                  ),
                  SizedBox(height: SizeConfig.pageHorizontalMargins),
                  MaterialButton(
                    onPressed: () {
                      Haptic.vibrate();
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    color: Colors.white,
                    height: SizeConfig.padding44,
                    minWidth: SizeConfig.screenWidth,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    child: Text(
                      "DO NOT UN-LEASE",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Haptic.vibrate();
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    child: Text(
                      "UN-LEASE TO GOLD",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
