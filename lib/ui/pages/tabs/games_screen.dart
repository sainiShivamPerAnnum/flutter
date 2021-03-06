import 'package:felloapp/ui/pages/root.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:felloapp/ui/elements/Parallax-card/travel_card_list.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'package:felloapp/ui/elements/week-winners.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/util/size_config.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Game> _gameList;
  Game _currentGame;
  int currentGame;
  PageController _controller = new PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    var data = DemoData();
    _gameList = data.getCities();
    _currentGame = _gameList[1];
    currentGame = 0;
  }

  void _handleCityChange(Game game) {
    setState(() {
      this._currentGame = game;
    });
  }

  void setPage() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff1f1f1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/game-asset.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                currentGame = page;
              });
            },
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: AppBar().preferredSize.height * 1.5,
                      ),
                      TicketCount(),
                      Expanded(
                        flex: 5,
                        child: GameCardList(
                          games: _gameList,
                          onGameChange: _handleCityChange,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GameOfferCardList(),
                      ),
                    ],
                  )),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: AppBar().preferredSize.height,
                    ),
                    WeekWinnerBoard(),
                    Leaderboard(),
                  ],
                ),
              )
            ],
          ),
          currentGame == 0
              ? Positioned(
                  bottom: 10,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swap_vert_circle_outlined,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "SWIPE",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Swipe up to see prizes and leaderboards",
                          style: GoogleFonts.montserrat(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class TicketCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "5",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.screenHeight * 0.08,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "Tickets",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: SizeConfig.mediumTextSize),
          ),
        ],
      ),
    );
  }
}

class GameOfferCardList extends StatefulWidget {
  @override
  _GameOfferCardListState createState() => _GameOfferCardListState();
}

class _GameOfferCardListState extends State<GameOfferCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          GameCard(
            gradient: [
              Color(0xffACB6E5),
              Color(0xff74EBD5),
            ],
            title: "Want more tickets?",
            action: [
              GameOfferCardButton(
                onPressed: () {},
                title: "Invest",
              ),
              SizedBox(
                width: 10,
              ),
              GameOfferCardButton(
                onPressed: () {},
                title: "Share",
              ),
            ],
          ),
          GameCard(
            gradient: [
              Color(0xffD4AC5B),
              Color(0xffDECBA4),
            ],
            title: "Vote for your next game on fello.",
            action: [],
          )
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title, buttonText;
  final List<Color> gradient;
  final List<Widget> action;

  GameCard({this.buttonText, this.title, this.gradient, this.action});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.screenHeight * 0.05,
        left: width * 0.05,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
            colors: gradient,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: gradient[1].withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ]),
      width: width * 0.8,
      child: Stack(
        children: [
          // Positioned(
          //   right: 10,
          //   bottom: 0,
          //   child: Opacity(
          //     opacity: 0.3,
          //     child: Image.asset(
          //       asset,
          //       height: height * 0.25,
          //       width: width * 0.5,
          //     ),
          //   ),
          // ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(5, 5),
                          color: Colors.black26,
                          blurRadius: 10,
                        )
                      ],
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.06),
                ),
                Row(
                  children: action,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GameOfferCardButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  GameOfferCardButton({this.onPressed, this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          color: Colors.transparent,
          // boxShadow: [
          //   BoxShadow(
          //       color: gradient[0].withOpacity(0.2),
          //       blurRadius: 20,
          //       offset: Offset(5, 5),
          //       spreadRadius: 10),
          // ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          title,
          style: GoogleFonts.montserrat(
              color: Colors.white, fontSize: SizeConfig.mediumTextSize),
        ),
      ),
    );
  }
}
