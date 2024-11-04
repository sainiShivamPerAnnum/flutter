import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class ViewAllLive<T> extends StatelessWidget {
  const ViewAllLive({
    required this.appBarTitle,
    required this.liveList,
    required this.upcomingList,
    required this.recentList,
    super.key,
  });
  final String appBarTitle;
  final List<LiveStream>? liveList;
  final List<UpcomingStream>? upcomingList;
  final List<RecentStream>? recentList;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(appBarTitle, style: TextStyles.rajdhaniSB.body1),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final item in liveList ?? upcomingList ?? recentList ?? [])
              LiveCardWidget(
                status: 'live',
                title: item.title,
                subTitle: item.subtitle,
                author: item.author,
                category: item.categories.join(', '),
                bgImage: item.thumbnail,
                liveCount: item.liveCount,
                advisorCode: item.advisorCode,
                viewerCode: item.viewerCode,
              ),
          ],
        ),
      ),
    );
  }
}

// LiveCardWidget(
//                 status: 'upcoming',
//                 title: live.title,
//                 subTitle: live.subtitle,
//                 author: live.author,
//                 category: live.categories.join(', '),
//                 bgImage: live.thumbnail,
//                 duration: live.startTime,
//               ),

//               LiveCardWidget(
//               status: 'recent',
//               title: recent.title,
//               subTitle: recent.subtitle,
//               author: recent.author,
//               category: recent.categories.join(', '),
//               bgImage: recent.thumbnail,
//               liveCount: recent.views, // Number of views instead of live count
//               duration: recent.duration.toString(),
//             ),