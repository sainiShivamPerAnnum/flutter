import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutosaveOnboardingView extends StatefulWidget {
  const AutosaveOnboardingView({Key? key}) : super(key: key);

  @override
  State<AutosaveOnboardingView> createState() => _AutosaveOnboardingViewState();
}

class _AutosaveOnboardingViewState extends State<AutosaveOnboardingView> {
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  @override
  void initState() {
    PreferenceHelper.setBool(
        PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME, false);
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveDetailsScreenView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
            onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
          ),
        ),
        body: Center(
          child: Text(
            "Fancy Autosave Page",
            style: TextStyles.rajdhaniB.title4,
          ),
        ));
  }
}
