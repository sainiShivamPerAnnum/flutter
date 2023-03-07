import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/game_tier_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WithDrawWarningScreen extends StatelessWidget {
  const WithDrawWarningScreen({
    required this.type,
    required this.totalAmount,
    this.withdrawableQuantity = 0.0,
    required this.onWithDrawAnyWay,
    required this.viewModel,
    required this.onClose,
    super.key,
  });
  final double withdrawableQuantity;
  final InvestmentType type;
  final double totalAmount;
  final void Function() onWithDrawAnyWay;
  final WithDrawGameViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: FAppBar(
        title: 'Are you really sure?',
        leading: BackButton(
          onPressed: () => onClose.call(),
        ),
        showAvatar: false,
        showCoinBar: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text(
                  'If you withdraw ${type == InvestmentType.AUGGOLD99 ? "$withdrawableQuantity gms of Digital Gold" : "₹$totalAmount from Fello Flo"},\nthe following will be deducted:',
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body1.colour(
                    Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff1a1a1a),
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "-  ",
                                style: TextStyles.rajdhaniSB.body1,
                              ),
                              SvgPicture.asset(
                                Assets.token,
                                height: SizeConfig.padding16,
                              ),
                              SizedBox(
                                width: SizeConfig.padding4,
                              ),
                              Text(
                                totalAmount
                                    .round()
                                    .toString()
                                    .split(".")
                                    .first
                                    .replaceAll("-", ""),
                                style: TextStyles.rajdhaniSB.body2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.padding4,
                          ),
                          Text(
                            "Game Tokens",
                            style: TextStyles.rajdhaniSB.body4,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff1a1a1a),
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "-  ",
                                style: TextStyles.rajdhaniSB.body1,
                              ),
                              SvgPicture.asset(
                                Assets.tambolaTicket,
                                height: SizeConfig.padding16,
                              ),
                              SizedBox(
                                width: SizeConfig.padding4,
                              ),
                              Text(
                                (totalAmount / 500).round().toString(),
                                style: TextStyles.rajdhaniSB.body2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.padding4,
                          ),
                          Text(
                            "Tambola Ticket",
                            textAlign: TextAlign.center,
                            style: TextStyles.rajdhaniSB.body4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                SizedBox(
                  width: SizeConfig.padding4,
                ),
                Text(
                  'You will also lose out on the following games:',
                  style: TextStyles.sourceSansSB.body2,
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                  color: Color(0xff1a1a1a),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.gamesWillBeLocked.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) {
                      final game = viewModel.gamesWillBeLocked[i];
                      return Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xff39393C),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.network(
                              game!.icon,
                              fit: BoxFit.cover,
                              width: SizeConfig.screenWidth! * 0.09,
                              height: SizeConfig.screenWidth! * 0.09,
                            ),
                            Text(
                              game.gameName,
                              textAlign: TextAlign.center,
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.cash_bindle,
                        height: SizeConfig.screenHeight! * 0.030,
                      ),
                      SizedBox(
                        width: SizeConfig.padding10,
                      ),
                      Text(
                        'You will miss out on ₹${NumberFormat.compact().format(viewModel.totalWining)} in winnings',
                        style: TextStyles.sourceSansSB.body3,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: AppPositiveBtn(
                btnText: 'PLAY GAMES NOW',
                onPressed: () {
                  AppState.backButtonDispatcher!.didPopRoute().then(
                        (value) => AppState.backButtonDispatcher!
                            .didPopRoute()
                            .then(
                              (value) => AppState.backButtonDispatcher!
                                  .didPopRoute()
                                  .then((value) => AppState.delegate!.appState
                                      .onItemTapped(DynamicUiUtils.navBar
                                          .indexWhere(
                                              (element) => element == 'PL'))),
                            ),
                      );
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // AppState.backButtonDispatcher!.didPopRoute();
                  onWithDrawAnyWay.call();
                },
                child: Text(
                  'WITHDRAW ANYWAY',
                  style: TextStyles.sourceSansSB.body2,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
          ],
        ),
      ),
    );
  }
}

class WithDrawGameViewModel {
  final List<GameModel?> gamesWillBeLocked;
  final double totalWining;
  WithDrawGameViewModel(this.gamesWillBeLocked, this.totalWining);

  factory WithDrawGameViewModel.fromGames(
      GameTiers model, double withDrawingAmount) {
    final gamesWillBeLocked = <GameModel?>[];
    final netWorth = locator<UserService>().userFundWallet!.netWorth!;
    final finalAmount = netWorth - withDrawingAmount;

    for (var i in model.data) {
      bool isTierAlreadyLocked = true;
      if (i!.minInvestmentToUnlock > netWorth) {
        isTierAlreadyLocked = false;
      }
      if (finalAmount < i.minInvestmentToUnlock && isTierAlreadyLocked) {
        gamesWillBeLocked.addAll([...i.games]);
      }
    }
    var totalWining = 0.0;
    gamesWillBeLocked.forEach((e) {
      totalWining = totalWining + (e!.prizeAmount! * 1.0);
    });

    return WithDrawGameViewModel(gamesWillBeLocked, totalWining);
  }
}
