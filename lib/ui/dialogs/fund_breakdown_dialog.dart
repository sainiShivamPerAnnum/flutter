import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FundBreakdownDialog extends StatelessWidget {
  const FundBreakdownDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      content: Selector<UserService, Portfolio>(
        builder: (context, portfolio, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => AppState.backButtonDispatcher!.didPopRoute(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Text("Your Return Details", style: TextStyles.sourceSansM.title3),
              SizedBox(height: SizeConfig.padding16),
              ListTile(
                minVerticalPadding: 0,
                title:
                    Text("Fello Balance", style: TextStyles.rajdhaniSB.body1),
                trailing: Text(
                  "₹ ${BaseUtil.digitPrecision(portfolio.absolute.balance, 2, false).toString()}",
                  style: TextStyles.sourceSansB.body1,
                ),
              ),
              ListTile(
                minVerticalPadding: 0,
                title: Text("Invested Balance",
                    style: TextStyles.rajdhaniSB.body1),
                trailing: Text(
                  "₹ ${BaseUtil.digitPrecision(portfolio.absolute.principle, 2, false).toString()}",
                  style: TextStyles.sourceSansB.body1,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kSecondaryBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(SizeConfig.cardBorderRadius),
                ),
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                child: Column(children: [
                  ListTile(
                    title:
                        Text("Returns", style: TextStyles.sourceSansSB.body2),
                    subtitle: Text(
                      "Returns on savings and rewards earned on Fello",
                      style: TextStyles.body4.colour(Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "(${BaseUtil.digitPrecision(portfolio.absolute.percGains, 2, false)}%) ",
                          style: TextStyles.body2.colour(
                              BaseUtil.digitPrecision(
                                          portfolio.absolute.percGains,
                                          2,
                                          false) >=
                                      0
                                  ? UiConstants.primaryColor
                                  : Colors.red),
                        ),
                        Text(
                          "₹ ${BaseUtil.digitPrecision(portfolio.absolute.absGains, 2, false).toString()}",
                          style: TextStyles.sourceSansSB.body2,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  BreakdownInfoTile(
                    title: "Returns in Fello Flo",
                    value:
                        "₹ ${BaseUtil.digitPrecision(portfolio.flo.absGains, 2, false).toString()}",
                  ),
                  BreakdownInfoTile(
                    title: "Returns in Digital Gold",
                    value:
                        "₹ ${BaseUtil.digitPrecision(portfolio.augmont.absGains, 2, false).toString()}",
                  ),
                  BreakdownInfoTile(
                    title: "Current Rewards",
                    value:
                        "₹ ${BaseUtil.digitPrecision(portfolio.rewards, 2, false).toString()}",
                  ),
                  BreakdownInfoTile(
                    title: "Total Rewards",
                    value:
                        "₹ ${BaseUtil.digitPrecision(portfolio.lifeTimeRewards, 2, false).toString()}",
                  ),
                ]),
              )
            ],
          );
        },
        selector: (p0, p1) => p1.userPortfolio,
      ),
    );
  }
}

class BreakdownInfoTile extends StatelessWidget {
  final String title, value;

  const BreakdownInfoTile(
      {required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding8,
        horizontal: SizeConfig.padding14,
      ),
      child: Row(
        children: [
          Text(title, style: TextStyles.sourceSans.body2),
          const Spacer(),
          Text(value, style: TextStyles.sourceSans.body2)
        ],
      ),
    );
  }
}
