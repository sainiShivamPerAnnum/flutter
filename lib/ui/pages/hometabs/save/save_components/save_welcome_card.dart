import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/my_account_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/walkthrough_video_section.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveWelcomeCard extends StatelessWidget {
  const SaveWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.titleSize / 2),
          bottomRight: Radius.circular(SizeConfig.titleSize / 2),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 10),
              spreadRadius: 8)
        ],
      ),
      child: Column(
        children: [
          // SizedBox(
          //   height: SizeConfig.padding20,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Salutation(
              leftMargin: 0,
              textStyle: TextStyles.rajdhaniSB.title3.colour(Colors.white),
            ),
          ),
          Text(
            "Welcome to Fello",
            style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding10,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fello Balance", style: TextStyles.rajdhaniSB.title3),
                    Selector<UserService, Portfolio>(
                        builder: (_, portfolio, child) => Text(
                              "₹${BaseUtil.digitPrecision(portfolio.absolute.balance, 2, false)}",
                              style: TextStyles.sourceSansB.title4,
                            ),
                        selector: (_, userService) => userService.userPortfolio)
                  ],
                ),
                const Spacer(),
                MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  onPressed: () =>
                      BaseUtil.openDepositOptionsModalSheet(timer: 0),
                  child: Text(
                    "SAVE",
                    style: TextStyles.rajdhaniB.body2
                        .colour(UiConstants.kBackgroundColor),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding6),
          const WalthroughVideosSection(),
          SizedBox(
            height: SizeConfig.padding26,
          ),
        ],
      ),
    );
  }
}
