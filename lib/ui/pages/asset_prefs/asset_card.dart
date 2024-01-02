import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),
        SizedBox(
          width: SizeConfig.padding16,
        ),
        Container(
          width: SizeConfig.padding4 * 73.75,
          height: SizeConfig.padding20 * 9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: UiConstants.teal4,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    a.Assets.floAsset,
                    height: SizeConfig.padding40,
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Text(
                    "Fello P2P",
                    style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.padding14,
                    right: SizeConfig.padding14,
                    top: SizeConfig.padding4),
                child: Text(
                  "A P2P lending asset powered by Lendbox with 8%,10% & 12% returns plans",
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.padding4,
                    left: SizeConfig.padding4,
                    right: SizeConfig.padding4),
                child: Container(
                    height: SizeConfig.padding4 * 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: UiConstants.teal5),
                    padding: EdgeInsets.only(
                        left: SizeConfig.padding8,
                        right: SizeConfig.padding16,
                        top: SizeConfig.padding16),
                    child: Row(children: [
                      Column(
                        children: [
                          Text(
                            "P2P",
                            style: TextStyles.rajdhaniSB.body1
                                .colour(Colors.white),
                          ),
                          Text("Asset",
                              style: TextStyles.rajdhani.body4
                                  .colour(Colors.white))
                        ],
                      )
                    ])),
              )
            ],
          ),
        )
      ],
    );
  }
}
