//Project Imports
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
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
  BaseUtil baseProvider;
  AppState appState;
  DBModel dbProvider;
  TextEditingController _requestCallPhoneController = TextEditingController();
  bool isInit = false;

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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  UiConstants.primaryColor.withGreen(190),
                  UiConstants.primaryColor,
                ],
              ),
            ),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.3,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      'images/svgs/contact_bg_illustration.svg',
                      width: SizeConfig.screenWidth * 0.6,
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    height: double.infinity,
                    width: SizeConfig.screenWidth * 0.6,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  "Support 👩🏼‍🔧",
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          SizeConfig.cardTitleTextSize * 2,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              "( 24 x 7 )",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "We're just a click and text away. Always.",
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.4,
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        SizedBox(width: SizeConfig.blockSizeHorizontal),
                        IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                          ),
                          onPressed: () =>
                              AppState.backButtonDispatcher.didPopRoute(),
                        ),
                        Spacer(),
                        Image.asset(
                          "images/fello_logo.png",
                          width: SizeConfig.screenWidth * 0.1,
                          color: Colors.white,
                        ),
                        Spacer(),
                        IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: SizedBox(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    child: Text(
                      "Reach Out",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: UiConstants.primaryColor.withOpacity(0.5),
                        fontSize: SizeConfig.largeTextSize,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Chat with Us',
                        style: TextStyle(color: UiConstants.textColor)),
                    tileColor: Colors.transparent,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      Haptic.vibrate();
                      appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: ChatSupportPageConfig);
                    },
                  ),
                  ListTile(
                    title: Text('Email Us',
                        style: TextStyle(color: UiConstants.textColor)),
                    tileColor: Colors.transparent,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      Haptic.vibrate();
                      try {
                        _launchEmail();
                      } catch (e) {
                        baseProvider.showNegativeAlert(
                            'Error',
                            'Something went wrong, could not launch email right now. Please try again later',
                            context);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Request a callback',
                        style: TextStyle(
                          color: UiConstants.textColor,
                        )),
                    tileColor: Colors.transparent,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      Haptic.vibrate();
                      if (connectivityStatus != ConnectivityStatus.Offline)
                        _showRequestCallSheet();
                      else
                        baseProvider.showNoInternetAlert(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    child: Text(
                      "Self-serve",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: UiConstants.primaryColor.withOpacity(0.5),
                        fontSize: SizeConfig.largeTextSize,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Play Walkthrough',
                        style: TextStyle(color: UiConstants.textColor)),
                    tileColor: Colors.transparent,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      Haptic.vibrate();
                      appState.currentAction = PageAction(
                          state: PageState.addPage, page: WalkThroughConfig);
                    },
                  ),
                  ListTile(
                    title: Text('FAQs',
                        style: TextStyle(color: UiConstants.textColor)),
                    tileColor: Colors.transparent,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      Haptic.vibrate();
                      appState.currentAction = PageAction(
                          state: PageState.addPage, page: FaqPageConfig);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
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
                      'Give us your number and we will call you back.',
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
                                baseProvider.showNegativeAlert(
                                    'Incorrect',
                                    'Please enter a valid phone number',
                                    context);
                                return;
                              }
                              bool res = await dbProvider.addCallbackRequest(
                                  baseProvider.myUser.uid,
                                  baseProvider.myUser.name,
                                  _requestCallPhoneController.text.trim(),
                                  callTimes[_selectedTimeSlotIndex]);
                              if (res) {
                                baseProvider.showPositiveAlert(
                                    'Callback Placed',
                                    'Thank you for letting us know, we will call you soon!',
                                    context);
                                Navigator.of(context).pop();
                              } else {
                                baseProvider.showPositiveAlert(
                                    'Error',
                                    'Something went wrong while placing a request, please try again later.',
                                    context);
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
                              baseProvider.showPositiveAlert(
                                  'Error',
                                  'Something went wrong while placing a request, please try again later.',
                                  context);
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
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'hello@fello.in');
    launch(emailLaunchUri.toString());
  }
}
