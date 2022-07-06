import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveDetailsView extends StatefulWidget {
  const AutosaveDetailsView({Key key}) : super(key: key);

  @override
  State<AutosaveDetailsView> createState() => _AutosaveDetailsViewState();
}

class _AutosaveDetailsViewState extends State<AutosaveDetailsView> {
  final _analyticsService = locator<AnalyticsService>();
  @override
  void initState() {
    _analyticsService.track(
        eventName: AnalyticsEvents.autosaveDetailsScreenView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: UiConstants.kTextColor,
          ),
          onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.screenWidth * 0.2747,
          ),
          Center(
            child: Text(
              "How it works?",
              style: TextStyles.rajdhaniSB.title4,
            ),
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.12,
          ),
          _buildAutosaveStepTile(
            image: Image.asset(
              'assets/temp/upi_payment_logo.png',
              height: SizeConfig.screenWidth * 0.0667,
              width: SizeConfig.screenWidth * 0.0667,
            ),
            title: "Enter UPI ID",
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make sure your bank supports autopay.",
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Haptic.vibrate();
                    BaseUtil.launchUrl(
                      'https://www.npci.org.in/what-we-do/autopay/list-of-banks-and-apps-live-on-autopay',
                    );
                  },
                  child: Text(
                    "Check here",
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTabBorderColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildAutosaveStepTile(
            image: SvgPicture.asset(
              'assets/temp/verified.svg',
              height: SizeConfig.screenWidth * 0.112,
              width: SizeConfig.screenWidth * 0.112,
            ),
            title: "Approve Request on UPI app",
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Check your ",
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor2,
                    ),
                  ),
                  TextSpan(
                    text: "Pending UPI transactions",
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.kTextColor2,
                    ),
                  ),
                  TextSpan(
                    text: " for the request.",
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAutosaveStepTile(
            image: SvgPicture.asset(
              'assets/temp/indian_rupee.svg',
              height: SizeConfig.screenWidth * 0.064,
              width: SizeConfig.screenWidth * 0.064,
            ),
            title: "Set an amount you want to invest",
            subtitle: Text(
              "You can change the amount anytime. ",
              style: TextStyles.sourceSans.body4.colour(
                UiConstants.kTextColor2,
              ),
            ),
          ),
          Spacer(),
          AppPositiveBtn(
            btnText: 'Get Started',
            onPressed: () {
              Haptic.vibrate();
              _analyticsService.track(
                eventName: AnalyticsEvents.autosaveSetupViewed,
              );
              AppState.delegate.appState.currentAction = PageAction(
                page: AutosaveProcessViewPageConfig,
                state: PageState.replace,
              );
            },
            width: SizeConfig.screenWidth * 0.784,
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.1893,
          ),
        ],
      ),
    );
  }

  Widget _buildAutosaveStepTile({
    Widget image,
    String title,
    Widget subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.08,
        vertical: SizeConfig.screenWidth * 0.0533,
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: SizeConfig.screenWidth * 0.1307,
              height: SizeConfig.screenWidth * 0.1307,
              color: Colors.black38,
              child: Center(child: image),
            ),
          ),
          SizedBox(
            width: SizeConfig.padding24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.sourceSans.body2,
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: subtitle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
