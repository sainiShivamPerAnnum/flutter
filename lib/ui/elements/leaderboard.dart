import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/PrizeLeader.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/model/PrizeLeader.dart';
import '../../core/model/ReferralLeader.dart';
import '../../util/size_config.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  int currentPage = 0;
  DBModel dbProvider;
  BaseUtil baseProvider;
  bool isPrizeLeadersLoading = false;
  bool isReferralLeadersLoading = false;
  PageController _pageController = new PageController(initialPage: 0);
  ScrollController _controller;

  viewpage(int index) {
    setState(() {
      currentPage = index;
      _pageController.animateToPage(currentPage,
          duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    });
  }

  Future<void> getPrizeLeaderBoardData() async {
    baseProvider.prizeLeaders = await dbProvider.getPrizeLeaderboard();
    baseProvider.isPrizeLeadersFetched = true;
    print("prizeleaders length: " + baseProvider.prizeLeaders.toString());
    baseProvider.prizeLeaders.sort((a, b) => a.totalWin.compareTo(b.totalWin));
    if (isPrizeLeadersLoading) {
      setState(() {
        isPrizeLeadersLoading = false;
      });
    }
  }

  Future<void> getReferralLeaderBoardData() async {
    baseProvider.referralLeaders = await dbProvider.getReferralLeaderboard();
    baseProvider.isReferralLeadersFetched = true;
    baseProvider.referralLeaders
        .sort((a, b) => a.refCount.compareTo(b.refCount));

    if (isReferralLeadersLoading) {
      setState(() {
        isReferralLeadersLoading = false;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.isPrizeLeadersFetched == false) {
      isPrizeLeadersLoading = true;
      setState(() {});
      getPrizeLeaderBoardData();
    }
    if (baseProvider.isReferralLeadersFetched == false) {
      isReferralLeadersLoading = true;
      setState(() {});
      getReferralLeaderBoardData();
    }
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenWidth * 0.02,
        ),
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.03),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: new LinearGradient(
              colors: [Color(0xff0F2027), Color(0xff203A43), Color(0xff2C5364)],
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
                fontSize: SizeConfig.screenHeight * 0.024,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            isPrizeLeadersLoading && isReferralLeadersLoading
                ? SizedBox()
                : Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => viewpage(0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: currentPage == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              "Prizes",
                              style: currentPage == 0
                                  ? TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => viewpage(1),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: currentPage == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              "Referrals",
                              style: currentPage == 1
                                  ? TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      fontWeight: FontWeight.w700)
                                  : TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "images/leaderboard.png",
                          height: SizeConfig.screenHeight * 0.3,
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: PageView(
                      controller: _pageController,
                      // physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (int page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      children: [
                        isPrizeLeadersLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : (baseProvider.prizeLeaders.length != 0
                                ? Scrollbar(
                                    thickness: 20,
                                    radius: Radius.circular(100),
                                    showTrackOnHover: true,
                                    hoverThickness: 10,
                                    isAlwaysShown: true,
                                    controller: _controller,
                                    child: SingleChildScrollView(
                                      controller: _controller,
                                      child: Column(
                                        children: [
                                          // TopThree(
                                          //   winners: [
                                          //     "Rahul Senapati Dixit Senapati Dixit",
                                          //     "Mohit Senapati Dixit Senapati Dixit",
                                          //     "Ronit Senapati Dixit"
                                          //   ],
                                          // ),
                                          Column(
                                              children:
                                                  buildLeaderBoardList("Prize"))
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Leaders will be updated soon.",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                  )),
                        isReferralLeadersLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : (baseProvider.referralLeaders.length != 0
                                ? Scrollbar(
                                    thickness: 20,
                                    radius: Radius.circular(100),
                                    showTrackOnHover: true,
                                    hoverThickness: 10,
                                    isAlwaysShown: true,
                                    controller: _controller,
                                    child: SingleChildScrollView(
                                      controller: _controller,
                                      child: Column(
                                        children: [
                                          // TopThree(
                                          //   winners: [
                                          //     "Rahul Senapati Dixit Senapati Dixit",
                                          //     "Mohit Senapati Dixit Senapati Dixit",
                                          //     "Ronit Senapati Dixit"
                                          //   ],
                                          // ),
                                          Column(
                                              children: buildLeaderBoardList(
                                                  "Referrals"))
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Leaders will be updated soon.",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                  )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildLeaderBoardList(String type) {
    List<ListTile> leaderBoardItems = [];
    int length = type == "Prize" ? baseProvider.prizeLeaders.length : baseProvider.referralLeaders.length;
    for (int i = length - 1; i > -1; i--) {
      leaderBoardItems.add(ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
          vertical: SizeConfig.blockSizeVertical * 0.8,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            '#${length - i}',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.mediumTextSize,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          type == "Prize"
              ? "${baseProvider.prizeLeaders[i].name[0].toUpperCase()}${baseProvider.prizeLeaders[i].name.substring(1).toLowerCase()}"
              : "${baseProvider.referralLeaders[i].name[0].toUpperCase()}${baseProvider.referralLeaders[i].name.substring(1).toLowerCase()}",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
        trailing: Text(
          type == "Prize"
              ? "₹ ${baseProvider.prizeLeaders[i].totalWin.toString()}"
              : "₹ ${(baseProvider.referralLeaders[i].refCount * 25).toString()}",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: SizeConfig.largeTextSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));
    }
    return leaderBoardItems;
  }
}

// class TopThree extends StatelessWidget {
//   List<String> winners;

//   TopThree({this.winners});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: SizeConfig.screenHeight * 0.3,
//       padding: EdgeInsets.all(
//         SizeConfig.blockSizeHorizontal * 2,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: SizeConfig.screenWidth * 0.2,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 5,
//                       color: Color(0xffB4ADA5),
//                     ),
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           "https://images.fineartamerica.com/images/artworkimages/mediumlarge/3/doremon-deepak-pengoria.jpg"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   winners[0],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.montserrat(
//                     color: Colors.white,
//                     fontSize: SizeConfig.mediumTextSize,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Text(
//                     "₹ 200",
//                     style: GoogleFonts.montserrat(
//                       color: Colors.white,
//                       fontSize: SizeConfig.mediumTextSize,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   height: SizeConfig.screenWidth * 0.3,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 8,
//                       color: Color(0xffFFB96B),
//                     ),
//                     shape: BoxShape.circle,
//                     // borderRadius: BorderRadius.circular(100),
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           "https://static.wikia.nocookie.net/danmacgregor/images/4/42/0090%27snoddy.jpg/revision/latest/scale-to-width-down/340?cb=20140826131725"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   winners[1],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.montserrat(
//                     color: Colors.white,
//                     fontSize: SizeConfig.mediumTextSize,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Text(
//                     "₹ 500",
//                     style: GoogleFonts.montserrat(
//                       color: Colors.white,
//                       fontSize: SizeConfig.largeTextSize,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: SizeConfig.screenWidth * 0.16,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 5,
//                       color: Color(0xff754F24),
//                     ),
//                     shape: BoxShape.circle,
//                     // borderRadius: BorderRadius.circular(100),
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           "https://images-na.ssl-images-amazon.com/images/I/611wqa%2BCF-L._AC_SL1500_.jpg"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   winners[2],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.montserrat(
//                     color: Colors.white,
//                     fontSize: SizeConfig.mediumTextSize,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Text(
//                     "₹ 80",
//                     style: GoogleFonts.montserrat(
//                         color: Colors.white,
//                         fontSize: SizeConfig.largeTextSize),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
