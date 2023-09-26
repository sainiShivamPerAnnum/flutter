import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/games_widget/game_view_model.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class GamesWidget extends StatelessWidget {
  const GamesWidget({super.key, required this.model});

  final PlayViewModel model;

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myUserWallet,
        UserServiceProperties.myUserFund
      ],
      builder: (_, prop, ___) {
        if (model.isGamesListDataLoading || prop?.userFundWallet == null) {
          return Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins / 2),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
              itemBuilder: (ctx, index) {
                return const TrendingGamesShimmer();
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .63,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
            ),
          );
        }

        if (model.gameTier == null) return const SizedBox();
        final _viewModel = GameViewModel.fromGameTier(model.gameTier!)
          ..processData();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              _viewModel.gameTiers.length,
              (index) {
                final child = Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                  child: _GameTierWidget(
                    gameTier: _viewModel.gameTiers[index],
                    model: model,
                  ),
                );
                if (index == 0) {
                  return child;
                }
                return child;
              },
            ),
          ],
        );
      },
    );
  }
}

class _GameTierWidget extends StatelessWidget {
  const _GameTierWidget({required this.gameTier, required this.model});

  final GameTier gameTier;
  final PlayViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                gameTier.svg,
                height: SizeConfig.padding46,
              ),
              TitleSubtitleContainer(
                zeroPadding: true,
                padding: EdgeInsets.zero,
                title: gameTier.title,
                titleStyle: TextStyles.rajdhaniSB.title5,
                subTitle: gameTier.subTitle,
                subtitleStyle: TextStyles.rajdhaniSB.body3
                    .colour(Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        Stack(
          fit: StackFit.loose,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding24,
                ),
                child: IgnorePointer(
                  ignoring: gameTier.isLocked,
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      direction: Axis.horizontal,
                      children: gameTier.games
                          .map(
                            (e) => SizedBox(
                              height: SizeConfig.screenHeight! * 0.18,
                              width: SizeConfig.screenWidth! * 0.272,
                              child: TrendingGames(
                                model: model,
                                game: model.gamesListData?.firstWhere(
                                  (element) => element.code == e?.code,
                                ),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ),
            ),
            if (gameTier.isLocked)
              Positioned.fill(child: _LockedState(gameTier: gameTier))
          ],
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
      ],
    );
  }
}

class _LockedState extends StatelessWidget {
  const _LockedState({required this.gameTier});

  final GameTier gameTier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameTier.showProgressIndicator) {
          locator<AnalyticsService>()
              .track(eventName: 'Gaming tier tap', properties: {
            'savings required to unlock':
                gameTier.amountToCompleteLevel.round(),
          });
          BaseUtil.openDepositOptionsModalSheet(
              amount: gameTier.amountToCompleteLevel.round(),
              title: "Save in any asset to unlock ${gameTier.title}",
              subtitle: 'Earn 1 token with every Rupee saved',
              timer: 0);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.black, Colors.transparent],
            begin: Alignment.bottomCenter,
            stops: [gameTier.shadow, 1],
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/lock icon.webp',
                    height: SizeConfig.padding32,
                  ),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  Text(
                    gameTier.winningText,
                    style: TextStyles.rajdhaniSB.body0,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding6,
              ),
              Text(
                gameTier.winningSubtext,
                style: TextStyles.rajdhaniSB.body3,
              ),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              if (gameTier.showProgressIndicator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomPaint(
                        foregroundPainter: CustomProgressBar(
                          gameTier.level * 1.0,
                          gameTier.netWorth,
                          gameTier.amountToCompleteLevel.round(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      "₹" +
                          gameTier.amountToCompleteLevel.round().toString() +
                          ' left',
                      style: TextStyles.rajdhaniB.body2,
                    )
                  ],
                ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomProgressBar extends CustomPainter {
  final double minAmount;
  final double netWorth;
  final int reamingAmount;

  CustomProgressBar(this.minAmount, this.netWorth, this.reamingAmount);

  @override
  void paint(Canvas canvas, Size size) {
    final _center = Offset(size.width / 2, 0);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, -8, size.width, 16),
          Radius.circular(SizeConfig.padding26),
        ),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              0, -8, getFilledWidth(size) == 0 ? 20 : getFilledWidth(size), 16),
          Radius.circular(SizeConfig.padding26),
        ),
        Paint()
          ..color = const Color(0xff297264)
          ..style = PaintingStyle.fill);

    // _drawText(canvas, size);
  }

  double getFilledWidth(Size size) => (size.width / minAmount) * netWorth;

  // void _drawText(Canvas canvas, Size size) {
  //   final textSpan = TextSpan(
  //     text: '₹$reamingAmount left',
  //     style: TextStyles.rajdhaniSB.body3.colour(Colors.black),
  //   );
  //   final textPainter = TextPainter(
  //     text: textSpan,
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout(
  //     minWidth: 0,
  //     maxWidth: size.width,
  //   );
  //   final xCenter = (size.width - textPainter.width - SizeConfig.padding10);
  //   final yCenter = (size.height - textPainter.height) / 2;
  //   final offset = Offset(xCenter, yCenter);
  //   textPainter.paint(canvas, offset);
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
