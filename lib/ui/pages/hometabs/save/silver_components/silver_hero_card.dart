import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SilverInfoWidget extends StatelessWidget {
  const SilverInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (context, model, child) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          border: Border.all(width: 1, color: const Color.fromARGB(85, 255, 255, 255)),
        ),
        child: Column(
          children: [
            Container(
             decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(158, 16, 40, 54),
                  Color.fromARGB(197, 45, 55, 59),
                  Color.fromARGB(158, 16, 40, 54),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.roundness16),
                bottom: Radius.circular(SizeConfig.roundness16),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding20,
              vertical: SizeConfig.padding12,
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Silver Amount",
                        style: TextStyles.rajdhaniSB.body2.copyWith(
                          color: UiConstants.kTextFieldTextColor,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${model.userPortfolio.augmont.gold.principle}",
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSansSB.title5.copyWith(
                              color: Colors.white,
                              height: 1.27,
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding6),
                          if ((model.userFundWallet?.augGoldQuantity ?? 0.0) >
                              0.001)
                            Transform.translate(
                              offset: Offset(0, -SizeConfig.padding4),
                              child: RotatedBox(
                                quarterTurns: model.userPortfolio.augmont.gold
                                            .percGains >=
                                        0
                                    ? 0
                                    : 2,
                                child: SvgPicture.asset(
                                  Assets.arrow,
                                  width: SizeConfig.iconSize3,
                                  color: model.userPortfolio.augmont.gold
                                              .percGains >=
                                          0
                                      ? UiConstants.primaryColor
                                      : Colors.red,
                                ),
                              ),
                            ),
                          if ((model.userFundWallet?.augGoldQuantity ?? 0.0) >
                              0.001)
                            Text(
                                " ${BaseUtil.digitPrecision(
                                  model.userPortfolio.augmont.gold.percGains,
                                  2,
                                  false,
                                )}%",
                                style: TextStyles.sourceSans.body3.colour(model
                                            .userPortfolio
                                            .augmont
                                            .gold
                                            .percGains >=
                                        0
                                    ? UiConstants.primaryColor
                                    : Colors.red,
                                    ),
                                  ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Silver Value",
                        style: TextStyles.rajdhaniSB.body2
                            .colour(Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: (model.userFundWallet?.augGoldQuantity ?? 0)
                                  .toString(),
                              style: TextStyles.sourceSansSB.title5.copyWith(
                                color: Colors.white,
                                height: 1.27,
                              ),
                            ),
                            TextSpan(
                              text: " gms",
                              style: TextStyles.sourceSansSB.body1.copyWith(
                                color: Colors.white,
                                height: 1.27,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
