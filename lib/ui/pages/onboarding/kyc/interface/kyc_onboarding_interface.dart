import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/instructions_tab.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboard_data.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/summary_tab.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycOnboardInterface extends StatefulWidget {
  @override
  _KycOnboardInterfaceState createState() => _KycOnboardInterfaceState();
}

class _KycOnboardInterfaceState extends State<KycOnboardInterface>
    with SingleTickerProviderStateMixin {
  double sliderPos = 10;
  PageController _pageController = new PageController();
  int currentPage = 0;
  double _pollHeight = 0;
  BaseUtil baseProvider;
  DBModel dbProvider;
  List stepStatus = [];
  bool kycDetailsFetched = false;
  AnimationController _rippleController;
  final GlobalKey<ScaffoldState> _kycOnboardScaffoldKey =
      GlobalKey<ScaffoldState>();
  KYCModel kycModel = KYCModel();
  bool isSummChecked = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStepStatus();
      getReadStatus();
    });
    _rippleController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  _slide(int pos, double deviceWidth) {
    setState(() {
      if (pos == 1) {
        sliderPos = 10;
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      } else if (pos == 2) {
        sliderPos = deviceWidth * 0.33;
        _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      } else if (pos == 3) {
        sliderPos = deviceWidth * 0.66;
        _pageController.animateToPage(
          2,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      }
    });
  }

  delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("summCheck", null);
  }

  _animatePoll(List stepStatus) {
    print(stepStatus);
    int i = 0;
    int stepsReached = 0;
    while (stepStatus[i] == 1) {
      i++;
      stepsReached++;
    }
    setState(() {
      _pollHeight = 132.0 * stepsReached;
    });
  }

  getStepStatus() async {
    await kycModel.init();
    baseProvider.kycDetail =
        await dbProvider.getUserKycDetails(baseProvider.myUser.uid);
    _animatePoll(baseProvider.kycDetail.isStepComplete);
    kycDetailsFetched = true;
    setState(() {});
  }

  getReadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("summCheck") == null) {
      prefs.setBool("summCheck", true);
      setState(() {
        isSummChecked = true;
      });
    } else {
      setState(() {
        isSummChecked = false;
      });
    }
  }

  double _calculateProgress(List stepStatus) {
    int i = 0;
    int stepsCompleted = 0;
    while (stepStatus[i] == 1) {
      i++;
      stepsCompleted++;
    }
    return stepsCompleted * 1.0;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context,listen:false);
    dbProvider = Provider.of<DBModel>(context,listen:false);
    return Scaffold(
      key: _kycOnboardScaffoldKey,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xff9ad3bc),
                  expandedHeight: _height * 0.5,
                  floating: false,
                  elevation: 0,
                  pinned: true,
                  title: Text(
                    "  KYC Verification",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      width: MediaQuery.of(context).size.width,
                      height: _height * 0.5,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SafeArea(
                              minimum: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top +
                                      kToolbarHeight),
                              child: Image.asset("images/kyc_unavailable.png"),
                            ),
                          ),
                          Container(
                              width: _width,
                              padding: EdgeInsets.symmetric(
                                horizontal: _width * 0.1,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Get Your KYC Done",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff00587a),
                                      fontSize: _width * 0.09,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Complete your KYC once and invest anywhere afterwards.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff00587a),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height * 0.03,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            body: Container(
                width: _width,
                height: _height,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: _height * 0.05,
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            bottom: 0,
                            left: sliderPos,
                            child: Container(
                              height: 5,
                              width: _width * 0.3,
                              decoration: BoxDecoration(
                                color: UiConstants.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            duration: Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.decelerate,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => _slide(1, _width),
                                  child: Text(
                                    "Application",
                                    style: currentPage == 0
                                        ? TextStyle(
                                            fontSize: 22,
                                            color: KycOnboardData.titleColor,
                                            fontWeight: FontWeight.w700)
                                        : TextStyle(
                                            fontSize: 18,
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    isSummChecked = false;
                                    _slide(2, _width);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Summary",
                                        style: currentPage == 1
                                            ? TextStyle(
                                                fontSize: 22,
                                                color:
                                                    KycOnboardData.titleColor,
                                                fontWeight: FontWeight.w700)
                                            : TextStyle(
                                                fontSize: 18,
                                              ),
                                      ),
                                      isSummChecked
                                          ? CircleAvatar(
                                              radius: 3,
                                              backgroundColor:
                                                  UiConstants.primaryColor,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _slide(3, _width),
                                  child: Text(
                                    "Instructions",
                                    style: currentPage == 2
                                        ? TextStyle(
                                            fontSize: 22,
                                            color: KycOnboardData.titleColor,
                                            fontWeight: FontWeight.w700)
                                        : TextStyle(
                                            fontSize: 18,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          children: [
                            SingleChildScrollView(
                              child: Container(
                                width: _width,
                                height: 10 * 145.0,
                                padding: EdgeInsets.only(left: 5, right: 10),
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 5000,
                                      ),
                                      width: 5,
                                      height: _pollHeight,
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [
                                            UiConstants.primaryColor,
                                            UiConstants.primaryColor
                                                .withGreen(160),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 22,
                                        top: 55,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Column(
                                            children: kycDetailsFetched
                                                ? _createCardList(baseProvider
                                                    .kycDetail.isStepComplete)
                                                : [
                                                    Padding(
                                                      //Loader
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 200,
                                                        child: Center(
                                                          child: SpinKitWave(
                                                            color: UiConstants
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SummaryTab(),
                            InstructionsTab(),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
            right: 20,
            top: _height * 0.013,
            child: SafeArea(
              child: Container(
                width: 130,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: UiConstants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: kycDetailsFetched
                          ? _calculateProgress(
                                  baseProvider.kycDetail.isStepComplete) /
                              10
                          : 0.0,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: UiConstants.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                          "${kycDetailsFetched ? _calculateProgress(baseProvider.kycDetail.isStepComplete) * 10 : [
                              0
                            ]}% Completed"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _createCardList(List stepStatus) {
    List<Widget> cardList = [];
    for (int i = 0; i < 10; i++) {
      cardList.add(
        _stepCard(stepStatus[i], i),
      );
    }
    return cardList;
  }

  _stepCard(int status, int level) {
    Color _cardColor;
    String _cardText;
    if (status == 2) {
      _cardColor = UiConstants.primaryColor;
      _cardText = "Start";
    } else if (status == 0) {
      _cardColor = Colors.grey;
      _cardText = "Incomplete";
    } else if (status == 1) {
      _cardColor = UiConstants.primaryColor;
      _cardText = "Completed";
    } else if (status == -1) {
      _cardColor = Colors.amber;
      _cardText = "Retry";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          child: status == 2
              ? _buildBody(
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          _cardColor,
                          _cardColor.withGreen(160),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  _cardColor)
              : Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        _cardColor,
                        _cardColor.withGreen(160),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await KycOnboardData()
                  .stepButtonAction(
                      level, _kycOnboardScaffoldKey.currentContext)
                  .then((value) {
                print(value);
                setState(() {});
              });
            },
            child: level == 9
                ? Container(
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage("images/scratch-card.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 50,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "REWARD",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: _cardColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: _cardColor.withOpacity(0.05),
                    ),
                    child: Center(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title:
                            Text(KycOnboardData.stageCardData[level]["title"]),
                        subtitle: Text(
                            KycOnboardData.stageCardData[level]["subtitle"]),
                        trailing: Text(
                          _cardText + "    ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _cardColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        )
      ],
    );
  }

// RIPPLE EFFECT BUILD

  Widget _buildBody(Widget core, Color rippleColor) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
          parent: _rippleController, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(30 * _rippleController.value, rippleColor),
            _buildContainer(35 * _rippleController.value, rippleColor),
            _buildContainer(40 * _rippleController.value, rippleColor),
            _buildContainer(45 * _rippleController.value, rippleColor),
            _buildContainer(50 * _rippleController.value, rippleColor),
            Align(child: core),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius, Color rippleColor) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: rippleColor.withOpacity(1 - _rippleController.value),
      ),
    );
  }
}
