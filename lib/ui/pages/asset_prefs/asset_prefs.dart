import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_prefs_options.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetPrefView extends StatelessWidget {
  const AssetPrefView({
    required this.data,
    this.enteredFromHomePage = false,
    super.key,
  });
  final sections.PageData data;
  final bool enteredFromHomePage;

  String _getButtonLabel(S locale, sections.AssetPrefType? selectedAsset) {
    switch (selectedAsset) {
      case sections.AssetPrefType.P2P:
        return locale.obProceedWithP2P;
      case sections.AssetPrefType.GOLD:
        return locale.obProceedWithGold;
      default:
        return locale.proceed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefViewData = data.screens.assetPreference;

    return BaseView<AssetPreferenceViewModel>(
        onModelReady: (model) => model.init(),
        builder: (context, model, child) {
          final locale = locator<S>();
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  const NewSquareBackground(),
                  if (model.state.isBusy)
                    const FullScreenLoader()
                  else
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.viewInsets.top,
                        right: SizeConfig.padding16,
                        left: SizeConfig.padding20,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: _SkipButton(
                              label: locale.obAssetPrefBottomSheet2ButtonText1,
                              onTap: () => model.onPressedSkip(
                                enteredFromHomePage,
                                prefViewData.skipToHome,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding24,
                          ),
                          Text(
                            locale.obAssetPrefGreeting(model.name),
                            style: TextStyles.rajdhaniSB.title5,
                          ),
                          Text(
                            locale.obAssetWelcomeText,
                            style: TextStyles.rajdhaniSB.body1,
                          ),
                          SizedBox(
                            height: SizeConfig.padding30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prefViewData.title,
                                  style: TextStyles.rajdhaniSB.body1.colour(
                                    Colors.white.withOpacity(.8),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding4,
                                ),
                                Text(
                                  prefViewData.subtitle,
                                  style: TextStyles.rajdhani.body2.colour(
                                    UiConstants.grey1.withOpacity(.8),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding24,
                          ),
                          Column(
                            children: [
                              for (int i = 0;
                                  i < prefViewData.options.length;
                                  i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: SizeConfig.padding24,
                                  ),
                                  child: AssetOptionWidget(
                                    hideNoteSureOption: enteredFromHomePage,
                                    isSelected: (pref) =>
                                        pref == model.selectedAsset,
                                    assetPrefOption: prefViewData.options[i],
                                    onSelect: model.changeSelectedAsset,
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: SizeConfig.padding20),
                            child: SecondaryButton(
                              disabled: model.selectedAsset == null,
                              onPressed: () => model.onProceed(
                                prefViewData.notSure,
                                isDisabled: model.selectedAsset == null,
                              ),
                              label: _getButtonLabel(
                                locale,
                                model.selectedAsset,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    required this.label,
    required this.onTap,
  });
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyles.rajdhaniB.body2.colour(
              Colors.white,
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
    );
  }
}
