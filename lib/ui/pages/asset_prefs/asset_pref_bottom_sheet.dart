import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:felloapp/util/assets.dart' as a;

class AssetPrefBottomSheet extends StatelessWidget {
  AssetPrefBottomSheet(
      {Key? key, required this.comingFromSkip, required this.model});
  bool comingFromSkip;
  AssetPreferenceViewModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: SizeConfig.padding24,
          left: SizeConfig.padding24,
          right: SizeConfig.padding22),
      child: Column(
        children: [
          Text(
            comingFromSkip ? "Don't Worry" : "Want to know more about Fello?",
            style: TextStyles.rajdhaniSB.body0
                .colour(UiConstants.kTextFieldTextColor),
          ),
          Text(
            comingFromSkip
                ? "You can continue this screen by clicking on this card "
                : "We can help you decide assets more suitable for you",
            style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding24),
            child: comingFromSkip
                ? SvgPicture.asset(a.Assets.assetPrefBottomSheet1)
                : SvgPicture.asset(a.Assets.assetPrefBottomSheet1),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          comingFromSkip
              ? SecondaryButton(
                  onPressed: () {
                    model.handleRouting(AssetPrefOptions.NO_PREF);
                  },
                  label: "Proceed")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        model.handleRouting(AssetPrefOptions.NO_PREF);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness8),
                            border: Border.all(color: Colors.white)),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding8,
                            horizontal: SizeConfig.padding16),
                        child: Text(
                          "SKIP TO HOME",
                          style: TextStyles.rajdhaniB.body1.colour(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding8,
                          horizontal: SizeConfig.padding42),
                      height: SizeConfig.padding44,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                      ),
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "KNOW MORE",
                        style: TextStyles.rajdhaniB.body1.colour(
                          Colors.black,
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
