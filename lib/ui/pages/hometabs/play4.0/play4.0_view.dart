import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/game%20components/gameCard.dart';
import 'package:felloapp/ui/widgets/game%20components/moreGames.dart';
import 'package:felloapp/ui/widgets/game%20components/trendingGames.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../util/styles/size_config.dart';
import '../../../widgets/button4.0/appBar_button.dart';

class PlayView extends StatefulWidget {
  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  List<String> _gameAssets = [
    'https://fello-assets.s3.ap-south-1.amazonaws.com/cricket-thumbnail-2022.png',
    'https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2FFootball-Kickoff-Thumbnail.jpg?alt=media&token=b046ff5f-f07d-47c3-acc7-71e0c2e0bdea',
    'https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/games%2FCandy%20Fiesta-Thumbnail.jpg?alt=media&token=19bfc19e-2f1d-457a-8350-dec9674a8269',
    'https://fello-assets.s3.ap-south-1.amazonaws.com/tambola-thumbnail-2022.png',
    'https://fello-assets.s3.ap-south-1.amazonaws.com/pool-club-thumbnail-2022.png',
  ];
  List<String> _gameName = [
    'Cricket',
    'Football',
    'Candy Fiesta',
    'Tamblo',
    'Pool Club'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Play',
          style: GoogleFonts.rajdhani(
            fontSize: SizeConfig.title1,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          AppBarButton(
            svgAsset: 'assets/svg/frame_svg.svg',
            coin: '20',
            borderColor: Colors.white10,
            screenWidth: SizeConfig.screenWidth * 0.18,
            onTap: () {},
            style: GoogleFonts.sourceSansPro(
              fontSize: SizeConfig.body2,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppBarButton(
            svgAsset: 'assets/svg/token_svg.svg',
            coin: '200',
            borderColor: Colors.white10,
            screenWidth: SizeConfig.screenWidth * 0.21,
            onTap: () {},
            style: GoogleFonts.sourceSansPro(
              fontSize: SizeConfig.body2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Haptic.vibrate();
                AppState.delegate.parseRoute(
                  Uri.parse(BaseUtil.gamesList[0].route),
                );
              },
              child: GameCard(),
            ),
            GameTitle(title: 'Trending'),
            SizedBox(
              height: SizeConfig.screenWidth * 0.588,
              width: SizeConfig.screenWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  return TrendingGames(
                    networkAsset: _gameAssets[index],
                    gameName: _gameName[index],
                  );
                },
              ),
            ),
            GameTitle(title: 'Enjoy more Games'),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 3,
              itemBuilder: (ctx, index) {
                return MoreGames(
                  assetURL: _gameAssets[index],
                  gameName: _gameName[index],
                );
              },
            ),
            //What to do on Play?
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.981,
              margin:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Text(
                    'What to do on Play?',
                    style: GoogleFonts.rajdhani(
                      fontSize: SizeConfig.title4,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  TitlesGames(
                    asset: '',
                    whiteText: 'Play Games ',
                    greyText: 'with the\ntokens won',
                    icon: SvgPicture.asset(
                      'assets/svg/play_ludo.svg',
                      height: SizeConfig.padding46,
                      width: SizeConfig.padding38,
                    ),
                    isLast: false,
                  ),
                  TitlesGames(
                    asset: 'assets/svg/play_leaderboard.svg',
                    whiteText: 'Play Games ',
                    greyText: 'with the\ntokens won',
                    icon: SvgPicture.asset(
                      'assets/svg/play_leaderboard.svg',
                      height: SizeConfig.padding70,
                      width: SizeConfig.padding35,
                    ),
                    isLast: false,
                  ),
                  TitlesGames(
                    asset: 'assets/svg/play_gift.svg',
                    whiteText: 'Play Games ',
                    greyText: 'with the\ntokens won',
                    icon: SvgPicture.asset(
                      'assets/svg/play_gift.svg',
                      height: SizeConfig.padding44,
                      width: SizeConfig.padding35,
                    ),
                    isLast: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
          ],
        ),
      ),
    );
  }
}

class GameTitle extends StatelessWidget {
  final String title;
  const GameTitle({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.padding24,
        top: SizeConfig.padding32,
        bottom: SizeConfig.padding20,
      ),
      child: Text(
        title,
        style: GoogleFonts.sourceSansPro(
            fontSize: SizeConfig.title4,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
    );
  }
}

class Stepper extends StatelessWidget {
  const Stepper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Column(
        children: [
          for (var val = 0; val < 5; val++)
            Container(
              margin: EdgeInsets.all(2.0),
              height: (val == 0 || val == 4) ? 3 : 5,
              width: 1.5,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class TitlesGames extends StatelessWidget {
  final String greyText, whiteText, asset;
  final Widget icon;
  final bool isLast;
  TitlesGames({
    this.asset,
    this.greyText,
    this.icon,
    this.whiteText,
    this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(
              width: SizeConfig.padding20,
            ),
            RichText(
              text: TextSpan(
                text: whiteText,
                style: GoogleFonts.sourceSansPro(
                  fontSize: SizeConfig.body3,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: greyText,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: SizeConfig.body3,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) Stepper(),
      ],
    );
  }
}
