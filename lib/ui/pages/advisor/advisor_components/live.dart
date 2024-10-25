import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/live/widgets/upcoming_live_card.dart';
import 'package:felloapp/feature/live/widgets/video_card.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/advisor/advisor_components/schedule.dart';
import 'package:felloapp/ui/pages/advisor/advisor_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/support-new/support_viewModel.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Live extends StatelessWidget {
  final AdvisorViewModel model;
  const Live({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding14),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2C2C2E), // Dark gray background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SCHEDULE LIVE',
                    style: TextStyle(
                      color: Colors
                          .tealAccent[200], // Light teal color for the header
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4), // Spacing between the text lines
                  Text(
                    'Plan your next live stream.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  navigateToViewAllBlogs();
                  // Add your button press functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button color
                  foregroundColor: Colors.black, // Text color inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded button
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text('Create New'),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSubtitleContainer(
                titleStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                title: "Advisor Section",
                leadingPadding: true,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: LiveFello(model: model),
        )
      ],
    );
  }

  void navigateToViewAllBlogs() {
    Haptic.vibrate();
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ScheduleCallViewConfig,
      widget: ScheduleCall(),
    );
  }
}

class LiveFello extends StatelessWidget {
  final AdvisorViewModel model;
  final AdvisorRepo _advisorRepo = locator<AdvisorRepo>();
  LiveFello({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getEvents(), // Call the function to fetch events
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading data")); // Error state
        }
        // If the data is available, use it
        final List<dynamic> data = snapshot.data ?? [];
        print("aiushdihd i hdihasiudhiuahd iuhaiud iu ad iuhad $data");
        return Padding(
          padding: EdgeInsets.only(top: SizeConfig.padding20),
          child: SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8)
                            .copyWith(bottom: 8),
                        child: SizedBox(
                          child: UpcomingLiveCardWidget(
                            id: data[i]['id'],
                            status: data[i]['status'],
                            title: data[i]['topic'],
                            subTitle: data[i]['description'],
                            author: 'Not coming from backend',
                            category: data[i]['categories'][0],
                            bgImage: data[i]['coverImage'],
                            liveCount: data[i]["totalLiveCount"],
                            duration: data[i]["duration"],
                            timeSlot: data[i]['eventTimeSlot'],
                          ),
                        )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<dynamic>> getEvents() async {
    final payload = {"advisorId": 'advisor-123'};
    AppState.blockNavigation();
    final resp = await _advisorRepo.getEvents(payload);
    AppState.unblockNavigation();
    print("resp=====> ${resp.model} ");
    if (resp.isSuccess()) {
      return resp.model; // Assuming the data is in the 'data' field
    } else {
      BaseUtil.showNegativeAlert('Error', resp.errorMessage);
      return []; // Return an empty list in case of failure
    }
  }
}
