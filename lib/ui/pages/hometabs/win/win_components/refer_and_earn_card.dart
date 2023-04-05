import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ReferEarnCard extends StatelessWidget {
  const ReferEarnCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addPage,
              page: ReferralDetailsPageConfig,
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.padding24,
                SizeConfig.padding24,
                SizeConfig.padding24,
                (SizeConfig.screenWidth! * 0.15) / 2),
            width: double.infinity,
            decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness12))),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    SizeConfig.padding24,
                  ),
                  child: Column(
                    children: [
                      ReferAndEarnAsset(),
                      SizedBox(height: SizeConfig.padding20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: locale.earnUpto,
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTextColor3)),
                            TextSpan(
                                text:
                                    '₹${AppConfig.getValue(AppConfigKey.referralBonus)} ' +
                                        locale.and,
                                style: TextStyles.sourceSansB.body3
                                    .colour(UiConstants.kTextColor)),
                            WidgetSpan(
                                child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding4),
                              height: 17,
                              width: 17,
                              child: SvgPicture.asset(
                                Assets.token,
                              ),
                            )),
                            TextSpan(
                                text:
                                    '${AppConfig.getValue(AppConfigKey.referralFlcBonus)}',
                                style: TextStyles.sourceSansB.body3
                                    .colour(UiConstants.kTextColor)),
                            TextSpan(
                                text: locale.winipadText,
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTextColor3)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding28,
                      ),
                      Consumer<ReferralService>(
                        builder: (context, model, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding12,
                                    vertical: SizeConfig.padding6),
                                decoration: BoxDecoration(
                                  color:
                                      UiConstants.kArrowButtonBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.roundness8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      model.refCode,
                                      style: TextStyles.rajdhaniEB.title2
                                          .colour(Colors.white),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.padding24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        model.copyReferCode();
                                      },
                                      child: Row(
                                        children: [
                                          Text(locale.copy,
                                              style: TextStyles.sourceSans.body3
                                                  .colour(UiConstants
                                                      .kTextColor3
                                                      .withOpacity(0.7))),
                                          SizedBox(
                                            width: SizeConfig.padding6,
                                          ),
                                          Icon(
                                            Icons.copy,
                                            color: UiConstants.kTextColor3
                                                .withOpacity(0.7),
                                            size: SizeConfig.padding24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.padding20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding12,
                                    vertical: SizeConfig.padding12),
                                decoration: BoxDecoration(
                                  color:
                                      UiConstants.kArrowButtonBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (model.isShareAlreadyClicked == false)
                                      model.shareLink();
                                  },
                                  child: Icon(
                                    Icons.share,
                                    color: UiConstants.kTabBorderColor,
                                    size: SizeConfig.padding28,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.pageHorizontalMargins + SizeConfig.padding14,
          right: SizeConfig.pageHorizontalMargins + SizeConfig.padding14,
          child: Icon(
            Icons.keyboard_arrow_right,
            size: SizeConfig.padding28,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
