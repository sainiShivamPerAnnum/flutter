import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/enums/page_state_enum.dart';
import '../../../../../core/service/notifier_services/user_service.dart';
import '../../../../../navigator/app_state.dart';
import '../../../../../navigator/router/ui_pages.dart';
import '../../../../../util/haptic.dart';
import '../../../../../util/localization/generated/l10n.dart';
import '../../../../../util/locator.dart';
import '../../../../architecture/base_view.dart';
import '../../../../elements/appbar/appbar.dart';
import '../../../static/app_widget.dart';
import 'lendbox_withdrawal_vm.dart';

class FlexiBalanceView extends StatelessWidget {
  FlexiBalanceView({
    required this.onWithDrawalSubitted,
    super.key,
  });

  final VoidCallback? onWithDrawalSubitted;

  final UserService _usrService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
      backgroundColor: const Color(0xff151D22),
      appBar: FAppBar(
        title: null,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        action: Container(
          height: SizeConfig.avatarRadius * 2,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.transparent,
          ),
          child: TextButton(
            child: Text(
              locale.obNeedHelp,
              style: TextStyles.sourceSans.body3,
            ),
            onPressed: () {
              Haptic.vibrate();
              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addPage,
                page: FreshDeskHelpPageConfig,
              );
            },
          ),
        ),
      ),
      body: BaseView<LendboxWithdrawalViewModel>(
        onModelReady: (model) => model.init(),
        builder: (ctx, model, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      Assets.felloFlo,
                      height: SizeConfig.padding26,
                    ),
                    Text(
                      locale.retiiredFlexi,
                      style: TextStyles.rajdhaniSB.title5
                          .colour(UiConstants.kTextColor),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Text(
                  BaseUtil.formatIndianRupees(
                    _usrService.userPortfolio.flo.flexi.balance.toDouble(),
                  ),
                  style: TextStyles.rajdhaniB.title1
                      .colour(UiConstants.kTextColor),
                ),
                SizedBox(
                  height: SizeConfig.padding30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.withdrable,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        model.withdrawableQuantity == null
                            ? const SpinKitThreeBounce(
                                color: UiConstants.teal2,
                                size: 14,
                              )
                            : model.withdrawableResponseMessage.isNotEmpty
                                ? Text(
                                    model.withdrawableResponseMessage,
                                    style: TextStyles.sourceSans.body2
                                        .colour(UiConstants.textGray70),
                                  )
                                : Text(
                                    BaseUtil.formatIndianRupees(
                                      model.withdrawableQuantity?.amount ??
                                          0.toDouble(),
                                    ),
                                    style: TextStyles.sourceSans.body2
                                        .colour(UiConstants.textGray70),
                                  ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: SizeConfig.padding90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.annualInterest,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        Text(
                          '8%',
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.textGray70),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
                  child: const Divider(
                    color: UiConstants.kDividerColorLight,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding24),
                  child: SecondaryButton(
                    onPressed: () {
                      Haptic.vibrate();
                      BaseUtil().openSellModalSheet(
                        investmentType: InvestmentType.LENDBOXP2P,
                        onWithDrawalSubitted: onWithDrawalSubitted,
                      );
                    },
                    label: locale.withdraw,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
