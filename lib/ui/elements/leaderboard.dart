import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  int currentPage = 0;
  PageController _pageController = new PageController(initialPage: 0);
  viewpage(int index) {
    setState(() {
      currentPage = index;
      _pageController.animateToPage(currentPage,
          duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      padding: EdgeInsets.only(top: height * 0.03),
      height: height * 0.4,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: new LinearGradient(
            colors: [
              Color(0xffFF9595),
              Color(0xff53C091),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xffFF9595).withOpacity(0.3),
              offset: Offset(0, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0xff53C091).withOpacity(0.3),
              offset: Offset(5, 0),
              blurRadius: 10,
            ),
          ]),
      child: Column(
        children: [
          Text(
            "Leaderboard",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: height * 0.024,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => viewpage(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          currentPage == 0 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Prizes",
                      style: currentPage == 0
                          ? TextStyle(fontSize: 22, fontWeight: FontWeight.w700)
                          : TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => viewpage(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          currentPage == 1 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Referrals",
                      style: currentPage == 1
                          ? TextStyle(fontSize: 22, fontWeight: FontWeight.w700)
                          : TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                controller: _pageController,
                // physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [
                  Container(
                    height: height * 0.3,
                    padding: EdgeInsets.all(
                      height * 0.02,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: width * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Color(0xffB4ADA5),
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://images.fineartamerica.com/images/artworkimages/mediumlarge/3/doremon-deepak-pengoria.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Username",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: height * 0.016,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "200",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: height * 0.016,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: width * 0.3,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Color(0xffFFB96B),
                                  ),
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://static.wikia.nocookie.net/danmacgregor/images/4/42/0090%27snoddy.jpg/revision/latest/scale-to-width-down/340?cb=20140826131725"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Username",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: height * 0.016,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "500",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: height * 0.016,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: width * 0.16,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Color(0xff754F24),
                                  ),
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://images-na.ssl-images-amazon.com/images/I/611wqa%2BCF-L._AC_SL1500_.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Username",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: height * 0.016,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "80",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: height * 0.016,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          ExpansionTile(
            title: Text(
              "See All Winners",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: height * 0.012,
              ),
            ),
          )
        ],
      ),
    );
  }
}
