import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/focus_ring.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_appbar/journey_appbar_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with TickerProviderStateMixin {
  JourneyPageViewModel modelInstance;

  @override
  Widget build(BuildContext context) {
    log("ROOT: Journey view build called");
    return BaseView<JourneyPageViewModel>(
      onModelReady: (model) async {
        modelInstance = model;
        await model.init(this);
      },
      onModelDispose: (model) {
        model.dump();
      },
      builder: (ctx, model, child) {
        log("ROOT: Journey view baseview build called");

        return Scaffold(
          backgroundColor: Colors.black,
          // floatingActionButton: Container(
          //   margin: EdgeInsets.only(bottom: 60),
          //   child: (PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != null &&
          //           PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL) != 1)
          //       ? FloatingActionButton(
          //           child: const Icon(
          //             Icons.replay,
          //             color: Colors.white,
          //           ),
          //           backgroundColor: Colors.black,
          //           onPressed: () {
          //             PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, 1);
          //           },
          //         )
          //       : SizedBox(),
          // ),
          // floatingActionButton: Container(
          //   margin: EdgeInsets.only(bottom: 80, left: 50),
          //   child: FloatingActionButton(
          //       child: Icon(Icons.stop),
          //       onPressed: //model.controller.stop
          //           () {
          //         _animationController.reset();
          //         _animationController.forward().then((value) {
          //           showButton = true;
          //         });
          //       }),
          // ),
          body: model.isLoading && model.pages == null
              ? Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF097178).withOpacity(0.2),
                        Color(0xFF0C867C),
                        Color(0xff0B867C),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/loader.json",
                          height: SizeConfig.screenWidth / 2),
                      SizedBox(height: 20),
                      Text(
                        'Loading',
                        style: TextStyles.rajdhaniEB.title2,
                      )
                    ],
                  ),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: SingleChildScrollView(
                        controller: model.mainController,
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        child: Container(
                          height: model.currentFullViewHeight,
                          width: SizeConfig.screenWidth,
                          // color: Colors.black,
                          // decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Color(0xffB9D1FE),
                          //     Color(0xffD6E0FF),
                          //     Color(0xffF1EFFF)
                          //   ],
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          // ),
                          // ),
                          child: Stack(
                            children: [
                              Background(model: model),
                              ActiveMilestoneBackgroundGlow(),
                              JourneyAssetPath(model: model),
                              if (model.avatarPath != null)
                                AvatarPathPainter(model: model),
                              ActiveMilestoneBaseGlow(),
                              Milestones(model: model),
                              FocusRing(),
                              Avatar(model: model),
                              LevelBlurView()
                            ],
                          ),
                        ),
                      ),
                    ),

                    JourneyAppBar(),
                    // JourneyBannersView(),
                    if (model.isRefreshing) JRefreshIndicator(model: model),
                    // NewUserNavBar(model: model),

                    JPageLoader(model: model)
                  ],
                ),
        );
      },
    );
  }
}

class AvatarPathPainter extends StatelessWidget {
  final JourneyPageViewModel model;

  const AvatarPathPainter({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: CustomPaint(
        size: Size(model.pageWidth, model.pageHeight * 2),
        painter: PathPainter(model.avatarPath, Colors.transparent),
      ),
    );
  }
}

class JRefreshIndicator extends StatelessWidget {
  final JourneyPageViewModel model;
  const JRefreshIndicator({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: SizeConfig.navBarHeight,
      child: Container(
        width: SizeConfig.screenWidth,
        child: LinearProgressIndicator(
          minHeight: 4,
          backgroundColor: UiConstants.gameCardColor,
          color: UiConstants.tertiarySolid,
        ),
      ),
    );
  }
}

class NewUserNavBar extends StatelessWidget {
  final JourneyPageViewModel model;

  const NewUserNavBar({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
      builder: (context, m, properties) {
        return
            //  m.avatarRemoteMlIndex > 2
            //     ? SizedBox()
            //     :
            Positioned(
          bottom: 0,
          child: SafeArea(
            child: GestureDetector(
                onTap: () {
                  model.showMilestoneDetailsModalSheet(
                      model.currentMilestoneList.firstWhere((milestone) =>
                          milestone.index == m.avatarRemoteMlIndex),
                      context);
                },
                child: Container(
                  width: SizeConfig.screenWidth -
                      SizeConfig.pageHorizontalMargins * 2,
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    color: UiConstants.gameCardColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding4,
                        vertical: SizeConfig.pageHorizontalMargins),
                    leading: GestureDetector(
                      onDoubleTap: () {
                        AppState.delegate.appState.currentAction = PageAction(
                          page: UserProfileDetailsConfig,
                          state: PageState.addWidget,
                          widget: UserProfileDetails(isNewUser: true),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: SizeConfig.avatarRadius * 2,
                        child: SvgPicture.asset(Assets.aFelloToken,
                            height: SizeConfig.padding32),
                      ),
                    ),
                    title: FittedBox(
                      child: Text(
                        "Welcome to Fello",
                        style: TextStyles.rajdhaniB.title3.colour(Colors.white),
                      ),
                    ),
                    subtitle: Text(
                      "Lets get started with the journey",
                      style: TextStyles.sourceSans.body3.colour(Colors.white60),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.navigate_next_rounded,
                          color: Colors.white),
                      onPressed: () {
                        model.showMilestoneDetailsModalSheet(
                            model.currentMilestoneList.firstWhere((milestone) =>
                                milestone.index == m.avatarRemoteMlIndex),
                            context);
                      },
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}

class JPageLoader extends StatelessWidget {
  final JourneyPageViewModel model;
  const JPageLoader({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: (model.isLoading && model.pages != null && model.pages.length > 0)
          ? SizeConfig.pageHorizontalMargins
          : -400,
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
      left: SizeConfig.pageHorizontalMargins,
      child: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
          height: SizeConfig.padding80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            color: Colors.black54,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              radius: SizeConfig.avatarRadius * 2,
              child: SpinKitCircle(
                color: UiConstants.primaryColor,
                size: SizeConfig.avatarRadius * 1.5,
              ),
            ),
            title: Text(
              "Loading",
              style: TextStyles.rajdhaniB.title3.colour(Colors.white),
            ),
            subtitle: Text(
              "Loading more levels for you,please wait",
              style: TextStyles.sourceSans.body3.colour(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelBlurView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.Pages],
      builder: (context, jModel, properties) {
        return PropertyChangeConsumer<UserService, UserServiceProperties>(
          properties: [UserServiceProperties.myJourneyStats],
          builder: (context, m, properties) {
            final JourneyLevel levelData = jModel.getJourneyLevelBlurData();
            log("Current Level Data ${levelData.toString()}");
            return levelData != null && jModel.pages.length >= levelData.pageEnd
                ? Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: BlurFilter(
                          child: Container(
                            color: Colors.transparent,
                            height:
                                jModel.pageHeight * (1 - levelData.breakpoint),
                            width: jModel.pageWidth,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: jModel.pageHeight * (1 - levelData.breakpoint) -
                            SizeConfig.avatarRadius,
                        child: Container(
                          width: jModel.pageWidth,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomPaint(
                                  painter: DottedLinePainter(),
                                ),
                              ),
                              CircleAvatar(
                                radius: SizeConfig.avatarRadius,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.lock,
                                    size: SizeConfig.iconSize0,
                                    color: Colors.black),
                              ),
                              Expanded(
                                child: CustomPaint(
                                  painter: DottedLinePainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox();
          },
        );
      },
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Avatar extends StatelessWidget {
  final JourneyPageViewModel model;
  Avatar({Key key, this.model}) : super(key: key);
  final _baseUtil = locator<BaseUtil>();
  @override
  Widget build(BuildContext context) {
    print(model.avatarPosition);
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [
        JourneyServiceProperties.AvatarPosition,
        JourneyServiceProperties.Pages
      ],
      builder: (context, model, properties) {
        return Positioned(
          key: avatarKey,
          // duration: Duration(seconds: 10),
          // curve: Curves.decelerate,
          top: model.avatarPosition?.dy,
          left: model.avatarPosition?.dx,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
            ),
            child: ProfileImageSE(
              radius: SizeConfig.avatarRadius * 0.8,
              reactive: false,
            ),
          ),
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  final Color color;
  PathPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  BlurFilter({this.child, this.sigmaX = 10.0, this.sigmaY = 10.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Opacity(
              opacity: 0.01,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
