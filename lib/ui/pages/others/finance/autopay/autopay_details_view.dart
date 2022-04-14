import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoSaveDetailsView extends StatefulWidget {
  const AutoSaveDetailsView({Key key}) : super(key: key);

  @override
  State<AutoSaveDetailsView> createState() => _AutoSaveDetailsViewState();
}

class _AutoSaveDetailsViewState extends State<AutoSaveDetailsView>
    with SingleTickerProviderStateMixin {
  final _paytmService = locator<PaytmService>();
  PageController autosavePageController;
  double usedHeight = (SizeConfig.screenHeight -
      SizeConfig.viewInsets.top +
      SizeConfig.padding24 +
      SizeConfig.avatarRadius * 2);
  int _currentPage = 0;
  Timer _timer;
  ValueNotifier<double> _pageNotifier;
  double bgOpacity = 0;
  double fgOpacity = 1;
  // double initialPos = SizeConfig.screenHeight - SizeConfig.viewInsets.top;
  // double maxPos = 1;
  double animValue = 0;
  bool showSetupButton = false;

  AnimationController controller;
  Animation benifitAnimation;
  // updateUI(double position) {
  //   double completePath = position - initialPos;
  //   double totalLength = maxPos - initialPos;
  //   double pcntComplete = (completePath / totalLength);
  //   setState(() {
  //     bgOpacity = pcntComplete;
  //     fgOpacity = 1 - bgOpacity;
  //     print(bgOpacity);
  //   });
  // }

  List<String> bTitle = [
    "Savings on autopilot",
    "Power of Compounding",
    "Gaming never stops"
  ];

  List<String> bSubtitle = [
    "Your money gets saved automatically",
    "Your money is compounding everyday",
    "Never run out of Fello tokens while playing"
  ];

  List<String> svgassets = [Assets.fasben1, Assets.fasben2, Assets.fasben3];

  List<String> pngassets = [Assets.fasben1, Assets.fasben2, Assets.fasben3];

  @override
  void initState() {
    if (_paytmService.activeSubscription == null ||
        _paytmService.activeSubscription.status ==
            Constants.SUBSCRIPTION_INIT ||
        _paytmService.activeSubscription.status ==
            Constants.SUBSCRIPTION_CANCELLED) {
      showSetupButton = true;
    }
    autosavePageController = new PageController(initialPage: 0);
    autosavePageController.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      setState(() {
        animValue = animValue == 0 ? 1 : 0;
      });
      print("Anim value: $animValue");
      autosavePageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    benifitAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward().whenComplete(() {
      controller.reverse();
    });
    super.initState();
  }

  void _pageListener() {
    _pageNotifier.value = autosavePageController.page;
  }

  @override
  void dispose() {
    autosavePageController.removeListener(_pageListener);
    autosavePageController.dispose();
    controller.dispose();

    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffe7f5e8),
        child: Stack(
          children: [
            // AnimatedOpacity(
            //   opacity: bgOpacity,
            //   duration: Duration(seconds: 0),
            //   child: Container(
            //     height: SizeConfig.screenHeight,
            //     width: SizeConfig.screenWidth,
            //     color: UiConstants.primaryColor,
            //   ),
            // ),
            Positioned(
              top: 0,
              child: Image.asset(
                Assets.splashBackground,
                width: SizeConfig.screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: SizeConfig.screenHeight * 0.72,
                  decoration: BoxDecoration(
                    color: UiConstants.primaryColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: usedHeight * 0.56,
              left: SizeConfig.pageHorizontalMargins,
              child: AnimatedOpacity(
                curve: Curves.easeOutCirc,
                duration: Duration(milliseconds: 300),
                opacity: animValue,
                child: AnimatedContainer(
                  margin: EdgeInsets.only(top: SizeConfig.padding24),
                  alignment: Alignment.topCenter,
                  curve: Curves.decelerate,
                  duration: Duration(milliseconds: 600),
                  height: (SizeConfig.screenHeight -
                          SizeConfig.viewInsets.top +
                          SizeConfig.padding24 +
                          SizeConfig.avatarRadius * 2) *
                      0.3 *
                      animValue,
                  width: SizeConfig.screenWidth -
                      SizeConfig.pageHorizontalMargins * 2,
                  child: Image.asset(pngassets[_currentPage]),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       image: NetworkImage(assets[_currentPage]),
                  //       fit: BoxFit.contain),
                  // ),
                ),
              ),
            ),
            Positioned(
              bottom: usedHeight * 0.56,
              left: SizeConfig.pageHorizontalMargins,
              child: AnimatedOpacity(
                curve: Curves.easeOutCirc,
                duration: Duration(milliseconds: 300),
                opacity: (animValue - 1).abs(),
                child: AnimatedContainer(
                  margin: EdgeInsets.only(top: SizeConfig.padding24),
                  alignment: Alignment.topCenter,
                  curve: Curves.decelerate,
                  duration: Duration(milliseconds: 600),
                  height: (SizeConfig.screenHeight -
                          SizeConfig.viewInsets.top +
                          SizeConfig.padding24 +
                          SizeConfig.avatarRadius * 2) *
                      0.3 *
                      ((animValue - 1).abs()),
                  width: SizeConfig.screenWidth -
                      SizeConfig.pageHorizontalMargins * 2,
                  child: Image.asset(pngassets[_currentPage]),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       image: NetworkImage(assets[_currentPage]),
                  //       fit: BoxFit.contain),
                  // ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: usedHeight * 0.48,
            //   left: SizeConfig.pageHorizontalMargins,
            //   child: AnimatedOpacity(
            //     curve: Curves.easeInCubic,
            //     duration: Duration(milliseconds: 600),
            //     opacity: (animValue - 1).abs(),
            //     child: AnimatedContainer(
            //       margin: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
            //       alignment: Alignment.topCenter,
            //       curve: Curves.decelerate,
            //       duration: Duration(milliseconds: 600),
            //       height: (SizeConfig.screenHeight -
            //               SizeConfig.viewInsets.top +
            //               SizeConfig.padding24 +
            //               SizeConfig.avatarRadius * 2) *
            //           0.3 *
            //           (animValue - 1).abs(),
            //       width: SizeConfig.screenWidth -
            //           SizeConfig.pageHorizontalMargins * 2,
            //       child: FittedBox(
            //           fit: BoxFit.scaleDown,
            //           child: Image.asset(pngassets[_currentPage])),
            //     ),
            //   ),
            // ),
            Positioned(
              top: SizeConfig.viewInsets.top + SizeConfig.padding16,
              child: Container(
                width: SizeConfig.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.logoMaxSize,
                      height: SizeConfig.title1,
                    ),
                    // SizedBox(
                    //   height: SizeConfig.padding8,
                    // ),
                    Transform.translate(
                      offset: Offset(0, -SizeConfig.padding12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   Assets.logoMaxSize,
                          //   height: SizeConfig.title1 * 1.2,
                          // ),
                          // SizedBox(width: SizeConfig.padding4),
                          Text("AUTOSAVE",
                              style: GoogleFonts.suranna(
                                  fontWeight: FontWeight.w300,
                                  // height: 1.6,
                                  color: Color(0xff3F4748),
                                  letterSpacing: 2,
                                  fontSize: SizeConfig.title4)

                              //  TextStyles.title1.colour(Color(0xff3F4748)),
                              ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            FelloAppBar(leading: FelloAppBarBackButton()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: usedHeight * 0.56,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness32),
                      topRight: Radius.circular(SizeConfig.roundness32),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding16,
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Column(
                    children: [
                      // Transform.translate(
                      //   offset: Offset(0, 5),
                      //   child: Container(
                      //     child: Column(
                      //       children: [
                      //         SizedBox(height: 10),
                      //         ScrollHandle(),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: SizeConfig.screenWidth -
                                  SizeConfig.pageHorizontalMargins * 2,
                              height: SizeConfig.padding64,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              child: PageView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (int page) {
                                  _pageNotifier.value = page.toDouble();
                                },
                                controller: autosavePageController,
                                scrollDirection: Axis.vertical,
                                itemCount: 3,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: SizeConfig.padding64,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bTitle[i],
                                          style: TextStyles.body2.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: SizeConfig.padding2),
                                        Text(
                                          bSubtitle[i],
                                          style: TextStyles.body2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: _pageNotifier,
                                builder: (context, double value, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TabPageSelectorIndicator(
                                        backgroundColor: value == 0.0
                                            ? UiConstants.primaryColor
                                            : Colors.grey[400],
                                        borderColor: Colors.white,
                                        size: SizeConfig.padding8,
                                      ),
                                      TabPageSelectorIndicator(
                                        backgroundColor: value == 1.0
                                            ? UiConstants.primaryColor
                                            : Colors.grey[400],
                                        borderColor: Colors.white,
                                        size: SizeConfig.padding8,
                                      ),
                                      TabPageSelectorIndicator(
                                        backgroundColor: value == 2.0
                                            ? UiConstants.primaryColor
                                            : Colors.grey[400],
                                        borderColor: Colors.white,
                                        size: SizeConfig.padding8,
                                      ),
                                    ],
                                  );
                                }),
                            Divider(),
                            // Text(
                            //   "Setup UPI AutoSave and we'll automagically save for you. You just grab a beer and chill!!",
                            //   style: TextStyles.body3.light.italic,
                            //   textAlign: TextAlign.center,
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         width: SizeConfig.screenWidth * 0.422,
                            //         height: SizeConfig.screenWidth * 0.144,
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(
                            //               SizeConfig.roundness12),
                            //           color: UiConstants.scaffoldColor,
                            //         ),
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           "How to set it up",
                            //           style: TextStyles.body2
                            //               .colour(Colors.grey),
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(width: SizeConfig.padding12),
                            //     Expanded(
                            //       child: Container(
                            //         width: SizeConfig.screenWidth * 0.422,
                            //         height: SizeConfig.screenWidth * 0.144,
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(
                            //               SizeConfig.roundness12),
                            //           color: UiConstants.primaryColor,
                            //         ),
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           "Benefits you get",
                            //           style: TextStyles.body2
                            //               .colour(Colors.white),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // SizedBox(height: SizeConfig.padding32),
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  SizedBox(height: SizeConfig.padding12),
                                  Text(
                                    "Set up UPI Autosave in 3 easy Steps:",
                                    style: TextStyles.body1.bold,
                                  ),
                                  InfoTile(
                                    png: "assets/images/icons/bank.png",
                                    title: "Enter your UPI Id",
                                    subtitle:
                                        "Make sure your bank supports autosave",
                                  ),
                                  InfoTile(
                                    svg: "assets/vectors/check.svg",
                                    title:
                                        "Open the UPI app and approve the request",
                                    subtitle:
                                        "Check you PENDING upi transactions for this request",
                                  ),
                                  InfoTile(
                                    svg: Assets.wmtsaveMoney,
                                    title: "Set a daily saving amount",
                                    subtitle: "You can change it anytime",
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.8,
                                            color: UiConstants.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.pageHorizontalMargins,
                                        vertical: SizeConfig.padding4,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          AppState.delegate.parseRoute(
                                              Uri.parse('/AppWalkthrough'));
                                        },
                                        child: Text(
                                          "See example",
                                          style: TextStyles.body1
                                              .colour(UiConstants.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.symmetric(
                                  //       vertical:
                                  //           SizeConfig.pageHorizontalMargins /
                                  //               2),
                                  //   decoration: BoxDecoration(
                                  //     color: UiConstants.scaffoldColor,
                                  //     borderRadius: BorderRadius.circular(
                                  //         SizeConfig.roundness32),
                                  //   ),
                                  //   padding: EdgeInsets.symmetric(
                                  //       vertical: SizeConfig.padding20,
                                  //       horizontal: SizeConfig.padding16),
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       SizedBox(height: SizeConfig.padding6),
                                  //       Text(" Why UPI AutoSave",
                                  //           style: TextStyles.title4.bold),
                                  //       SizedBox(height: SizeConfig.padding20),
                                  //       FeatureTile(
                                  //         leadingAsset:
                                  //             "assets/vectors/ontime.svg",
                                  //         title: "Always on time",
                                  //         subtitle:
                                  //             "No worries about making timely investments",
                                  //         color: Colors.white,
                                  //       ),
                                  //       SizedBox(height: SizeConfig.padding12),
                                  //       FeatureTile(
                                  //         leadingAsset:
                                  //             "assets/vectors/moneys.svg",
                                  //         title: "Get tokens on the go",
                                  //         subtitle:
                                  //             "Get free tokens everyday with the investment",
                                  //         color: Colors.white,
                                  //       ),
                                  //       SizedBox(height: SizeConfig.padding12),
                                  //       FeatureTile(
                                  //         leadingAsset:
                                  //             "assets/vectors/easy.svg",
                                  //         title: "Easy Set up",
                                  //         subtitle:
                                  //             "Takes less than 1 minute with no paperwork",
                                  //         color: Colors.white,
                                  //       ),
                                  //       SizedBox(height: SizeConfig.padding12),
                                  //       FeatureTile(
                                  //         leadingAsset:
                                  //             "assets/vectors/gear.svg",
                                  //         title: "Customised Options",
                                  //         subtitle:
                                  //             "You can Update or Cancel UPI Autosave anytime ",
                                  //         color: Colors.white,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: SizeConfig.navBarHeight * 1.6,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: SizeConfig.navBarHeight * 1,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.0),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
            ),
            if (showSetupButton)
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.viewInsets.bottom != 0
                            ? 0
                            : SizeConfig.pageHorizontalMargins,
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: FelloButtonLg(
                      child: Text(
                        "Setup Autosave",
                        style: TextStyles.body2.bold.colour(Colors.white),
                      ),
                      onPressed: () {
                        AppState.delegate.appState.currentAction = PageAction(
                            page: AutoSaveProcessViewPageConfig,
                            state: PageState.replace);
                      },
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

// class ScrollHandle extends StatelessWidget {
//   const ScrollHandle({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         height: 5,
//         width: 40,
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     );
//   }
// }

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This variable define for better understanding you can direct specify value in quadraticBezierTo method
    var controlPoint = Offset(size.width / 2, 0);
    var endPoint = Offset(size.width, size.height * 0.1);

    Path path = Path()
      ..moveTo(0, size.height * 0.1)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class InfoTile extends StatelessWidget {
  final String svg, png, title, subtitle;
  final Function onPressed;
  InfoTile({this.onPressed, this.png, this.subtitle, this.svg, this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.4,
                  color: UiConstants.primaryColor,
                ),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(SizeConfig.padding2),
              child: Container(
                // width: SizeConfig.avatarRadius * 2,
                // height: SizeConfig.avatarRadius * 2,
                margin: EdgeInsets.all(SizeConfig.padding4),
                padding: EdgeInsets.all(SizeConfig.padding8),
                decoration: BoxDecoration(
                    color: UiConstants.scaffoldColor, shape: BoxShape.circle),
                child: svg != null
                    ? SvgPicture.asset(
                        svg,
                        width: SizeConfig.avatarRadius,
                      )
                    : Image.asset(
                        png ?? Assets.moneyIcon,
                        width: SizeConfig.avatarRadius,
                      ),
              ),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "title",
                    style: TextStyles.body2,
                  ),
                  SizedBox(height: SizeConfig.padding2),
                  Text(
                    subtitle ?? "subtitle",
                    style: TextStyles.body3.light.colour(Colors.black45),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
