import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboard_data.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KycOnboardInterface extends StatefulWidget {
  @override
  _KycOnboardInterfaceState createState() => _KycOnboardInterfaceState();
}

class _KycOnboardInterfaceState extends State<KycOnboardInterface> {
  double sliderPos = 10;
  PageController _pageController = new PageController();
  int currentPage = 0;
  double _pollHeight = 0;
  int level = 5;
  KycOnboardData kycGuide = new KycOnboardData();

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

  _animatePoll(int level) {
    setState(() {
      _pollHeight = 130.0 * kycGuide.level;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animatePoll(level - 1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    // centerTitle: true,
                    // title: SafeArea(
                    //   child: Container(
                    //     height: 100,
                    //     width: double.infinity,
                    //     child: Text(
                    //       "KYC Verification",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      width: MediaQuery.of(context).size.width,
                      height: _height * 0.5,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            Colors.white.withOpacity(1),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        children: [
                          SafeArea(
                            minimum: EdgeInsets.all(_height * 0.1),
                            child: Lottie.asset("images/verification.json"),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                                width: _width,
                                padding: EdgeInsets.symmetric(
                                  horizontal: _width * 0.1,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Your KYC Done",
                                      style: TextStyle(
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
                                      style: TextStyle(
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
                          ),
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
                                    style: TextStyle(
                                      fontWeight: currentPage == 0
                                          ? FontWeight.w700
                                          : FontWeight.w300,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _slide(2, _width),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                      fontWeight: currentPage == 1
                                          ? FontWeight.w700
                                          : FontWeight.w300,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _slide(3, _width),
                                  child: Text(
                                    "Requirements",
                                    style: TextStyle(
                                      fontWeight: currentPage == 2
                                          ? FontWeight.w700
                                          : FontWeight.w300,
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
                                height: 8 * 145.0,
                                padding: EdgeInsets.only(left: 5, right: 10),
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 8000,
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
                                            children: [
                                              StepCard(
                                                status: 1,
                                                level: 0,
                                              ),
                                              StepCard(
                                                status: 1,
                                                level: 1,
                                              ),
                                              StepCard(
                                                status: -1,
                                                level: 2,
                                              ),
                                              StepCard(
                                                status: 1,
                                                level: 3,
                                              ),
                                              StepCard(
                                                status: 1,
                                                level: 4,
                                              ),
                                              StepCard(
                                                status: 0,
                                                level: 5,
                                              ),
                                              StepCard(
                                                status: 0,
                                                level: 6,
                                              ),
                                              StepCard(
                                                status: 0,
                                                level: 7,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   margin: EdgeInsets.only(
                                        //     top: 40,
                                        //     left: 10,
                                        //     right: 5,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     borderRadius:
                                        //         BorderRadius.circular(20),
                                        //   ),
                                        //   child:
                                        // )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: _width,
                              child: Image.network(
                                "https://i.redd.it/vdx6ey95lu211.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: _width,
                              child: Image.network(
                                "https://static.zerochan.net/Ryuk.full.2728160.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                      widthFactor: 0.125 * kycGuide.level,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: UiConstants.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Center(
                      child: Text("${kycGuide.level * 12.5}% Completed"),
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
}

class StepCard extends StatefulWidget {
  final int status;
  final int level;

  StepCard({@required this.status, @required this.level});

  @override
  _StepCardState createState() => _StepCardState();
}

class _StepCardState extends State<StepCard>
    with SingleTickerProviderStateMixin {
  Color _focusColor;
  KycOnboardData kycGuide = new KycOnboardData();

  String text;

  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 0 || widget.level > kycGuide.level) {
      _focusColor = Colors.grey;
      text = "Start";
    } else if (widget.status == -1 && widget.level < kycGuide.level) {
      _focusColor = Colors.amber;
      text = "Retry";
    } else if (widget.status == 1 || widget.level < kycGuide.level) {
      _focusColor = UiConstants.primaryColor;
      text = "Completed";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          child: widget.level == kycGuide.level
              ? _buildBody(
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          _focusColor,
                          _focusColor.withGreen(160),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _focusColor.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        _focusColor,
                        _focusColor.withGreen(160),
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
            onTap: () => kycGuide.stepButtonAction(widget.level, context),
            child: Container(
              height: 100,
              margin: EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _focusColor,
                ),
                borderRadius: BorderRadius.circular(10),
                color: _focusColor.withOpacity(0.05),
              ),
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text("PAN"),
                  leading: widget.level != 7 ? null : Icon(Icons.lock),
                  subtitle: Text("Your PAN is required for verification"),
                  trailing: Text(
                    text + "    ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _focusColor,
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

  Widget _buildBody(Widget core) {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(30 * _controller.value),
            _buildContainer(35 * _controller.value),
            _buildContainer(40 * _controller.value),
            _buildContainer(45 * _controller.value),
            _buildContainer(50 * _controller.value),
            Align(child: core),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _focusColor.withOpacity(1 - _controller.value),
      ),
    );
  }
}
