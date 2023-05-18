import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class SaveWelcomeCard extends StatelessWidget {
  const SaveWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.titleSize / 2),
          bottomRight: Radius.circular(SizeConfig.titleSize / 2),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 10),
              spreadRadius: 8)
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Salutation(
              textStyle: TextStyles.rajdhaniSB.title3.colour(Colors.white),
            ),
          ),
          Text(
            "Welcome to Fello",
            style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding10,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fello Balance", style: TextStyles.rajdhaniSB.title3),
                    Text(
                      "₹10",
                      style: TextStyles.sourceSansB.title4,
                    )
                  ],
                ),
                const Spacer(),
                MaterialButton(
                  color: Colors.white,
                  onPressed: () {},
                  child: Text(
                    "SAVE",
                    style: TextStyles.rajdhaniB.body2
                        .colour(UiConstants.kBackgroundColor),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenWidth! * 0.4,
            width: SizeConfig.screenWidth,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (ctx, i) => Card(
                color: Colors.black,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
                child: SizedBox(
                  width: SizeConfig.screenWidth! * 0.66,
                  height: SizeConfig.screenWidth! * 0.4,
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
        ],
      ),
    );
  }
}
