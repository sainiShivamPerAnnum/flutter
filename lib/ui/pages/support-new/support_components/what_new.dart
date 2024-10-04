import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/live/widgets/video_card.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/support-new/support_viewModel.dart';
import 'package:felloapp/util/assets.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WhatNew extends StatelessWidget {
  final SupportViewModel model;
  const WhatNew({required this.model, Key? key}) : super(key: key);

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
                title: "What is new in Fello",
                leadingPadding: true,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: WhatIsNew(model: model),
        )
      ],
    );
  }
}

class WhatIsNew extends StatelessWidget {
  final SupportViewModel model;
  const WhatIsNew({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data = [
      {
        "title": "Personalised Financial Guidance",
        "subTitle":
            "Join live streaming by top financial experts where you can ask questions.",
        "image": Assets.message,
      },
      {
        "title": "Live Streaming Q&A",
        "subTitle":
            "Connects with financial advisors for one-on-one consultations tailored to your financial needs.",
        "image": Assets.live,
      },
      {
        "title": "Easy and Flexible Booking",
        "subTitle":
            "Find and book a session with a financial advisor that fits your schedule.",
        "image": Assets.cal,
      },
    ];
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding20),
      child: SizedBox(
        // scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            for (int i = 0; i < data.length; i++)
              Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Row(
                    // verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        data[i]['image'],
                        height: 50,
                      ),

                      SizedBox(width: 18), // Space between icon and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[i]['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                    5), // Space between title and description
                            Text(
                              data[i]['subTitle'],
                              style: TextStyle(
                                color: Colors.grey[
                                    400], // Light grey color for the description text
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
