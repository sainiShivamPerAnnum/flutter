import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Live extends StatelessWidget {
  final SaveViewModel model;
  const Live({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
         SizedBox(height: SizeConfig.padding14),
        TopLive(model: model),
      ],
    );
  }
}

class TopLive extends StatelessWidget {
  final SaveViewModel model;
  const TopLive({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < data.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8)
                      .copyWith(bottom: SizeConfig.padding8),
                  child: LiveCardWidget(
                    status: data[i]['status'],
                    title: data[i]['title'],
                    subTitle: data[i]['subTitle'],
                    author: data[i]['author'],
                    category: data[i]['category'],
                    bgImage: data[i]['bgImage'],
                    liveCount: data[i]["metadata"]['liveCount'],
                    duration: data[i]["metadata"]['duration'],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
