import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_selector.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'asset_pref_bottom_sheet.dart';

class AssetPrefView extends StatelessWidget {
  const AssetPrefView({Key? key}) : super(key: key);

  String getButtonText(AssetPrefOptions? selectedAsset) {
    switch (selectedAsset) {
      case AssetPrefOptions.LENDBOX_P2P:
        return "WITH FELLO P2P";
      case AssetPrefOptions.AUGMONT_GOLD:
        return "WITH DIGITAL GOLD";
      case AssetPrefOptions.NO_PREF:
        return "";
      default:
        return "";
    }
  }

  void handleProceedButton(AssetPreferenceViewModel model) {
    if (model.selectedAsset == null) return;
    if (model.selectedAsset == AssetPrefOptions.NO_PREF) {
      BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          content: SkipToHomeBottomSheet(model: model));
      return;
    } else {
      model.handleRouting(model.selectedAsset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AssetPreferenceViewModel>(
        onModelDispose: (model) {},
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
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
                          GestureDetector(
                            onTap: () {
                              BaseUtil.openModalBottomSheet(
                                  isBarrierDismissible: true,
                                  content: NoPrefBottomSheet(
                                    model: model,
                                  ));
                            },
                            child: Text(
                              "SKIP TO HOME",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.padding6,
                          ),
                          SvgPicture.asset(
                            a.Assets.chevRonRightArrow,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Text("Hi ${model.name}",
                          style: TextStyles.rajdhaniSB.title5
                              .colour(Colors.white)),
                      Text("Welcome to Fello",
                          style:
                              TextStyles.rajdhaniSB.body1.colour(Colors.white)),
                      SizedBox(
                        height: SizeConfig.padding30,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Choose an asset to to start investing",
                                style: TextStyles.rajdhaniSB.body1
                                    .colour(Colors.white)
                                    .setOpacity(0.8),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Text("Read more about assets when you proceed",
                                  style: TextStyles.rajdhani.body2
                                      .colour(UiConstants.grey1)
                                      .setOpacity(0.8))
                            ],
                          ),
                          const Spacer()
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Column(
                        children: [
                          AssetSelector(
                              assetPrefOptions: AssetPrefOptions.LENDBOX_P2P,
                              model: model,
                              onSelect: model.changeSelectedAsset),
                          AssetSelector(
                              assetPrefOptions: AssetPrefOptions.AUGMONT_GOLD,
                              model: model,
                              onSelect: model.changeSelectedAsset),
                          AssetSelector(
                            assetPrefOptions: AssetPrefOptions.NO_PREF,
                            model: model,
                            onSelect: model.changeSelectedAsset,
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.padding20),
                        child: SecondaryButton(
                            onPressed: () {
                              handleProceedButton(model);
                            },
                            label:
                                "PROCEED ${getButtonText(model.selectedAsset)}"),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
