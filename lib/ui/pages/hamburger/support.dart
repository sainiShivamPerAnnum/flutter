//Project Imports
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/util/locator.dart';

//Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pub Imports
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final Logger logger = locator<Logger>();
  final UserService _userService = locator<UserService>();
  BaseUtil baseProvider;
  AppState appState;
  DBModel dbProvider;
  TextEditingController _requestCallPhoneController = TextEditingController();
  bool isInit = false;
  final _mixpanelService = locator<MixpanelService>();

  void init() {
    _requestCallPhoneController.text = baseProvider.myUser.mobile;
    enableFlashChat();
    isInit = true;
  }

  void enableFlashChat() async {
    ///Freshchat utils
    final freshchatKeys = await dbProvider.getActiveFreshchatKey();
    if (freshchatKeys != null && freshchatKeys.isNotEmpty) {
      Freshchat.init(freshchatKeys['app_id'], freshchatKeys['app_key'],
          freshchatKeys['app_domain'],
          gallerySelectionEnabled: true, themeName: 'FreshchatCustomTheme');
      logger.i("Flash Chat enabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);

    if (!isInit) {
      init();
    }
    return Scaffold(
      body: HomeBackground(
        child: Stack(
          children: [
            Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Help & Support",
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
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
                          title: "Chat with us",
                          onTap: () {
                            Haptic.vibrate();
                            _mixpanelService
                                .track(MixpanelEvents.initiateChatSupport,{'userId':_userService.baseUser.uid});
                            appState.currentAction = PageAction(
                                state: PageState.addPage,
                                page: ChatSupportPageConfig);
                          },
                        ),
                        FelloBriefTile(
                          leadingIcon: Icons.call,
                          title: "Request a Callback",
                          onTap: () {
                            Haptic.vibrate();
                            if (connectivityStatus !=
                                ConnectivityStatus.Offline)
                              _showRequestCallSheet();
                            else
                              BaseUtil.showNoInternetAlert();
                          },
                        ),
                        FelloBriefTile(
                          leadingAsset: Assets.hsMail,
                          title: "Email us your query",
                          onTap: () {
                            Haptic.vibrate();
                            try {
                              _launchEmail();
                            } catch (e) {
                              BaseUtil.showNegativeAlert(
                                'Error',
                                'Something went wrong, could not launch email right now. Please try again later',
                              );
                            }
                          },
                        ),
                        FelloBriefTile(
                          leadingAsset: Assets.hsFaqs,
                          title: "FAQs",
                          onTap: () {
                            Haptic.vibrate();
                            appState.currentAction = PageAction(
                                state: PageState.addPage, page: FaqPageConfig);
                          },
                        ),
                        FelloBriefTile(
                          leadingAsset: Assets.hsFdbk,
                          title: "Feedback",
                          onTap: () {
                            AppState.screenStack.add(ScreenItem.dialog);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => WillPopScope(
                                onWillPop: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                  return Future.value(true);
                                },
                                child: FeedbackDialog(
                                  title: "Tell us what you think",
                                  description: "We'd love to hear from you",
                                  buttonText: "Submit",
                                  dialogAction: (String fdbk) {
                                    if (fdbk != null && fdbk.isNotEmpty) {
                                      //feedback submission allowed even if user not signed in
                                      dbProvider
                                          .submitFeedback(
                                              (baseProvider.firebaseUser ==
                                                          null ||
                                                      baseProvider.firebaseUser
                                                              .uid ==
                                                          null)
                                                  ? 'UNKNOWN'
                                                  : baseProvider
                                                      .firebaseUser.uid,
                                              fdbk)
                                          .then((flag) {
                                        AppState.backButtonDispatcher
                                            .didPopRoute();
                                        if (flag) {
                                          BaseUtil.showPositiveAlert(
                                            'Thank You',
                                            'We appreciate your feedback!',
                                          );
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
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
      ),
    );
  }

  void _showRequestCallSheet() {
    List<String> timeSlots = ['12-2 PM', '2-4 PM', '4-6 PM', '6-8 PM'];
    // times in 0-24 hour format
    List<int> callTimes = [12, 14, 16, 18];
    int _selectedTimeSlotIndex = 0;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.cardBorderRadius),
                topRight: Radius.circular(SizeConfig.cardBorderRadius))),
        backgroundColor: UiConstants.bottomNavBarColor,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.globalMargin),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Request a callback',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: UiConstants.primaryColor,
                                    fontSize: SizeConfig.largeTextSize * 1.2,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3.5,
                    ),
                    Text(
                      'Confirm your number and we will call you back.',
                      style:
                          TextStyle(fontSize: SizeConfig.mediumTextSize * 1.3),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3.5,
                    ),
                    TextFormField(
                      controller: _requestCallPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        focusColor: UiConstants.primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        return (value != null && value.isNotEmpty)
                            ? null
                            : 'Please enter a valid phone number';
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3.5,
                    ),
                    Text(
                      'What time should we call you?',
                      style:
                          TextStyle(fontSize: SizeConfig.mediumTextSize * 1.3),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    // 12-8, 12-2, 2-4,4-6,6-8
                    Container(
                      height: SizeConfig.blockSizeVertical * 6.5,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: List.generate(timeSlots.length, (index) {
                          if (index == 0) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setBottomSheetState(() {
                                    _selectedTimeSlotIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: UiConstants.primaryColor),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                    color: (_selectedTimeSlotIndex == index)
                                        ? UiConstants.primaryColor
                                        : Colors.transparent,
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  child: (_selectedTimeSlotIndex == index)
                                      ? Center(
                                          child: Text(
                                            timeSlots[index],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                          timeSlots[index],
                                        )),
                                ),
                              ),
                            );
                          } else if (index == timeSlots.length - 1) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setBottomSheetState(() {
                                    _selectedTimeSlotIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: UiConstants.primaryColor),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0)),
                                    color: (_selectedTimeSlotIndex == index)
                                        ? UiConstants.primaryColor
                                        : Colors.transparent,
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  child: (_selectedTimeSlotIndex == index)
                                      ? Center(
                                          child: Text(
                                            timeSlots[index],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                          timeSlots[index],
                                        )),
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setBottomSheetState(() {
                                    _selectedTimeSlotIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: UiConstants.primaryColor),
                                    color: (_selectedTimeSlotIndex == index)
                                        ? UiConstants.primaryColor
                                        : Colors.transparent,
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  child: (_selectedTimeSlotIndex == index)
                                      ? Center(
                                          child: Text(
                                            timeSlots[index],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                          timeSlots[index],
                                        )),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 5.5,
                    ),
                    Center(
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.blockSizeVertical * 6,
                        // decoration: BoxDecoration(
                        //     borderRadius: new BorderRadius.circular(100.0),
                        //     color: UiConstants.primaryColor),
                        child: FelloButtonLg(
                          child: Text(
                            'Confirm',
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.white,
                                fontSize: SizeConfig.mediumTextSize * 1.4,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            try {
                              if (_requestCallPhoneController.text
                                      .trim()
                                      .length !=
                                  10) {
                                BaseUtil.showNegativeAlert(
                                  'Incorrect',
                                  'Please enter a valid phone number',
                                );
                                return;
                              }
                              bool res = await dbProvider.addCallbackRequest(
                                  baseProvider.myUser.uid,
                                  baseProvider.myUser.name,
                                  _requestCallPhoneController.text.trim(),
                                  callTimes[_selectedTimeSlotIndex]);
                              if (res) {
                                _mixpanelService.track(MixpanelEvents.requestedCallback,{'userId':_userService.baseUser.uid});
                                BaseUtil.showPositiveAlert(
                                  'Callback Placed',
                                  'Thank you for letting us know, we will call you soon!',
                                );
                                Navigator.of(context).pop();
                              } else {
                                BaseUtil.showNegativeAlert(
                                  'Error',
                                  'Something went wrong while placing a request, please try again later.',
                                );
                                if (baseProvider.myUser.uid != null) {
                                  Map<String, dynamic> errorDetails = {
                                    'error_msg':
                                        'Placing a call request failed',
                                    'Phone Number':
                                        _requestCallPhoneController.text.trim(),
                                  };
                                  dbProvider.logFailure(
                                      baseProvider.myUser.uid,
                                      FailType.RequestCallbackFailed,
                                      errorDetails);
                                }
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              BaseUtil.showNegativeAlert(
                                'Error',
                                'Something went wrong while placing a request, please try again later.',
                              );
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _launchEmail() {
    _mixpanelService.track(MixpanelEvents.emailInitiated,{'userId':_userService.baseUser.uid});
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'hello@fello.in');
    launch(emailLaunchUri.toString());
  }
}

class TermsRow extends StatelessWidget {
  const TermsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Terms of Service',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
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
        Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
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
        Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Referral Policy',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              // BaseUtil.launchUrl('https://fello.in/policy/privacy');
              AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        )
      ],
    );
  }
}
