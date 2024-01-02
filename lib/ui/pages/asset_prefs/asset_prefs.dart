import 'package:felloapp/ui/pages/asset_prefs/asset_card.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetPrefView extends StatelessWidget {
  const AssetPrefView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const NewSquareBackground(),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.viewInsets.top,
                right: SizeConfig.padding16,
                left: SizeConfig.padding20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      "SKIP TO HOME",
                      style: TextStyles.rajdhaniB.body2.colour(Colors.white),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    SvgPicture.asset(a.Assets.arrowDottedRight)
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Text("Hi Kartik",
                    style: TextStyles.rajdhaniSB.title5.colour(Colors.white)),
                Text("Welcome to Fello",
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white)),
                SizedBox(
                  height: SizeConfig.padding30,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Choose an asset to to start investing",
                          style:
                              TextStyles.rajdhaniSB.body1.colour(Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        Text("Read more about assets when you proceed",
                            style: TextStyles.rajdhani.body2
                                .colour(UiConstants.grey1))
                      ],
                    ),
                    const Spacer()
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: [
                  const AssetCard(),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  const AssetCard()
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}
