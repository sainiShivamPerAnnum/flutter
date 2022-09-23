import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/service/payments/sell_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BankDetailsCard extends StatelessWidget {
  const BankDetailsCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<SellService, SellServiceProperties>(
        properties: [SellServiceProperties.bankDetailsVerified],
        builder: (context, model, property) =>
            model.isBankDetailsAdded && model.activeBankAccountDetails != null
                ? Column(
                    children: [
                      SvgPicture.asset(Assets.magicalSpiritBall),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: UiConstants.kTextColor2),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness8),
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
                          title: Text(model.activeBankAccountDetails.account,
                              style: TextStyles.sourceSansB.body2),
                          subtitle: Text(
                            model.activeBankAccountDetails.name,
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor2),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: UiConstants.kTextColor,
                            ),
                            onPressed: () {
                              AppState.delegate.appState.currentAction =
                                  PageAction(
                                      page: BankDetailsPageConfig,
                                      state: PageState.addPage);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox());
  }
}
