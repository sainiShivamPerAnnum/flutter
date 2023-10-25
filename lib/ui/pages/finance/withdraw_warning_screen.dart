import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/game_tier_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
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
    required this.onWithDrawAnyWay,
    required this.viewModel,
    required this.onClose,
    this.withdrawableQuantity = 0.0,
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
        title: 'Confirm your action',
        leading: BackButton(
          onPressed: () => onClose.call(),
        ),
        showAvatar: false,
        showCoinBar: false,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    text: 'If you withdraw ',
                    children: [
                      TextSpan(
                        text: type == InvestmentType.AUGGOLD99
                            ? "$withdrawableQuantity"
                            : "₹$totalAmount",
                        style: TextStyles.sourceSansSB.colour(Colors.white),
                      ),
                      TextSpan(
                          text: type == InvestmentType.AUGGOLD99
                              ? " gms of Digital Gold"
                              : " from Fello Flo"),
                      const TextSpan(
                        text: ',\nthe following will be deducted:',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body1.colour(
                    Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff1a1a1a),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
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
                          color: const Color(0xff1a1a1a),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
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
                                (totalAmount /
                                        AppConfig.getValue(
                                            AppConfigKey.tambola_cost))
                                    .round()
                                    .toString(),
                                style: TextStyles.rajdhaniSB.body2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.padding4,
                          ),
                          Text(
                            (totalAmount /
                                            AppConfig.getValue(
                                                AppConfigKey.tambola_cost))
                                        .round() >
                                    1
                                ? "Tickets"
                                : "Ticket",
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
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
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color(0xff1a1a1a),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.gamesWillBeLocked.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) {
                      final game = viewModel.gamesWillBeLocked[i];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3,
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
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: AppPositiveBtn(
                btnText: 'PLAY GAMES NOW',
                onPressed: () {
                  locator<AnalyticsService>()
                      .track(eventName: 'Withdraw screen play games click');
                  while (AppState.screenStack.length > 1) {
                    AppState.backButtonDispatcher!.didPopRoute();
                  }

                  AppState.delegate!.appState.onItemTapped(DynamicUiUtils.navBar
                      .indexWhere((element) => element == 'PL'));
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: AppNegativeBtn(
                  onPressed: () {
                    // AppState.backButtonDispatcher!.didPopRoute();
                    onWithDrawAnyWay.call();
                  },
                  btnText: 'WITHDRAW ANYWAY',
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding20,
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
    final _userPortfolio = locator<UserService>().userPortfolio;
    final netWorth =
        _userPortfolio.augmont.principle + (_userPortfolio.flo.principle);
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
