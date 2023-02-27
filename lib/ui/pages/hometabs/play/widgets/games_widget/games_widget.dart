import 'dart:ui';

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
        if (model.isGamesListDataLoading || prop?.userFundWallet == null)
          return Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins / 2),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
              itemBuilder: (ctx, index) {
                return TrendingGamesShimmer();
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .63,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
            ),
          );

        final _viewModel = GameViewModel.fromGameTier(model.gameTier!)
          ..processData();
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

  final GameTier gameTier;
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
                              game: model.gamesListData!.firstWhere(
                                  (element) => element.code == e?.code),
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

class _LockedState extends StatefulWidget {
  const _LockedState({super.key, required this.gameTier});
  final GameTier gameTier;

  @override
  State<_LockedState> createState() => _LockedStateState();
}

class _LockedStateState extends State<_LockedState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700))
          ..forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
            begin: Alignment.bottomCenter,
            stops: [widget.gameTier.shadow, 1],
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
                    widget.gameTier.winningText,
                    style: TextStyles.rajdhaniSB.body0,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding6,
              ),
              Text(
                widget.gameTier.winningSubtext,
                style: TextStyles.rajdhaniSB.body4,
              ),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              if (widget.gameTier.showProgressIndicator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        builder: (context, child) {
                          return CustomPaint(
                            foregroundPainter: CustomProgressBar(
                                widget.gameTier.level * 1.0,
                                widget.gameTier.netWorth,
                                widget.gameTier.amountToCompleteLevel.round(),
                                _controller),
                          );
                        },
                        animation: _controller,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      "₹" +
                          widget.gameTier.amountToCompleteLevel
                              .round()
                              .toString() +
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
  final AnimationController controller;
  CustomProgressBar(
      this.minAmount, this.netWorth, this.reamingAmount, this.controller);
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
              0,
              -8,
              lerpDouble(
                  0,
                  getFilledWidth(size) == 0 ? 20 : getFilledWidth(size),
                  controller.value)!,
              16),
          Radius.circular(SizeConfig.padding26),
        ),
        Paint()
          ..color = Color(0xff297264)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
