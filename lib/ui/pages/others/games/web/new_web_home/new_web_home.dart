import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NewWebHomeView extends StatefulWidget {
  const NewWebHomeView({Key key, @required this.game}) : super(key: key);
  final String game;

  @override
  State<NewWebHomeView> createState() => _NewWebHomeViewState();
}

class _NewWebHomeViewState extends State<NewWebHomeView> {
  // dummy bg color and text
  List<Color> _color = [
    Color(0xff5948B2),
    Color(0xff9A3538),
  ];
  List<String> _text = [
    '100',
    '200',
  ];
  @override
  Widget build(BuildContext context) {
    return BaseView<WebHomeViewModel>(
      onModelReady: (model) {
        model.newInit(widget.game);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.refreshLeaderboard(),
          child: Scaffold(
           // backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                NewSquareBackground(),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 300,
                      stretch: true,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: [
                          StretchMode.blurBackground,
                          StretchMode.zoomBackground,
                        ],
                        background: Image.asset(
                          'assets/images/game.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      actions: [
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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: SizeConfig.screenWidth * 0.266,
                                width: SizeConfig.screenWidth * 0.266,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage('assets/images/game.png'),
                                  ),
                                ),
                              ),
                              Text(
                                'Cricket',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  RewardStatus(
                                    coin: '2K+',
                                    coinText: 'playing',
                                    assetHeight: 8.0,
                                    assetUrl: 'assets/images/reward_icon01.png',
                                  ),
                                  RewardStatus(
                                    coin: '25K',
                                    coinText: 'Win upto',
                                    assetHeight: 18.0,
                                    assetUrl: 'assets/images/reward_icon02.png',
                                  ),
                                  RewardStatus(
                                    coin: '30',
                                    coinText: 'playing',
                                    assetHeight: 18.0,
                                    assetUrl: 'assets/images/token_logo.png',
                                  ),
                                ],
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 0.874,
                                height: SizeConfig.screenWidth * 0.117,
                                child: Text(
                                  'Swing your wicket, throw fast pitches, and win upto ?\nRs. 25,000 in one of our many free, online games!',
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 14,
                                    color: Color(0xff39393C),
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          RewardLeaderboardView(game: widget.game),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  'Recharge Options',
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenWidth * 0.277,
                                width: SizeConfig.screenWidth,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (ctx, i) {
                                    if (i == 2) {
                                      return Container(
                                        margin: EdgeInsets.all(8.0),
                                        height: SizeConfig.screenWidth * 0.277,
                                        width: SizeConfig.screenWidth * 0.317,
                                        color: Color(0xff39393C),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: SizeConfig.screenWidth * 0.081,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              'Custom',
                                              style: GoogleFonts.sourceSansPro(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return RechargeBox(
                                      bgColor: _color[i],
                                      coin: _text[i],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RechargeBox extends StatelessWidget {
  final Color bgColor;
  final String coin;

  const RechargeBox({Key key, this.bgColor, this.coin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: SizeConfig.screenWidth * 0.277,
      width: SizeConfig.screenWidth * 0.317,
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            width: SizeConfig.screenWidth * 0.148,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/token_svg.svg',
                  ),
                  Text(
                    coin,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.085,
            width: SizeConfig.screenWidth * 0.261,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0)),
            child: Center(
              child: Text(
                '₹$coin',
                style: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.38,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardStatus extends StatelessWidget {
  final String coin, coinText, assetUrl;
  final double assetHeight;

  const RewardStatus({
    Key key,
    this.coin,
    this.coinText,
    this.assetHeight,
    this.assetUrl,
  }) : super(key: key);
  // const RewardStatus({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.155,
      height: SizeConfig.screenWidth * 0.120,
      child: Column(
        children: [
          Row(
            children: [
              //logo
              Image.asset(
                assetUrl,
                height: assetHeight,
              ),
              //text
              Text(
                coin,
                style: GoogleFonts.sourceSansPro(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          //text
          Text(
            coinText,
            style: GoogleFonts.sourceSansPro(
              fontSize: 14,
              color: Color(0xff39393C),
            ),
          ),
        ],
      ),
    );
  }
}
