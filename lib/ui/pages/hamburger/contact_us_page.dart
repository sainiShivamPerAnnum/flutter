import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/walkthrough_page.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base_util.dart';
import '../../../main.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with TickerProviderStateMixin {
  BaseUtil baseProvider;
  AppState appState;
  DBModel dbProvider;
  TextEditingController _requestCallPhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // backButtonDispatcher.didPopRoute();
            },
          ),
          elevation: 1.0,
          backgroundColor: UiConstants.primaryColor,
          iconTheme: IconThemeData(
            color: UiConstants.accentColor, //change your color here
          ),
          title: Text('Support',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.largeTextSize)),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: SizeConfig.screenWidth,
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  'images/svgs/contact_bg_illustration.svg',
                  alignment: Alignment.bottomRight,
                ),
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                //     alignment: Alignment.bottomRight,
                //     image: AssetImage('images/contact_bg.png')
                //   )
                // ),
              ),
            ),
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                ListTile(
                  title: Text('Chat with Us',
                      style: TextStyle(color: UiConstants.textColor)),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    HapticFeedback.vibrate();
                    appState.currentAction = PageAction(
                        state: PageState.addPage, page: ChatSupportPageConfig);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                ListTile(
                  title: Text('Email Us',
                      style: TextStyle(color: UiConstants.textColor)),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    HapticFeedback.vibrate();
                    _launchEmail();
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                ListTile(
                  title: Text('Request a call',
                      style: TextStyle(
                        color: UiConstants.textColor,
                      )),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    HapticFeedback.vibrate();
                    _showRequestCallSheet();
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                ListTile(
                  title: Text('Play Walkthrough',
                      style: TextStyle(color: UiConstants.textColor)),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    HapticFeedback.vibrate();
                    appState.currentAction = PageAction(
                        state: PageState.addPage, page: WalkThroughConfig);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                ListTile(
                  title: Text('FAQs',
                      style: TextStyle(color: UiConstants.textColor)),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    HapticFeedback.vibrate();
                    appState.currentAction = PageAction(
                        state: PageState.addPage, page: FaqPageConfig);
                  },
                ),
              ],
            )
          ],
        ));
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
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        backgroundColor: UiConstants.bottomNavBarColor,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 25.0, bottom: 25.0, left: 35.0, right: 35.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    ListTile(
                        title: Center(
                            child: Text(
                          'Request a call',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: UiConstants.primaryColor,
                              fontSize: SizeConfig.largeTextSize * 1.2,
                              fontWeight: FontWeight.bold),
                        )),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: SizeConfig.blockSizeVertical * 4,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )),
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
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: timeSlots.length,
                        separatorBuilder: (ctx, index) {
                          return SizedBox(width: 0);
                        },
                        itemBuilder: (ctx, index) {
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () {
                                setBottomSheetState(() {
                                  _selectedTimeSlotIndex = index;
                                });
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.primaryColor),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0)),
                                  color: (_selectedTimeSlotIndex == index)
                                      ? UiConstants.primaryColor
                                      : Colors.transparent,
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: (_selectedTimeSlotIndex == index)
                                    ? Center(
                                        child: Text(
                                          timeSlots[index],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        timeSlots[index],
                                      )),
                              ),
                            );
                          } else if (index == timeSlots.length - 1) {
                            return GestureDetector(
                              onTap: () {
                                setBottomSheetState(() {
                                  _selectedTimeSlotIndex = index;
                                });
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.primaryColor),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                  color: (_selectedTimeSlotIndex == index)
                                      ? UiConstants.primaryColor
                                      : Colors.transparent,
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: (_selectedTimeSlotIndex == index)
                                    ? Center(
                                        child: Text(
                                          timeSlots[index],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        timeSlots[index],
                                      )),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                setBottomSheetState(() {
                                  _selectedTimeSlotIndex = index;
                                });
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.25,
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        timeSlots[index],
                                      )),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 5.5,
                    ),
                    Center(
                      child: Container(
                        width: SizeConfig.screenWidth * 0.4,
                        height: SizeConfig.blockSizeVertical * 6,
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(100.0),
                            color: UiConstants.primaryColor),
                        child: new Material(
                          child: MaterialButton(
                            child: Text(
                              'Confirm',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: SizeConfig.mediumTextSize * 1.4,
                                      fontWeight: FontWeight.bold),
                            ),
                            highlightColor: Colors.white30,
                            splashColor: Colors.white30,
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
                          color: Colors.transparent,
                          borderRadius: new BorderRadius.circular(30.0),
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
