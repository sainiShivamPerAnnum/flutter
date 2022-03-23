import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modals_sheets/custom_subscription_modal.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_balance_details/gold_balance_details_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoPayDetailsView extends StatefulWidget {
  const AutoPayDetailsView({Key key}) : super(key: key);

  @override
  State<AutoPayDetailsView> createState() => _AutoPayDetailsViewState();
}

class _AutoPayDetailsViewState extends State<AutoPayDetailsView> {
  final PageController autopayPageController =
      new PageController(viewportFraction: 0.9, initialPage: 0);
  int _currentPage = 0;
  Timer _timer;

  double bgOpacity = 0;
  double fgOpacity = 1;
  double initialPos = 0.7;
  double maxPos = 1;
  updateUI(double position) {
    double completePath = position - initialPos;
    double totalLength = maxPos - initialPos;
    double pcntComplete = (completePath / totalLength);
    setState(() {
      bgOpacity = pcntComplete;
      fgOpacity = 1 - bgOpacity;
      print(bgOpacity);
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      autopayPageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
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
            AnimatedOpacity(
              opacity: bgOpacity,
              duration: Duration(seconds: 0),
              child: Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: UiConstants.primaryColor,
              ),
            ),
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
              top: SizeConfig.viewInsets.top +
                  SizeConfig.avatarRadius * 2 +
                  SizeConfig.padding64,
              child: SvgPicture.asset(
                "assets/vectors/moneyplant.svg",
                width: SizeConfig.screenWidth,
              ),
            ),
            Positioned(
              top: SizeConfig.viewInsets.top +
                  SizeConfig.padding12 +
                  SizeConfig.avatarRadius,
              child: AnimatedOpacity(
                opacity: fgOpacity,
                duration: Duration(milliseconds: 0),
                curve: Curves.easeIn,
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "INTRODUCING",
                        style: TextStyles.body3.colour(Colors.black45),
                      ),
                      SizedBox(
                        height: SizeConfig.padding8,
                      ),
                      Text(
                        "UPI AUTOPAY",
                        style: TextStyles.title1.bold,
                      )
                    ],
                  ),
                ),
              ),
            ),
            FelloAppBar(leading: FelloAppBarBackButton()),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                //  print("${notification.extent}");
                updateUI(notification.extent);
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: initialPos,
                minChildSize: initialPos,
                maxChildSize: maxPos,
                builder: (BuildContext context,
                    ScrollController myScrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness32),
                        topRight: Radius.circular(SizeConfig.roundness32),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        top: SizeConfig.viewInsets.top +
                            SizeConfig.padding24 +
                            SizeConfig.avatarRadius * 2),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0, 5),
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                ScrollHandle(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (notification) {
                              notification.disallowGlow();
                              return;
                            },
                            child: ListView(
                              controller: myScrollController,
                              physics: ClampingScrollPhysics(),
                              children: [
                                Text(
                                  "Setup UPI AutoPay and we'll automagically save for you. You just grab a beer and chill!!",
                                  style: TextStyles.body3.light.italic,
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: SizeConfig.screenWidth * 0.6,
                                  margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding24),
                                  child: PageView.builder(
                                    controller: autopayPageController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 4,
                                    itemBuilder: (ctx, i) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: SizeConfig.screenWidth / 2,
                                            width: SizeConfig.screenWidth / 2,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: UiConstants.primaryLight,
                                            ),
                                          ),
                                          Spacer(),
                                          Text("$i asset. lorem ipsum")
                                        ],
                                      );
                                    },
                                  ),
                                ),
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
                                //SizedBox(height: SizeConfig.padding32),
                                // Text(
                                //   "Set up UPI Autopay in 3 easy Steps:",
                                //   style: TextStyles.title4.bold,
                                // ),
                                // SizedBox(height: SizeConfig.padding12),
                                // InfoTile(
                                //   png: "assets/images/icons/bank.png",
                                //   title: "Enter your UPI Id",
                                //   subtitle:
                                //       "Make sure your bank supports autopay",
                                // ),
                                // InfoTile(
                                //   svg: "assets/vectors/check.svg",
                                //   title:
                                //       "Open the UPI app and approve the request",
                                //   subtitle:
                                //       "Check you PENDING upi transactions for this request",
                                // ),
                                // InfoTile(
                                //   svg: Assets.wmtsaveMoney,
                                //   title: "Set a daily saving amount",
                                //   subtitle: "You can change it anytime",
                                // ),

                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.8,
                                          color: UiConstants.primaryColor),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                      vertical: SizeConfig.padding4,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        AppState.delegate.appState
                                                .currentAction =
                                            PageAction(
                                                state: PageState.addPage,
                                                page: WalkThroughConfig);
                                      },
                                      child: Text(
                                        "How to setup UPI Autopay",
                                        style: TextStyles.body1
                                            .colour(UiConstants.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          SizeConfig.pageHorizontalMargins / 2),
                                  decoration: BoxDecoration(
                                    color: UiConstants.scaffoldColor,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness32),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding20,
                                      horizontal: SizeConfig.padding16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(" Why UPI AutoPay",
                                          style: TextStyles.title4.bold),
                                      SizedBox(height: SizeConfig.padding20),
                                      FeatureTile(
                                        leadingAsset:
                                            "assets/vectors/ontime.svg",
                                        title: "Always on time",
                                        subtitle:
                                            "No worries about making timely investments",
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      FeatureTile(
                                        leadingAsset:
                                            "assets/vectors/moneys.svg",
                                        title: "Get tokens on the go",
                                        subtitle:
                                            "Get free tokens everyday with the investment",
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      FeatureTile(
                                        leadingAsset: "assets/vectors/easy.svg",
                                        title: "Easy Set up",
                                        subtitle:
                                            "Takes less than 1 minute with no paperwork",
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      FeatureTile(
                                        leadingAsset: "assets/vectors/gear.svg",
                                        title: "Customised Options",
                                        subtitle:
                                            "You can Update or Cancel UPI Autopay anytime ",
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.navBarHeight * 1.6,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                      "Setup AutoPay",
                      style: TextStyles.body2.bold.colour(Colors.white),
                    ),
                    onPressed: () {
                      // BaseUtil.openModalBottomSheet(
                      //   addToScreenStack: true,
                      //   backgroundColor: Colors.white,
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(SizeConfig.roundness32),
                      //     topRight: Radius.circular(SizeConfig.roundness32),
                      //   ),
                      //   content: CustomSubscriptionModal(),
                      //   hapticVibrate: true,
                      //   isBarrierDismissable: false,
                      //   isScrollControlled: true,
                      // );
                      AppState.delegate.appState.currentAction = PageAction(
                          page: AutoPayProcessViewPageConfig,
                          state: PageState.addPage);
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

class ScrollHandle extends StatelessWidget {
  const ScrollHandle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 5,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

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
