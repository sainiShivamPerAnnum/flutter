import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:felloapp/ui/elements/Parallax-card/travel_card_list.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'package:felloapp/ui/elements/week-winners.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<City> _cityList;
  City _currentCity;

  @override
  void initState() {
    super.initState();
    var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList[1];
  }

  void _handleCityChange(City city) {
    setState(() {
      this._currentCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            height: height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/game-asset.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: ListView(
                  children: [
                    Container(
                      height: height * 0.08,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // McCountingText(
                          //   begin: 0,
                          //   end: 5,
                          //   style: GoogleFonts.montserrat(
                          //     color: Colors.white,
                          //     fontSize: height * 0.08,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          //   duration: Duration(seconds: 1),
                          //   curve: Curves.decelerate,
                          // ),
                          Text(
                            "5",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: height * 0.08,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Tickets",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TravelCardList(
                      cities: _cityList,
                      onCityChange: _handleCityChange,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      width: width,
                      height: height * 0.15,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: [
                          GameCard(
                            gradient: [
                              Color(0xffACB6E5),
                              Color(0xff74EBD5),
                            ],
                            onPressed: () {},
                            title: "Add more Tambola tickets",
                          ),
                          GameCard(
                            gradient: [
                              Color(0xffD4AC5B),
                              Color(0xffDECBA4),
                            ],
                            onPressed: () {},
                            title: "Vote for your next game on fello.",
                          )
                        ],
                      ),
                    ),
                    WeekWinnerBoard(),
                    Leaderboard(),
                  ],
                )),
          ),
          // Positioned(
          //   bottom: 10,
          //   left: width * 0.32,
          //   child: Container(
          //     child: Column(
          //       children: [
          //         Icon(
          //           Icons.swap_vert_circle_outlined,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Text(
          //           "SWIPE",
          //           style: GoogleFonts.montserrat(
          //             fontSize: 16,
          //           ),
          //         ),
          //         Text(
          //           "Swipe up to see prizes and leaderboards",
          //           style: GoogleFonts.montserrat(
          //             fontSize: 8,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title, buttonText;
  final Function onPressed;
  final List<Color> gradient;

  GameCard({this.buttonText, this.onPressed, this.title, this.gradient});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
        right: width * 0.05,
      ),
      height: height * 0.2,
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
                // GestureDetector(
                //   onTap: onPressed,
                //   child: Container(
                //     padding: EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         width: 2,
                //         color: Colors.white,
                //       ),
                //       color: Colors.transparent,
                //       boxShadow: [
                //         BoxShadow(
                //             color: gradient[0].withOpacity(0.2),
                //             blurRadius: 20,
                //             offset: Offset(5, 5),
                //             spreadRadius: 10),
                //       ],
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //     child: Text(
                //       buttonText,
                //       style: GoogleFonts.montserrat(
                //           color: Colors.white, fontSize: width * 0.035),
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
