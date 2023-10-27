//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
//Flutter Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final CustomLogger? logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  BaseUtil? baseProvider;
  late AppState appState;
  DBModel? dbProvider;
  final TextEditingController _requestCallPhoneController =
      TextEditingController();
  bool isInit = false;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void init() {
    _requestCallPhoneController.text = _userService!.baseUser!.mobile!;
    // enableFlashChat();
    isInit = true;
  }
  //
  // void enableFlashChat() async {
  //   ///Freshchat utils
  //   final freshchatKeys = await dbProvider.getActiveFreshchatKey();
  //   if (freshchatKeys != null && freshchatKeys.isNotEmpty) {
  //     Freshchat.init(freshchatKeys['app_id'], freshchatKeys['app_key'],
  //         freshchatKeys['app_domain'],
  //         gallerySelectionEnabled: true, themeName: 'FreshchatCustomTheme');
  //     logger.i("Flash Chat enabled");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityService>(context, listen: true)
            .connectivityStatus;

    if (!isInit) {
      init();
    }
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              FelloAppBar(
                leading: const FelloAppBarBackButton(),
                title: locale.helpAndSupport,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      FelloBriefTile(
                        leadingAsset: Assets.hsCustomerService,
                        title: locale.contactUsTitle,
                        onTap: () {
                          Haptic.vibrate();

                          appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: FreshDeskHelpPageConfig);
                        },
                      ),
                      FelloBriefTile(
                        leadingAsset: Assets.hsFaqs,
                        title: locale.faqs,
                        onTap: () {
                          Haptic.vibrate();
                          appState.currentAction = PageAction(
                              state: PageState.addPage, page: FaqPageConfig);
                        },
                      ),
                      // FelloBriefTile(
                      //   leadingAsset: Assets.hsFdbk,
                      //   title: "Feedback",
                      //   onTap: () {
                      //     AppState.screenStack.add(ScreenItem.dialog);
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) => WillPopScope(
                      //         onWillPop: () {
                      //           AppState.backButtonDispatcher.didPopRoute();
                      //           return Future.value(true);
                      //         },
                      //         child: FeedbackDialog(
                      //           title: "Tell us what you think",
                      //           description: "We'd love to hear from you",
                      //           buttonText: "Submit",
                      //           dialogAction: (String fdbk) {
                      //             if (fdbk != null && fdbk.isNotEmpty) {
                      //               //feedback submission allowed even if user not signed in
                      //               dbProvider
                      //                   .submitFeedback(
                      //                       (_userService.firebaseUser ==
                      //                                   null ||
                      //                               _userService
                      //                                       .firebaseUser.uid ==
                      //                                   null)
                      //                           ? 'UNKNOWN'
                      //                           : baseProvider.firebaseUser.uid,
                      //                       fdbk)
                      //                   .then((flag) {
                      //                 AppState.backButtonDispatcher
                      //                     .didPopRoute();
                      //                 if (flag) {
                      //                   BaseUtil.showPositiveAlert(
                      //                     'Thank You',
                      //                     'We appreciate your feedback!',
                      //                   );
                      //                 }
                      //               });
                      //             }
                      //           },
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: SizeConfig.blockSizeVertical,
            left: 0,
            right: 0,
            child: const TermsRow(),
          )
        ],
      ),
    );
  }

  void _launchEmail() {
    _analyticsService!.track(eventName: AnalyticsEvents.emailInitiated);
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'support@fello.in');
    launch(emailLaunchUri.toString());
  }
}

class TermsRow extends StatelessWidget {
  const TermsRow();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              locale.termsOfService,
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize! * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              BaseUtil.launchUrl('https://fello.in/policy/tnc');

              // AppState.delegate.appState.currentAction =
              //     PageAction(state: PageState.addPage, page: TncPageConfig);
            },
          ),
        ),
        const Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              locale.privacyPolicy,
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize! * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              BaseUtil.launchUrl('https://fello.in/policy/privacy');
              // AppState.delegate.appState.currentAction = PageAction(
              //     state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        ),
        const Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              locale.refPolicy,
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize! * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              // BaseUtil.launchUrl('https://fello.in/policy/privacy');
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        )
      ],
    );
  }
}
