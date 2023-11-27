import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BankDetailsCard extends StatelessWidget {
  const BankDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: PropertyChangeConsumer<BankAndPanService,
              BankAndPanServiceProperties>(
          properties: const [BankAndPanServiceProperties.bankDetailsVerified],
          builder: (context, model, property) => model!.isBankDetailsAdded &&
                  model.activeBankAccountDetails != null
              ? Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.pageHorizontalMargins * 2,
                      bottom: SizeConfig.pageHorizontalMargins / 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: UiConstants.kTextColor2),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: UiConstants.primaryColor, width: 0.5),
                      ),
                      padding: EdgeInsets.all(SizeConfig.padding8),
                      child: SvgPicture.asset(
                        Assets.bank,
                        color: UiConstants.primaryColor,
                        width: SizeConfig.padding24,
                        height: SizeConfig.padding24,
                      ),
                    ),
                    title: Text(model.activeBankAccountDetails?.account ?? "",
                        style: TextStyles.sourceSansB.body2),
                    subtitle: Text(
                      model.activeBankAccountDetails?.name ?? "",
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor2),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: UiConstants.kTextColor,
                      ),
                      onPressed: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                            page: BankDetailsPageConfig,
                            state: PageState.addPage);
                      },
                    ),
                  ),
                )
              : const SizedBox()),
    );
  }
}
