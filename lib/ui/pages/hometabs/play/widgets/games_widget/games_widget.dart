import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/games_widget/game_view_model.dart';
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
      properties: [
        UserServiceProperties.myUserWallet,
        UserServiceProperties.myUserFund
      ],
      builder: (_, prop, ___) {
        if (prop!.userFundWallet == null) return SizedBox();

        final _viewModel = viewModel..processData();
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleSubtitleContainer(title: _viewModel.title),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              ...List.generate(
                _viewModel.gameTiers.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                  child: _GameTierWidget(
                    gameTier: _viewModel.gameTiers[index],
                    model: model,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GameTierWidget extends StatelessWidget {
  const _GameTierWidget(
      {super.key, required this.gameTier, required this.model});

  final GameTiers gameTier;
  final PlayViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
          title: gameTier.title,
          titleStyle: TextStyles.rajdhaniSB.title5,
          subTitle: gameTier.subTitle,
          subtitleStyle: TextStyles.rajdhaniSB.body3,
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
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: gameTier.isLocked
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    spacing: 12,
                    runSpacing: 12,
                    direction: Axis.horizontal,
                    children: gameTier.games
                        .map(
                          (e) => SizedBox(
                            height: SizeConfig.screenHeight! * 0.22,
                            width: SizeConfig.screenWidth! * 0.272,
                            child: TrendingGames(
                              model: model,
                              game: e,
                            ),
                          ),
                        )
                        .toList()),
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
  const _LockedState({super.key, required this.gameTier});
  final GameTiers gameTier;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
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
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: SizeConfig.padding38,
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Text(
                    "Winnings\nupto ₹20K",
                    style: TextStyles.rajdhaniSB.body0,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding6,
              ),
              Text(
                "Unlock Level 2 Games first to start playing Level 3 Games",
                style: TextStyles.rajdhaniSB.body4,
              ),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              if (gameTier.showProgressIndicator)
                CustomPaint(
                  foregroundPainter: CustomProgressBar(
                    gameTier.level.minAmount * 1.0,
                    gameTier.netWorth,
                    gameTier.amountToCompleteLevel.round(),
                  ),
                  size: Size(double.infinity, SizeConfig.screenWidth! * 0.05),
                ),
              SizedBox(
                height: SizeConfig.padding12,
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
          Rect.fromLTWH(0, 0, size.width, 16),
          Radius.circular(SizeConfig.padding26),
        ),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              0, 0, getFilledWidth(size) == 0 ? 20 : getFilledWidth(size), 16),
          Radius.circular(SizeConfig.padding26),
        ),
        Paint()
          ..color = Color(0xff297264)
          ..style = PaintingStyle.fill);

    _drawText(canvas, size);
  }

  double getFilledWidth(Size size) => (size.width / minAmount) * netWorth;

  void _drawText(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: '₹$reamingAmount left',
      style: TextStyles.rajdhaniSB.body4.colour(Colors.black),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width - SizeConfig.padding10);
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
