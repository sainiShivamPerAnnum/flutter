import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/advisor/advisor_components/schedule.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class UpcomingLiveCardWidget extends StatelessWidget {
  final String? id;
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final int? duration;
  final String? timeSlot;

  UpcomingLiveCardWidget({
    this.id,
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    this.liveCount,
    this.duration,
    this.timeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff2D3135),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with play button overlay
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage(bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (status == 'live')
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (status == 'upcoming')
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'STARTS IN 03:59',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Join Live',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (status == 'live')
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.play_circle_filled,
                      color: Colors.white, size: 50),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0x6601656B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                        color: Color(0xFF1ABCC5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                SizedBox(height: 5),

                // Title
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                // Subtitle (time started or duration)
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        author,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {navigateToViewAllBlogs()},
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: Color(0xFF232326),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
                // Author's name
              ],
            ),
          )
          // Category tag
        ],
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stocks':
        return Colors.green;
      case 'crypto':
        return Colors.blue;
      case 'investments':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void navigateToViewAllBlogs() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.allblogsview);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ScheduleCallViewConfig,
      widget: ScheduleCall(
          id: id,
          status: status, // "live"
          title: title, // "Investment Webinar"
          subTitle:
              subTitle, // "A comprehensive webinar on investment strategies."
          author: author, // "Not coming from backend"
          category: category, // "Finance"
          bgImage: bgImage, // "https://example.com/image.jpg"
          liveCount: liveCount, // 3
          duration: duration,
          timeSlot: timeSlot),
    );
  }
}
