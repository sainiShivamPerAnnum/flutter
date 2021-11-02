import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard();
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
          horizontal: SizeConfig.globalMargin,
          vertical: SizeConfig.blockSizeHorizontal * 2,
        ),
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.03),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
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
              style: TextStyle(
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
                                      style: TextStyle(
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
                                      style: TextStyle(
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
    int length = type == "Prize"
        ? baseProvider.prizeLeaders.length
        : baseProvider.referralLeaders.length;
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
            style: TextStyle(
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
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
        trailing: Text(
          type == "Prize"
              ? "₹ ${baseProvider.prizeLeaders[i].totalWin.toString()}"
              : "₹ ${(baseProvider.referralLeaders[i].refCount * Constants.REFERRAL_AMT_BONUS).toString()}",
          style: TextStyle(
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
