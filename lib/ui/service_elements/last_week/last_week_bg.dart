import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/last_week_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LastWeekBg extends StatelessWidget {
  const LastWeekBg({
    required this.child,
    Key? key,
    this.callCampaign = true,
    this.iconUrl,
    this.title,
    this.isTopSaver,
    this.showButton = true,
    this.showBackButtuon = false,
    this.model,
  }) : super(key: key);

  final Widget child;
  final bool callCampaign;
  final String? iconUrl;
  final String? title;
  final bool? isTopSaver;
  final bool showButton;
  final bool showBackButtuon;
  final LastWeekData? model;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins, vertical: 0),
            height: SizeConfig.screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff266F64),
                  // Color(0xff293566).withOpacity(1),
                  Color(0xff151D22),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.455],
              ),
            ),
            child: child,
          ),
          if (showBackButtuon)
            SizedBox(
              height: SizeConfig.fToolBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.backButtonDispatcher!.didPopRoute();
                      if (callCampaign) {
                        locator<MarketingEventHandlerService>().getCampaigns();
                      }
                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.lastWeekCrossButton,
                          properties: {
                            "Last week deposited": model?.user?.invested,
                            "last week returns": model?.user?.returns,
                            "last week return Percentage":
                                model?.user?.gainsPerc,
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.padding26,
                          left: SizeConfig.padding20),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (showButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: SizeConfig.screenWidth,
                color: const Color(0xff232326),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    if (isTopSaver ?? false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            iconUrl ?? "",
                            height: SizeConfig.padding32,
                          ),
                          SizedBox(
                            width: SizeConfig.padding12,
                          ),
                          Text(
                            title ?? "",
                            style: TextStyles.sourceSans.body4,
                          ),
                        ],
                      ),
                    if (isTopSaver == false && (title?.isNotEmpty ?? false))
                      Text(
                        title ?? "",
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.textGray60),
                      ),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.padding35,
                          right: SizeConfig.padding35,
                          top: SizeConfig.padding8,
                          bottom: SizeConfig.viewPadding!.bottom +
                              SizeConfig.padding8),
                      child: AppPositiveBtn(
                        onPressed: () async{
                          if (callCampaign) {
                            await locator<MarketingEventHandlerService>()
                                .getCampaigns();
                          }

                          locator<AnalyticsService>().track(
                              eventName: AnalyticsEvents.lastWeekSaveNow,
                              properties: {
                                "Last week deposited": model?.user?.invested,
                                "last week returns": model?.user?.returns,
                                "last week return Percentage":
                                    model?.user?.gainsPerc,
                              });
                          AppState.delegate!.parseRoute(Uri.parse('/assetBuy'));
                        },

                        btnText: locale.btnSaveNow.toUpperCase(),
                        // child: Center(
                        //   child: Text(
                        //     'SAVE NOW',
                        //     style:
                        //         TextStyles.rajdhaniB.body1.colour(Colors.white),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
              top: SizeConfig.padding64,
              left: SizeConfig.padding80 + SizeConfig.padding34,
              child: CustomPaint(
                size: Size(SizeConfig.padding34,
                    (SizeConfig.padding34 * 0.30303030303030304).toDouble()),
                painter: CloudCustomPainter(),
              )),
          Positioned(
            top: SizeConfig.padding54,
            right: SizeConfig.padding80 + SizeConfig.padding64,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding70,
            right: SizeConfig.padding80 + SizeConfig.padding40,
            child: Container(
              width: SizeConfig.padding3,
              height: SizeConfig.padding3,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding90 + SizeConfig.padding40,
            right: SizeConfig.padding20,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding90 + SizeConfig.padding20,
            left: SizeConfig.padding40,
            child: Container(
              width: SizeConfig.padding4,
              height: SizeConfig.padding4,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
          Positioned(
            top: SizeConfig.padding64,
            left: SizeConfig.padding54,
            child: Container(
              width: SizeConfig.padding6,
              height: SizeConfig.padding6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff61CFC6)),
            ),
          ),
        ],
      ),
    );
  }
}

class CloudCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height);
    path_0.lineTo(size.width * 0.1538462, size.height);
    path_0.cubicTo(
        size.width * 0.1986482,
        size.height * 0.6516680,
        size.width * 0.3548462,
        size.height * -0.03570790,
        size.width * 0.6212154,
        size.height * 0.001447510);
    path_0.cubicTo(
        size.width * 0.8875872,
        size.height * 0.03860300,
        size.width * 0.9847256,
        size.height * 0.6826310,
        size.width,
        size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(0.3);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0, size.height);
    path_1.lineTo(size.width * 0.2307692, size.height);
    path_1.cubicTo(
        size.width * 0.2223079,
        size.height * 0.8733720,
        size.width * 0.1873856,
        size.height * 0.6162200,
        size.width * 0.1153851,
        size.height * 0.6006350);
    path_1.cubicTo(size.width * 0.04338487, size.height * 0.5850500,
        size.width * 0.008461564, size.height * 0.8603840, 0, size.height);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Colors.white.withOpacity(0.3);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
