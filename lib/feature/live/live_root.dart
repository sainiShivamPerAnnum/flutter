import 'package:felloapp/feature/live/widgets/header.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/widgets.dart';

class LiveHome extends StatefulWidget {
  const LiveHome({super.key});

  @override
  State<LiveHome> createState() => _LiveHomeState();
}

class _LiveHomeState extends State<LiveHome> {
  final List<dynamic> data = [
    {
      "status": "live",
      "title": "Trade in Indian Stock Market",
      "subTitle": "Started at 11:00AM",
      "author": "Vibhor Varshney",
      "category": "Stocks",
      "bgImage":
          "https://ik.imagekit.io/9xfwtu0xm/experts/live1.png?updatedAt=1727083174845",
      "metadata": {"duration": null, "liveCount": 2000}
    },
    {
      "status": "upcoming",
      "title": "Cryptocurrency Trends",
      "subTitle": "Starts at 2:00PM",
      "author": "Meera Kapoor",
      "category": "Crypto",
      "bgImage":
          "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
      "metadata": {"duration": null, "liveCount": null}
    },
    {
      "status": "completed",
      "title": "Understanding Mutual Funds",
      "subTitle": "Completed at 9:30AM",
      "author": "Arjun Patel",
      "category": "Investments",
      "bgImage":
          "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
      "metadata": {"duration": "1h 30m", "liveCount": null}
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding14),
          GestureDetector(
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleSubtitleContainer(
                  title: "Live",
                ),
              ],
            ),
          ),
          // TopLive(model: model),
          LiveHeader(
            title: 'Streaming Live',
            subtitle: 'Interact with advisors in live sessions for free',
            onViewAllPressed: () {},
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                        ).copyWith(bottom: 8),
                        child: LiveCardWidget(
                          status: data[i]['status'],
                          title: data[i]['title'],
                          subTitle: data[i]['subTitle'],
                          author: data[i]['author'],
                          category: data[i]['category'],
                          bgImage: data[i]['bgImage'],
                          liveCount: data[i]["metadata"]['liveCount'],
                          duration: data[i]["metadata"]['duration'],
                        )),
                ],
              ),
            ),
          ),
          LiveHeader(
            title: 'Recent Live Streams',
            subtitle: 'Catch up on our latest live streams for expert insights',
            onViewAllPressed: () {},
          ),
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8)
                            .copyWith(bottom: 8),
                        child: LiveCardWidget(
                          status: data[i]['status'],
                          title: data[i]['title'],
                          subTitle: data[i]['subTitle'],
                          author: data[i]['author'],
                          category: data[i]['category'],
                          bgImage: data[i]['bgImage'],
                          liveCount: data[i]["metadata"]['liveCount'],
                          duration: data[i]["metadata"]['duration'],
                        )),
                ],
              ),
            ),
          ),
          LiveHeader(
            title: 'Streaming Live',
            subtitle: 'Interact with advisors in live sessions for free',
            onViewAllPressed: () {},
          ),
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8)
                            .copyWith(bottom: 8),
                        child: LiveCardWidget(
                          status: data[i]['status'],
                          title: data[i]['title'],
                          subTitle: data[i]['subTitle'],
                          author: data[i]['author'],
                          category: data[i]['category'],
                          bgImage: data[i]['bgImage'],
                          liveCount: data[i]["metadata"]['liveCount'],
                          duration: data[i]["metadata"]['duration'],
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
