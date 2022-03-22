import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/txn_completed_ui/txn_completed_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class TxnCompletedConfirmationScreenView extends StatelessWidget {
  final String title;
  final double amount;

  TxnCompletedConfirmationScreenView({@required this.amount, this.title});
  @override
  Widget build(BuildContext context) {
    return BaseView<TransactionCompletedConfirmationScreenViewModel>(
      onModelReady: (model) {
        model.init(amount);
      },
      onModelDispose: (model) {
        model.isAnimationInProgress = false;
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.85),
          body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.04,
                    child: Image.asset(
                      Assets.gtBackground,
                      height: SizeConfig.screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  actions: [
                    Container(
                      height: SizeConfig.avatarRadius * 2,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            Assets.tokens,
                            height: SizeConfig.iconSize1,
                          ),
                          SizedBox(width: SizeConfig.padding6),
                          AnimatedCount(
                              count: model.coinsCount,
                              duration: Duration(milliseconds: 1500)),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    NotificationButton(),
                  ],
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: model.isInvestmentAnimationInProgress ? 1 : 0,
                  curve: Curves.decelerate,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(Assets.txnFinish,
                            repeat: false,
                            height: SizeConfig.screenWidth * 0.8),
                        Container(
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              title ?? "Hurray!",
                              style:
                                  TextStyles.title3.bold.colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //SizedBox(height: SizeConfig.screenWidth / 4)
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: model.isCoinAnimationInProgress ? 1 : 0,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(Assets.coinStack,
                            height: SizeConfig.screenWidth,
                            width: SizeConfig.screenWidth * 0.6),
                        SizedBox(height: SizeConfig.padding40),
                        Container(
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Text(
                            "${amount.toInt()} Fello Tokens have been credited to your wallet!",
                            style: TextStyles.title3.bold.colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenWidth / 4)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
