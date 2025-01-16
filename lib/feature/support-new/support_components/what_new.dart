import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WhatNew extends StatelessWidget {
  const WhatNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding40),
        const TitleSubtitleContainer(
          title: "What is new in Fello",
          zeroPadding: true,
        ),
        const WhatIsNew(),
      ],
    );
  }
}

class WhatIsNew extends StatelessWidget {
  const WhatIsNew({Key? key}) : super(key: key);

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
      padding: EdgeInsets.only(top: SizeConfig.padding24),
      child: Column(
        children: [
          for (int i = 0; i < data.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.padding24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    data[i]['image'],
                    height: SizeConfig.padding50,
                  ),
                  SizedBox(width: SizeConfig.padding18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[i]['title'],
                          style: TextStyles.sourceSansSB.body2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data[i]['subTitle'],
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.customSubtitle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
