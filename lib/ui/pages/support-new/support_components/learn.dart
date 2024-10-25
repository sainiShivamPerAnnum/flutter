import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/live/widgets/video_card.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/support-new/support_viewModel.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Learn extends StatelessWidget {
  final SupportViewModel model;
  const Learn({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
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
                titleStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                title: "Learn about Fello",
                leadingPadding: true,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: LearnFello(model: model),
        )
      ],
    );
  }
}

class LearnFello extends StatelessWidget {
  final SupportViewModel model;
  const LearnFello({required this.model, Key? key}) : super(key: key);

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
        "metadata": {"duration": "2:30 MINS", "liveCount": 2000}
      },
      {
        "status": "upcoming",
        "title": "Cryptocurrency Trends",
        "subTitle": "Starts at 2:00PM",
        "author": "Meera Kapoor",
        "category": "Crypto",
        "bgImage":
            "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
        "metadata": {"duration": "2:30 MINS", "liveCount": null}
      },
      {
        "status": "completed",
        "title": "Understanding Mutual Funds",
        "subTitle": "Completed at 9:30AM",
        "author": "Arjun Patel",
        "category": "Investments",
        "bgImage":
            "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
        "metadata": {"duration": "1:30 MINS", "liveCount": null}
      }
    ];
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding20),
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < data.length; i++)
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
                    child: SizedBox(
                      // height: 300,
                      // width: SizeConfig.screenWidth,
                      child: VideoCardWidget(
                        title: data[i]['title'],
                        bgImage: data[i]['bgImage'],
                        duration: data[i]["metadata"]['duration'],
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
