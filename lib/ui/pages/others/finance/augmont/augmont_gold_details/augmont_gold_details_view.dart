import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/plots/fund_graph.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AugmontGoldDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldDetailsViewModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "About Digital Gold",
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.roundness40),
                          topRight: Radius.circular(SizeConfig.roundness40)),
                    ),
                    padding: EdgeInsets.symmetric(
                      // horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.padding32,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: SizeConfig.padding32),
                          width: SizeConfig.screenWidth,
                          child: LineChartWidget(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.422,
                                  height: SizeConfig.screenWidth * 0.202,
                                  decoration: BoxDecoration(
                                    color: UiConstants.tertiarySolid,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness24),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Buy Price",
                                        style: TextStyles.title5
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text(
                                        "₹ 4800",
                                        style: TextStyles.title5
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.422,
                                  height: SizeConfig.screenWidth * 0.202,
                                  decoration: BoxDecoration(
                                    color: UiConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness24),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sell Price",
                                        style: TextStyles.title5
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text(
                                        "₹ 4750",
                                        style: TextStyles.title5
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding32),
                        Column(
                          children: [
                            SizedBox(height: SizeConfig.scaffoldMargin),
                            Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.scaffoldMargin,
                                  vertical: SizeConfig.scaffoldMargin / 2),
                              decoration: BoxDecoration(
                                color: Color(0xffF6F9FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                onTap: () {},
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                leading: CircleAvatar(
                                  radius: kToolbarHeight * 0.5,
                                  backgroundColor: Color(0xffE3F4F7),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: UiConstants.primaryColor,
                                  ),
                                ),
                                title: Text(
                                  "What is Digital Gold",
                                  style: TextStyles.body1.bold,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: UiConstants.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.scaffoldMargin,
                                  vertical: SizeConfig.scaffoldMargin / 2),
                              decoration: BoxDecoration(
                                color: Color(0xffF6F9FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                onTap: () {},
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                leading: CircleAvatar(
                                  radius: kToolbarHeight * 0.5,
                                  backgroundColor: Color(0xffE3F4F7),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: UiConstants.primaryColor,
                                  ),
                                ),
                                title: Text(
                                  "How it works",
                                  style: TextStyles.body1.bold,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: UiConstants.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.scaffoldMargin,
                                  vertical: SizeConfig.scaffoldMargin / 2),
                              decoration: BoxDecoration(
                                color: Color(0xffF6F9FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                onTap: () {},
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                leading: CircleAvatar(
                                  radius: kToolbarHeight * 0.5,
                                  backgroundColor: Color(0xffE3F4F7),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: UiConstants.primaryColor,
                                  ),
                                ),
                                title: Text(
                                  "Who is Augmont",
                                  style: TextStyles.body1.bold,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: UiConstants.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
