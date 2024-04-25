import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutosaveCard extends StatelessWidget {
  final InvestmentType? investmentType;
  final TextStyle? titleStyle;

  const AutosaveCard({
    super.key,
    this.titleStyle,
    this.investmentType,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubService>(
      builder: (context, service, child) => service.autosaveVisible
          ? GestureDetector(
              onTap: () {
                if (context.read<ConnectivityService>().connectivityStatus ==
                    ConnectivityStatus.Offline) {
                  BaseUtil.showNoInternetAlert();
                  return;
                }
                service.handleTap(type: investmentType);
              },
              child: AutoSaveCardNew(
                service: service,
                titleStyle: titleStyle,
              ),
            )
          : const SizedBox(),
    );
  }
}

class AutoSaveCardNew extends StatelessWidget {
  final SubService service;
  final TextStyle? titleStyle;

  const AutoSaveCardNew({
    required this.service,
    this.titleStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userService = locator<UserService>();
    final locale = locator<S>();
    final isSActiveSub = userService.baseUser!.doesHaveSubscriptionTransaction;
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.siptitle,
            style: titleStyle ?? TextStyles.sourceSansSB.title3,
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          GestureDetector(
            onTap: service.handleTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kArrowButtonBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImage(
                    Assets.sipBox,
                    height: SizeConfig.padding90,
                    width: SizeConfig.padding90,
                  ),
                  SizedBox(
                    width: SizeConfig.padding30,
                  ),
                  SizedBox(
                    width: SizeConfig.padding192,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.setupCardTitle,
                          style: TextStyles.rajdhaniSB.body1
                              .colour(UiConstants.kTextColor),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        SizedBox(height: SizeConfig.padding12),
                        Text(
                          locale.setupCardSubTitle,
                          style: TextStyles.sourceSans.body4.colour(
                              UiConstants.kModalSheetMutedTextBackgroundColor),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        SizedBox(height: SizeConfig.padding20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isSActiveSub
                                    ? locale.manageSip
                                    : locale.setupSip,
                                style: TextStyles.sourceSansSB.body2
                                    .colour(UiConstants.kTabBorderColor),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            AppImage(
                              Assets.chevRonRightArrow,
                              height: SizeConfig.padding24,
                              width: SizeConfig.padding24,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
