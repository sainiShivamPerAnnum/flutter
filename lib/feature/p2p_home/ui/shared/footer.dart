import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UiConstants.bg,
      padding: EdgeInsets.only(
        left: SizeConfig.padding32,
        right: SizeConfig.padding32,
        bottom: SizeConfig.padding16,
        top: SizeConfig.padding8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(
                Assets.floAsset,
                height: SizeConfig.padding28,
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                '56% of our users have invested in Fello Flo',
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.textGray50,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Expanded(
                child: SecondaryOutlinedButton(
                  label: 'INVEST ONCE',
                  onPressed: () =>
                      DefaultTabController.of(context).animateTo(1),
                ),
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Expanded(
                child: SecondaryButton(
                  label: 'START SIP',
                  onPressed: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: SipIntroPageConfig,
                      widget: const SipIntroView(),
                      state: PageState.addWidget,
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
