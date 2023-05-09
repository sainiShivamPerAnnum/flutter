import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButTicketsComponent extends StatelessWidget {
  ButTicketsComponent({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding32),
      decoration: BoxDecoration(
        color: UiConstants.kBuyTicketBg,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BuyTicketPriceWidget(
            amount: AppConfig.getValue(AppConfigKey.tambola_cost).toString(),
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            'Buy more tickets to increase your chances of winning',
            style: TextStyles.sourceSans.body4
                .colour(UiConstants.kTextFieldTextColor),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Row(
            children: [
              Container(
                width: SizeConfig.screenWidth! * 0.30,
                decoration: BoxDecoration(
                  // color: const Color(0xff000000).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness40),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: model.decreaseTicketCount,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: SizeConfig.padding16,
                      ),

                      // iconSize: SizeConfig.padding16,
                      // color: Colors.white,
                      // onPressed: model.decreaseTicketCount,
                    ),

                    SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          SvgPicture.asset(
                            'assets/svg/ticket_icon.svg',
                            height: 12,
                          ),
                          SizedBox(
                            width: SizeConfig.screenHeight! * 0.03,
                            height: SizeConfig.padding35,
                            child: Center(
                              child: TextField(
                                style: TextStyles.sourceSans.body2.setHeight(2),
                                textAlign: TextAlign.center,
                                controller: model.ticketCountController,
                                enableInteractiveSelection: false,
                                enabled: false,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (text) {
                                  model.updateTicketCount();
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spacer(),
                    GestureDetector(
                      onTap: model.increaseTicketCount,
                      child: Icon(
                        Icons.add,
                        size: SizeConfig.padding16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                "=   ₹ ${model.ticketSavedAmount.toString()}",
                style: TextStyles.sourceSansB.body2.colour(Colors.white),
              ),
              const Spacer(),
              Container(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenHeight! * 0.05,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(colors: [
                  //  Color(0xff08D2AD),
                  //   Color(0xff43544F),
                  // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: UiConstants.kBuyTicketSaveButton,
                ),
                child: MaterialButton(
                  // padding: EdgeInsets.zero,
                  onPressed: () {
                    _analyticsService.track(
                        eventName: AnalyticsEvents.tambolaSaveTapped,
                        properties: AnalyticsProperties
                            .getDefaultPropertiesMap(extraValuesMap: {
                          "Time left for draw Tambola (mins)":
                              AnalyticsProperties.getTimeLeftForTambolaDraw(),
                          "Tambola Tickets Owned":
                              AnalyticsProperties.getTambolaTicketCount(),
                          "Number of Tickets":
                              model.ticketCountController!.text ?? "",
                          "Amount": model.ticketSavedAmount,
                        }));
                    BaseUtil.openDepositOptionsModalSheet(
                        amount: model.ticketSavedAmount,
                        subtitle:
                            'Save ₹500 in any of the asset & get 1 Free Tambola Ticket',
                        timer: 0);
                  },
                  child: Center(
                    child: Text(
                      'SAVE',
                      style: TextStyles.rajdhaniB.body1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuyTicketPriceWidget extends StatelessWidget {
  const BuyTicketPriceWidget({Key? key, required this.amount})
      : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Every',
          style: TextStyles.sourceSans.body2
              .colour(UiConstants.kTextFieldTextColor.withOpacity(0.5)),
        ),
        SizedBox(
          width: SizeConfig.padding4,
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        //   decoration: BoxDecoration(
        //     color: UiConstants.kBlogCardRandomColor2,
        //     borderRadius: const BorderRadius.all(Radius.circular(5)),
        //     border: Border.all(color: Colors.black, width: 1),
        //   ),
        //   child: Text(
        //     '₹',
        //     style: TextStyles.sourceSansB.body4.colour(Colors.black),
        //   ),
        // ),
        // SizedBox(
        //   width: SizeConfig.padding4,
        // ),
        Text(
          '₹$amount = ',
          style: TextStyles.sourceSans.body2,
        ),
        SizedBox(
          width: SizeConfig.padding4,
        ),
        SvgPicture.asset('assets/svg/ticket_icon.svg'),
        SizedBox(
          width: SizeConfig.padding4,
        ),
        Text(
          '1 Free Ticket',
          style: TextStyles.sourceSans.body2,
        ),
        SizedBox(
          width: SizeConfig.padding4,
        ),
        Text(
          'for life',
          style: TextStyles.sourceSans.body2
              .colour(UiConstants.kTextFieldTextColor.withOpacity(0.5)),
        ),
      ],
    );
  }
}
