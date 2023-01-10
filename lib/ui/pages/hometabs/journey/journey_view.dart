import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/focus_ring.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/help_fab.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jTooltip.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/unscratched_gt_tooltips.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_appbar/journey_appbar_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/base_util.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

final avatarKey = GlobalKey();

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with TickerProviderStateMixin {
  JourneyPageViewModel? modelInstance;

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
          key: ValueKey(Constants.JOURNEY_SCREEN_TAG),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: model.isLoading && model.pages == null
              ? JourneyErrorScreen()
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
                              LevelBlurView(),
                              PrizeToolTips(model: model),
                              MilestoneTooltip(model: model),
                              Avatar(model: model),
                            ],
                          ),
                        ),
                      ),
                    ),
                    HelpFab(),
                    JourneyAppBar(),
                    JourneyBannersView(),
                    if (model.isRefreshing) JRefreshIndicator(model: model),
                    JPageLoader(model: model),
                    LevelUpAnimation(),
                    if (FlavorConfig.isDevelopment()) CacheClearWidget(),
                  ],
                ),
        );
      },
    );
  }
}

class JourneyErrorScreen extends StatelessWidget {
  const JourneyErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
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
          Lottie.asset(Assets.fullScreenLoaderLottie,
              height: SizeConfig.screenWidth! / 2),
          SizedBox(height: 20),
          Text(
            locale.jFailed,
            style: TextStyles.rajdhaniEB.title2,
          ),
          SizedBox(height: 20),
          AppNegativeBtn(
              btnText: locale.btnRetry,
              onPressed: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll,
                  page: SplashPageConfig,
                );
              })
        ],
      ),
    );
  }
}

class LevelUpAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.LevelCompletion],
        builder: (context, jModel, properties) {
          return jModel!.showLevelUpAnimation
              ? Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Lottie.asset(
                      Assets.levelUpLottie,
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.fitWidth,
                      controller: jModel.levelUpLottieController,
                      onLoaded: (composition) {
                        jModel.levelUpLottieController!
                          ..duration = composition.duration;
                      },
                    ),
                  ),
                )
              : SizedBox();
        });
  }
}

class AvatarPathPainter extends StatelessWidget {
  final JourneyPageViewModel model;

  const AvatarPathPainter({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: CustomPaint(
        size: Size(model.pageWidth!, model.pageHeight! * 2),
        painter: PathPainter(model.avatarPath, Colors.transparent),
      ),
    );
  }
}

class JRefreshIndicator extends StatelessWidget {
  final JourneyPageViewModel model;
  const JRefreshIndicator({Key? key, required this.model}) : super(key: key);

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

class JPageLoader extends StatelessWidget {
  final JourneyPageViewModel model;
  const JPageLoader({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return AnimatedPositioned(
      top: (model.isLoading && model.isLoaderRequired)
          ? SizeConfig.pageHorizontalMargins
          : -400,
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
      left: SizeConfig.pageHorizontalMargins,
      child: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
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
              locale.btnLoading,
              style: TextStyles.rajdhaniB.title3.colour(Colors.white),
            ),
            subtitle: Text(
              locale.jLoadinglevels,
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
    S locale = S.of(context);
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.Pages],
      builder: (context, jModel, properties) {
        return PropertyChangeConsumer<UserService, UserServiceProperties>(
          properties: [UserServiceProperties.myJourneyStats],
          builder: (context, m, properties) {
            final JourneyLevel? levelData = jModel!.getJourneyLevelBlurData();
            log("Current Level Data ${levelData.toString()}");
            return levelData != null &&
                    jModel.pages!.length >= levelData.pageEnd!
                ? Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: BlurFilter(
                          child: Container(
                            color: Colors.transparent,
                            height: jModel.pageHeight! *
                                    (1 - levelData.breakpoint!) +
                                jModel.pageHeight! *
                                    (jModel.pageCount - levelData.pageEnd!),
                            width: jModel.pageWidth,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: jModel.pageHeight! * (1 - levelData.breakpoint!) +
                            jModel.pageHeight! *
                                (jModel.pageCount - levelData.pageEnd!) -
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness40),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding16,
                                    horizontal: SizeConfig.padding24),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lock,
                                            size: SizeConfig.iconSize1,
                                            color: Colors.black),
                                        Text(
                                            " " +
                                                locale.jLevel +
                                                " ${levelData.level! + 1}",
                                            style: TextStyles.rajdhaniB.body1
                                                .colour(Colors.black)),
                                      ],
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyles.body4
                                              .colour(Colors.black),
                                          children: [
                                            TextSpan(text: "Unlock to win a "),
                                            // WidgetSpan(
                                            //   child: Padding(
                                            //     padding: EdgeInsets.only(
                                            //         bottom:
                                            //             SizeConfig.padding3),
                                            //     child: SvgPicture.asset(
                                            //       Assets
                                            //           .levelUpUnRedeemedScratchCardBG,
                                            //       height: SizeConfig.body5,
                                            //     ),
                                            //   ),
                                            // ),
                                            TextSpan(text: " scratch card ")
                                          ]),
                                    )
                                  ],
                                ),
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
  final JourneyPageViewModel? model;
  Avatar({Key? key, this.model}) : super(key: key);
  final BaseUtil? _baseUtil = locator<BaseUtil>();
  @override
  Widget build(BuildContext context) {
    print(model!.avatarPosition);
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
          top: model!.avatarPosition?.dy,
          left: model.avatarPosition?.dx,
          child: CustomPaint(
            size: Size(SizeConfig.padding20, SizeConfig.padding20),
            painter: AvatarPainter(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
              ),
              child: ProfileImageSE(
                radius: SizeConfig.avatarRadius * 0.7,
                reactive: false,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.9);
    path.lineTo(size.width * 0.5, size.height * 1.08);
    path.lineTo(size.width * 0.7, size.height * 0.9);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);

    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.47, size.height * 1.18),
          width: SizeConfig.padding12,
          height: SizeConfig.padding6,
        ),
        0,
        2 * 3.14,
        true,
        Paint()..color = UiConstants.kSecondaryBackgroundColor);
  }

  @override
  bool shouldRepaint(AvatarPainter oldDelegate) => true;
}

class PathPainter extends CustomPainter {
  Path? path;
  final Color color;
  PathPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawPath(path!, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BlurFilter extends StatelessWidget {
  final Widget? child;
  final double sigmaX;
  final double sigmaY;
  BlurFilter({this.child, this.sigmaX = 10.0, this.sigmaY = 10.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child!,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Opacity(
              opacity: 0.6,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class CacheClearWidget extends StatelessWidget {
  const CacheClearWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: SizeConfig.pageHorizontalMargins / 2,
      bottom: SizeConfig.navBarHeight + kBottomNavigationBarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              await CacheService.invalidateAll();
              BaseUtil.showPositiveAlert(
                  "Isar cleared successfully", "get back to work");
            },
            child: Chip(
              backgroundColor: Colors.purple,
              label: Text(
                "clear Isar cache",
                style: TextStyles.body3.colour(Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              PreferenceHelper.clear();
              BaseUtil.showPositiveAlert(
                  "Preferences cleared successfully", "get back to work");
            },
            child: Chip(
              backgroundColor: Colors.indigo,
              label: Text(
                "clear Shared Prefs",
                style: TextStyles.body3.colour(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
