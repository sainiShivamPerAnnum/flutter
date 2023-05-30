import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FundBreakdownDialog extends StatelessWidget {
  const FundBreakdownDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => AppState.backButtonDispatcher!.didPopRoute(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
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
            title: Text("Fello Balance", style: TextStyles.rajdhaniSB.body1),
            trailing: Text(
              "₹1003",
              style: TextStyles.sourceSansB.body1,
            ),
          ),
          ListTile(
            title: Text("Invested Balance", style: TextStyles.rajdhaniSB.body1),
            trailing: Text(
              "₹1003",
              style: TextStyles.sourceSansB.body1,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: UiConstants.kSecondaryBackgroundColor,
              borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            ),
            child: Column(children: [
              ListTile(
                title: Text("Returns", style: TextStyles.sourceSansSB.body2),
                subtitle: Text(
                  "Returns on savings and rewards earned on Fello",
                  style: TextStyles.body4.colour(Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "(11.3%)",
                      style: TextStyles.body2.colour(UiConstants.primaryColor),
                    ),
                    Text(
                      "₹101343",
                      style: TextStyles.sourceSansSB.body2,
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const BreakdownInfoTile(
                title: "Returns in Fello Flo",
                value: "₹2323",
              ),
              const BreakdownInfoTile(
                title: "Returns in Digital Gold",
                value: "₹2323",
              ),
              const BreakdownInfoTile(
                title: "Rewards on Fello",
                value: "₹2323",
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class BreakdownInfoTile extends StatelessWidget {
  final String title, value;

  const BreakdownInfoTile(
      {super.key, required this.title, required this.value});

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
