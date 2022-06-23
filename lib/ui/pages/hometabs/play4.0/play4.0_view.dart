import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/game%20components/gameCard.dart';
import 'package:felloapp/ui/widgets/game%20components/moreGames.dart';
import 'package:felloapp/ui/widgets/game%20components/trendingGames.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../util/styles/size_config.dart';
import '../../../widgets/button4.0/appBar_button.dart';

class PlayView extends StatefulWidget {
  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Play',
          style: GoogleFonts.rajdhani(
            fontSize: 35,
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
              fontSize: 16,
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
              fontSize: 16,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Trending',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenWidth * 0.536,
              width: SizeConfig.screenWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (ctx, index) {
                  return TrendingGames();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Enjoy more Games',
                style: GoogleFonts.sourceSansPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 3,
                itemBuilder: (ctx, index) {
                  return MoreGames();
                },
              ),
            ),
            //What to do on Play?
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.981,
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'What to do on Play?',
                    style: GoogleFonts.rajdhani(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesGames(
                        asset: 'assets/images/play_01.png',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19.0),
                        child: Stepper(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesGames(
                        asset: 'assets/images/play_02.png',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19.0),
                        child: Stepper(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesGames(
                        asset: 'assets/images/play_03.png',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19.0),
                        child: Stepper(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return Column(
      children: [
        for (var val = 0; val < 5; val++)
          Container(
            margin: EdgeInsets.all(2.0),
            height: 5,
            width: 2,
            color: Colors.white,
          ),
      ],
    );
  }
}

class TitlesGames extends StatelessWidget {
  final String greyText, whiteText, asset;
  TitlesGames({
    this.asset,
    this.greyText,
    this.whiteText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.498,
      height: SizeConfig.screenWidth * 0.122,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            asset,
            height: SizeConfig.screenWidth * 0.122,
          ),
          RichText(
            text: TextSpan(
              text: whiteText,
              style: GoogleFonts.sourceSansPro(
                fontSize: 14,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: greyText,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
