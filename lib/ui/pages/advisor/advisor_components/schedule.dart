//Project Imports
// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/static/event_cover_image.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
//Flutter Imports
import 'package:flutter/material.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ScheduleCall extends StatefulWidget {
  final String? id;
  final String? status;
  final String? title;
  final String? subTitle;
  final String? author;
  final String? category;
  final String? bgImage;
  final int? liveCount;
  final int? duration;
  final String? timeSlot;

  ScheduleCall(
      {this.id,
      this.status,
      this.title,
      this.subTitle,
      this.author,
      this.category,
      this.bgImage,
      this.liveCount,
      this.duration,
      this.timeSlot});
  @override
  ScheduleCallWrapper createState() => ScheduleCallWrapper();

  // @override
  // Widget build(BuildContext context) {
  //   return ScheduleCallWrapper();
  // }
}

class ScheduleCallWrapper extends State<ScheduleCall> {
  // final ScheduleCallModel model;
  XFile? selectedProfilePicture;
  S locale = locator<S>();
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String selectedCategory = 'Personal Finance';
  final AdvisorRepo _advisorRepo = locator<AdvisorRepo>();
  final categories = [
    "Personal Finance",
    "Mutual Funds",
    "Retirement Planning",
    "Loan Expert",
    "Tax and Compliance",
    "Stock Market",
    "Savings and Planning",
    "Alternate Assets"
  ];
  final List<Map<String, String>> dates = generateDates(5);
  int _selectedDateIndex = 0; // Initially selected date
  int _selectedTimeIndex = 0; // Initially selected date
  bool _inProgress = false;
  get inProgress => _inProgress;

  final List<Map<String, String>> time = [
    {'TimeUI': '10:00 AM'},
    {'TimeUI': '11:00 AM'},
    {'TimeUI': '12:00 PM'},
    {'TimeUI': '1:00 PM'},
    {'TimeUI': '2:00 PM'},
    {'TimeUI': '3:00 PM'},
    {'TimeUI': '4:00 PM'},
    {'TimeUI': '5:00 PM'},
    {'TimeUI': '6:00 PM'},
    {'TimeUI': '7:00 PM'},
    {'TimeUI': '8:00 PM'},
  ];

  late TextEditingController topicController;
  late TextEditingController descriptionController;
  @override
  void initState() {
    super.initState();
    // Initialize the controllers with values from widget
    // Initialize the controllers first
    topicController = TextEditingController();
    descriptionController = TextEditingController();
    if (widget.id != null) {
      topicController = TextEditingController(text: widget.title);
      descriptionController = TextEditingController(text: widget.subTitle);
      selectedCategory = widget.category!;
      DateTime dateTime = DateTime.parse(widget.timeSlot!);
      _selectedDateIndex = dates
          .indexWhere((element) => element['date'] == dateTime.day.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          const NewSquareBackground(
            backgroundColor:
                UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
          ),
          SingleChildScrollView(
            // reverse: true,
            child: Column(
              children: [
                SizedBox(
                    width: SizeConfig.screenWidth,
                    // height: SizeConfig.screenHeight,
                    child: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.white, //change your color here
                      ),
                      centerTitle: true,
                      title: const Text(
                        'Schedule Live',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Colors.transparent,
                      // mainAxisSize: MainAxisSize.min,
                    )),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What is the Topic of Live",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: topicController,
                            decoration: InputDecoration(
                              hintText: "Start typing here", // Placeholder text
                              hintStyle: const TextStyle(
                                color: Color(0xFFA2A0A2),
                              ), // Light grey placeholder text
                              filled: true,
                              fillColor: Color(0xFF2D3135),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                                borderSide: BorderSide.none, // No border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners when enabled
                                borderSide: BorderSide
                                    .none, // No border when not focused
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners when focused
                                borderSide: BorderSide
                                    .none, // No border color even when focused
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12), // Padding inside the field
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors
                                    .white), // Text color inside the input
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Add description",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Start typing here", // Placeholder text
                              hintStyle: const TextStyle(
                                color: Color(0xFFA2A0A2),
                              ), // Light grey placeholder text
                              filled: true,
                              fillColor: Color(0xFF2D3135),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                                borderSide: BorderSide.none, // No border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners when enabled
                                borderSide: BorderSide
                                    .none, // No border when not focused
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners when focused
                                borderSide: BorderSide
                                    .none, // No border color even when focused
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              // Padding inside the field
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 24, bottom: 24),
                            child: Divider(
                              color: Color(0xFF49494B),
                              height: 0,
                              // indent: 0,
                              thickness: 1,
                            ),
                          ),
                          Text(
                            "Select Category for Live",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = categories[index];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1A1A1A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: selectedCategory ==
                                              categories[index]
                                          ? Border.all(
                                              color: const Color(0xffffffff),
                                              width: 1,
                                            )
                                          : Border.all(
                                              color: const Color(0xff1A1A1A),
                                              width: 1,
                                            )),
                                  child: Center(
                                    child: Text(
                                      categories[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24),
                          const Text(
                            "Upload Cover Image",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Upload and resize image to be used as cover for your upcoming live ",
                                  style: TextStyle(
                                      color: Color(0xffA2A0A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  checkGalleryPermission();
                                  // Handle image upload logic
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  selectedProfilePicture != null
                                      ? "Re Upload Image"
                                      : 'Upload Image',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          const Text(
                            "Select Date",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing:
                                10.0, // Space between the chips horizontally
                            runSpacing:
                                10.0, // Space between the chips vertically
                            children: List<Widget>.generate(dates.length,
                                (int index) {
                              bool isSelected = _selectedDateIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDateIndex =
                                        index; // Update selected index on tap
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .transparent, // Transparent background
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xff2D3135), // Border color
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        dates[index]['day']!,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Text(
                                        dates[index]['date']!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 24),
                          const Text(
                            "Select Time",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing:
                                10.0, // Space between the chips horizontally
                            runSpacing:
                                10.0, // Space between the chips vertically
                            children:
                                List<Widget>.generate(time.length, (int index) {
                              bool isSelected = _selectedTimeIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeIndex =
                                        index; // Update selected index on tap
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .transparent, // Transparent background
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xff2D3135), // Border color
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        time[index]['TimeUI']!,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(
                            height: 48,
                          ),
                          SizedBox(
                            height: 48,
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              if (widget.id != null)
                                updateEvent()
                              else
                                postEvent()
                            }, // `null` to make the button disabled
                            style: ElevatedButton.styleFrom(
                              // disabledBackgroundColor: Colors.pink,
                              backgroundColor: Colors
                                  .white, // Grey background for disabled button
                              minimumSize: Size(double.infinity,
                                  50), // Full width and fixed height
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                            ),
                            child: Text(
                              'Schedule Live',
                              style: TextStyle(
                                  color: Color(0xff3F4748),
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w600), // Dark text color
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ]))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateEvent() async {
    _inProgress = true;

    String dateString =
        dates[_selectedDateIndex]['dateTime'] ?? '2024-10-2314:00:00.000';
    String timeString =
        time[_selectedTimeIndex]['TimeUI'] ?? '2024-10-2314:00:00.000';

    // Define the date format to parse the input date and time
    DateFormat dateFormat = DateFormat("MMMM d, yyyy h:mm:ss a");
    DateFormat timeFormat = DateFormat("h:mm a");

    // Parse the date
    DateTime parsedDate = dateFormat.parse(dateString);

    // Parse the time separately (for the new time: 2:00 PM)
    DateTime parsedTime = timeFormat.parse(timeString);

    // Combine the parsed date and the new time (2:00 PM)
    DateTime finalDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    String isoDateTime = finalDateTime.toIso8601String();
    final payload = {
      'id': widget.id,
      "topic": topicController.text,
      "description": descriptionController.text,
      "categories": [selectedCategory],
      "coverImage": selectedProfilePicture?.path ?? 'example.jpg',
      "eventTimeSlot": isoDateTime,
      "duration": 90,
      "advisorId": "advisor-123",
      "status": "live",
      "totalLiveCount": 100,
      "broadcasterLive": "https://example.com/live/broadcast",
      "viewerLink": "https://example.com/viewerLink",
      "100msEventId": "100ms-event-123",
      "token": "token-123"
    };
    print('UpdateUpdateUpdateUpdateUpdateUpdate $payload');
    AppState.blockNavigation();
    final resp = await _advisorRepo.putEvent(payload);
    log("respppppp=====> $resp");
    if (resp.isSuccess()) {
      BaseUtil.showPositiveAlert(locale.eventUpdateSuccess, 'Success');
    } else {
      // _logger.e(withdrawalTxn.errorMessage);
      BaseUtil.showNegativeAlert(
        locale.withDrawalFailed,
        resp.errorMessage,
      );
    }

    AppState.unblockNavigation();
    _inProgress = false;
    // notifyListeners();
  }

  Future<void> postEvent() async {
    _inProgress = true;

    String dateString =
        dates[_selectedDateIndex]['dateTime'] ?? '2024-10-2314:00:00.000';
    String timeString =
        time[_selectedTimeIndex]['TimeUI'] ?? '2024-10-2314:00:00.000';

    // Define the date format to parse the input date and time
    DateFormat dateFormat = DateFormat("MMMM d, yyyy h:mm:ss a");
    DateFormat timeFormat = DateFormat("h:mm a");

    // Parse the date
    DateTime parsedDate = dateFormat.parse(dateString);

    // Parse the time separately (for the new time: 2:00 PM)
    DateTime parsedTime = timeFormat.parse(timeString);

    // Combine the parsed date and the new time (2:00 PM)
    DateTime finalDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    String isoDateTime = finalDateTime.toIso8601String();
    final payload = {
      "id": "event-123",
      "topic": topicController.text,
      "description": descriptionController.text,
      "categories": [selectedCategory],
      "coverImage": selectedProfilePicture?.path ?? 'example.jpg',
      "eventTimeSlot": isoDateTime,
      "duration": 90,
      "advisorId": "advisor-123",
      "status": "live",
      "totalLiveCount": 100,
      "broadcasterLive": "https://example.com/live/broadcast",
      "viewerLink": "https://example.com/viewerLink",
      "100msEventId": "100ms-event-123",
      "token": "token-123"
    };
    print('payloadpayloadpayload $payload');
    AppState.blockNavigation();
    final resp = await _advisorRepo.saveEvent(payload);
    log("respppppp=====> $resp");
    if (resp.isSuccess()) {
      BaseUtil.showPositiveAlert(locale.eventSuccess, 'Success');
    } else {
      // _logger.e(withdrawalTxn.errorMessage);
      BaseUtil.showNegativeAlert(
        locale.withDrawalFailed,
        resp.errorMessage,
      );
    }

    AppState.unblockNavigation();
    _inProgress = false;
    // notifyListeners();
  }

  Future<bool> checkGalleryPermission() async {
    if (await BaseUtil.showNoInternetAlert()) return false;
    var status = await Permission.photos.status;
    if (status.isRestricted || status.isLimited || status.isDenied) {
      await BaseUtil.openDialog(
        isBarrierDismissible: false,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: locale.reqPermission,
          description: locale.galleryAccess,
          buttonText: locale.btnContinue,
          asset: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              "images/gallery.png",
              height: SizeConfig.screenWidth! * 0.24,
            ),
          ),
          confirmAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            _chooseprofilePicture();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
        ),
      );
    } else if (status.isGranted) {
      _chooseprofilePicture();
    } else {
      BaseUtil.showNegativeAlert(
        locale.permissionUnavailable,
        locale.enablePermission,
      );
      return false;
    }
    return false;
  }

  _chooseprofilePicture() async {
    selectedProfilePicture = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    String imageName = selectedProfilePicture!.path.split("/").last;
    // String targetPath = "${supportDir.path}/c-$imageName";
    print("temp path: $imageName");
    print("orignal path: ${selectedProfilePicture!.path}");

    if (selectedProfilePicture != null) {
      await BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissible: false,
        content: ConfirmationDialog(
          asset: CoverImage(
            showAction: false,
            image: ClipOval(
              child: Image.file(
                File(selectedProfilePicture!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          buttonText: locale.btnSave,
          cancelBtnText: locale.btnDiscard,
          description: '',
          confirmAction: () {
            print(selectedProfilePicture);
            AppState.backButtonDispatcher!.didPopRoute();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
          title: 'Cover Image',
        ),
      );
      // _rootViewModel.refresh();
      // notifyListeners();
    }
  }
}

List<Map<String, String>> generateDates(int numberOfDays) {
  final List<Map<String, String>> dates = [];
  final DateFormat dayFormat =
      DateFormat('E'); // Format for day (e.g., Mon, Tue)
  final DateFormat dateFormat =
      DateFormat('d'); // Format for day of the month (e.g., 12, 13)
  final DateFormat dateTimeFormat = DateFormat();
  for (int i = 0; i < numberOfDays; i++) {
    DateTime currentDate = DateTime.now().add(Duration(days: i));
    dates.add({
      'day': dayFormat.format(currentDate), // 'Thu', 'Fri', etc.
      'date': dateFormat.format(currentDate),
      'dateTime': dateTimeFormat.format(currentDate) // '12', '13', etc.
    });
  }

  return dates;
}
