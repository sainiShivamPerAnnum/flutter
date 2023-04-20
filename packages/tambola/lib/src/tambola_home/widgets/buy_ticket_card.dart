import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/utils/styles/styles.dart';

class AnimatedBuyTambolaTicketCard extends StatefulWidget {
  const AnimatedBuyTambolaTicketCard({
    // required this.model,
    Key? key,
  }) : super(key: key);

  // final TambolaHomeViewModel model;

  @override
  State<AnimatedBuyTambolaTicketCard> createState() =>
      AnimatedBuyTambolaTicketCardState();
}

class AnimatedBuyTambolaTicketCardState
    extends State<AnimatedBuyTambolaTicketCard>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationController!.addListener(() {
      print(animationController!.value.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void startAnimation() {
    // Start the animation
    animationController!
        .forward()
        .then((value) => animationController!.reset());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // key: widget.key,
      padding: EdgeInsets.symmetric(vertical: SizeConfig.pageHorizontalMargins),
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (ctx, child) {
          final sineValue = sin(5 * 2 * pi * animationController!.value);
          return Transform.translate(
            offset: Offset(sineValue * 5, 0),
            child: child,
          );
        },
        child: ButTicketsComponent(),
      ),
    );
  }
}

class ButTicketsComponent extends StatefulWidget {
  ButTicketsComponent({
    Key? key,
    // required this.model,
  }) : super(key: key);

  @override
  State<ButTicketsComponent> createState() => _ButTicketsComponentState();
}

class _ButTicketsComponentState extends State<ButTicketsComponent> {
  final TextEditingController ticketCountController = TextEditingController();
  // final TambolaHomeViewModel model;
  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
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
            //TODO: REVERT WHEN PACAKGE IS SETUP

            amount:
                "10", // AppConfig.getValue(AppConfigKey.tambola_cost).toString(),
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
                      onTap: () {}, // model.decreaseTicketCount,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: SizeConfig.padding16,
                      ),
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
                                controller: ticketCountController,
                                enableInteractiveSelection: false,
                                enabled: false,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (text) {
                                  // model.updateTicketCount();
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
                      onTap: () {}, // model.increaseTicketCount,
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
                "=   ₹ model.ticketSavedAmount.toString()}",
                style: TextStyles.sourceSansB.body2.colour(Colors.white),
              ),
              const Spacer(),
              Container(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenHeight! * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: UiConstants.primaryColor,
                ),
                child: MaterialButton(
                  // padding: EdgeInsets.zero,
                  onPressed: () {
                    // _analyticsService.track(
                    //     eventName: AnalyticsEvents.tambolaSaveTapped,
                    //     properties: AnalyticsProperties
                    //         .getDefaultPropertiesMap(extraValuesMap: {
                    //       "Time left for draw Tambola (mins)":
                    //           AnalyticsProperties.getTimeLeftForTambolaDraw(),
                    //       "Tambola Tickets Owned":
                    //           AnalyticsProperties.getTambolaTicketCount(),
                    //       "Number of Tickets":
                    //           model.ticketCountController!.text ?? "",
                    //       "Amount": model.ticketSavedAmount,
                    //     }));
                    //TODO: REVERT WHEN PACAKGE IS SETUP

                    // BaseUtil.openDepositOptionsModalSheet(
                    //     amount: model.ticketSavedAmount,
                    //     subtitle:
                    //         'Save ₹500 in any of the asset & get 1 Free Tambola Ticket',
                    //     timer: 0);
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
