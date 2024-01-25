import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class DSLBottomSheet extends StatelessWidget {
  const DSLBottomSheet({
    required this.model,
    required this.bottomSheetData,
    super.key,
  });

  final AssetPreferenceViewModel model;
  final BottomSheetComponent bottomSheetData;

  Future<void> _preResolve() async {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.replaceAll,
      page: RootPageConfig,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await PreferenceHelper.setBool(
      PreferenceHelper.isUserOnboardingComplete,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = bottomSheetData.data;
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.padding24,
        left: SizeConfig.padding24,
        right: SizeConfig.padding22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.title,
            style: TextStyles.rajdhaniSB.body1.copyWith(
              color: UiConstants.textGray70,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding4,
          ),
          Text(
            data.subtitle,
            style: TextStyles.rajdhaniSB.title5.copyWith(
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding24),
            child: AppImage(
              data.image,
              height: SizeConfig.padding148,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Row(
            children: [
              for (int i = 0; i < data.cta.length; i++) ...[
                Expanded(
                  child: DSLButtonResolver(
                    cta: data.cta[i],
                    preResolve: _preResolve,
                  ),
                ),
                if (i != data.cta.length - 1)
                  SizedBox(
                    width: SizeConfig.padding14,
                  )
              ]
            ],
          ),
          SizedBox(
            height: SizeConfig.padding18,
          ),
        ],
      ),
    );
  }
}
