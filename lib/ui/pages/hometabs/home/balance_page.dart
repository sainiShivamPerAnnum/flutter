import 'package:design_system/design_system.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FelloBalanceScreen extends StatelessWidget {
  const FelloBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Fello Balance',
            style: TextStyles.rajdhaniSB.body1.colour(UiConstants.kTextColor),
          ),
          centerTitle: true,
          leading: const BackButton(
            color: UiConstants.kTextColor,
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fello Balance",
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  TextButton(
                    onPressed: () {
                      // View Breakdown action
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding10,
                        vertical: SizeConfig.padding6,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness5),
                        ),
                      ),
                    ),
                    child: Text(
                      "View Breakdown",
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
              child: Row(
                children: [
                  Text(
                    "₹ 12,66,320.78",
                    style: TextStyles.sourceSansSB.title3.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding8),
                  Text(
                    "+11.3%",
                    style: TextStyles.sourceSansSB.body3
                        .colour(UiConstants.kTabBorderColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding20),
            buildInvestmentSection(
              iconData: Assets.floAsset,
              title: "Fello Flo",
              balance: "₹502",
              change: "₹2",
              invested: "₹500",
              buttonText: "Invest",
              buttonAction: () {
                // Handle Invest button
              },
            ),
            buildInvestmentSection(
              iconData: Assets.goldAsset,
              title: "Digital Gold",
              balance: "₹502",
              change: "₹2",
              invested: "₹500",
              buttonText: "Invest",
              buttonAction: () {
                // Handle Invest button
              },
            ),
            buildInvestmentSection(
              iconData: null,
              title: "Fello Rewards",
              balance: "₹502",
              change: "₹2",
              invested: "₹500",
              buttonText: "Redeem",
              buttonAction: () {
                // Handle Redeem button
              },
            ),
            const Divider(
              color: UiConstants.kDividerColorLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInvestmentSection({
    required String? iconData,
    required String title,
    required String balance,
    required String change,
    required String invested,
    required String buttonText,
    required VoidCallback buttonAction,
  }) {
    return Column(
      children: [
        const Divider(
          color: UiConstants.kDividerColorLight,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding16,
            horizontal: SizeConfig.padding24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (iconData != null)
                        AppImage(
                          iconData,
                          height: SizeConfig.padding30,
                          fit: BoxFit.fill,
                        ),
                      if (iconData != null)
                        SizedBox(width: SizeConfig.padding10),
                      Text(
                        title,
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // View Breakdown action
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding32,
                        vertical: SizeConfig.padding6,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness5),
                        ),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Flo Balance",
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor.withOpacity(.7)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            balance,
                            style: TextStyles.sourceSansSB.body1,
                          ),
                          SizedBox(width: SizeConfig.padding2),
                          Text(
                            change,
                            style: TextStyles.sourceSansSB.body3
                                .colour(UiConstants.chipColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invested",
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor.withOpacity(.7)),
                      ),
                      SizedBox(height: SizeConfig.padding4),
                      Text(
                        invested,
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
