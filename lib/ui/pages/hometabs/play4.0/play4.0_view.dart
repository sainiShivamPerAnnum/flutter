import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/game%20components/gameCard.dart';
import 'package:felloapp/ui/widgets/game%20components/gameTitle.dart';
import 'package:felloapp/ui/widgets/game%20components/moreGames.dart';
import 'package:felloapp/ui/widgets/game%20components/titlesGames.dart';
import 'package:felloapp/ui/widgets/game%20components/trendingGames.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User _firebaseUser;
  final _logger = locator<CustomLogger>();
  Future<String> _getBearerToken() async {
    String token = await _firebaseUser.getIdToken();
    _logger.d(token);
    return token;
  }

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
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    try {
      final token = await _getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath().kGames,
        token: token,
      );
      _logger.d('Justin: ${response.body}');
      print('Justin: ${response.body}');
    } catch (e) {
      _logger.d('Justin: $e');
      print("Justin: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Play',
          style: TextStyles.rajdhaniSB.title1,
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
            style: TextStyles.sourceSansSB.body2,
          ),
          AppBarButton(
            svgAsset: 'assets/svg/token_svg.svg',
            coin: '200',
            borderColor: Colors.white10,
            screenWidth: SizeConfig.screenWidth * 0.21,
            onTap: () {},
            style: TextStyles.sourceSansSB.body2,
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
              child: NewGameCard(),
            ),
            GameTitle(title: 'Trending'),
            SizedBox(
              //need to fix here
              height: SizeConfig.screenWidth * 0.522,
              width: SizeConfig.screenWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  return TrendingGames(
                    thumbnailUrl: _gameAssets[index],
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
                  thumbnailUrl: _gameAssets[index],
                  gameName: _gameName[index],
                );
              },
            ),
            //What to do on Play?
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.981,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
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
                    style: TextStyles.rajdhaniSB.title4,
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





