import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SkipToHomeBottomSheet extends StatelessWidget {
  const SkipToHomeBottomSheet({super.key, required this.model});
  final AssetPreferenceViewModel model;
  @override
  Widget build(BuildContext context) {
    final S locale = S.of(context);
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.padding24,
          left: SizeConfig.padding24,
          right: SizeConfig.padding22),
      child: Column(
        children: [
          Text(
            locale.obAssetPrefBottomSheet1UpperText,
            style: TextStyles.rajdhaniSB.body0
                .colour(UiConstants.kTextFieldTextColor),
          ),
          Text(
            locale.obAssetPrefBottomSheet1LowerText,
            style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding24),
            child: SvgPicture.asset(a.Assets.assetPrefBottomSheet1),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          SecondaryButton(
              onPressed: () {
                model.handleRouting(AssetPrefOptions.NO_PREF);
              },
              label: locale.obAssetPrefBottomSheet1ButtonText),
        ],
      ),
    );
  }
}

class NoPrefBottomSheet extends StatelessWidget {
  const NoPrefBottomSheet({super.key, required this.model});
  final AssetPreferenceViewModel model;

  @override
  Widget build(BuildContext context) {
    final S locale = S.of(context);
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.padding24,
          left: SizeConfig.padding24,
          right: SizeConfig.padding22),
      child: Column(
        children: [
          Text(
            locale.obAssetPrefBottomSheet2UpperText,
            style: TextStyles.rajdhaniSB.body0
                .colour(UiConstants.kTextFieldTextColor),
          ),
          Text(
            locale.obAssetPrefBottomSheet2LowerText,
            style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding24),
            child: SvgPicture.asset(a.Assets.assetPrefBottomSheet1),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
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
                    locale.obAssetPrefBottomSheet2ButtonText1,
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
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
                color: Colors.white,
                onPressed: () {},
                child: Text(
                  locale.obAssetPrefBottomSheet2ButtonText2,
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
