import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        child: const ButTicketsComponent(),
      ),
    );
  }
}

class ButTicketsComponent extends StatefulWidget {
  const ButTicketsComponent({
    Key? key,
    // required this.model,
  }) : super(key: key);

  @override
  State<ButTicketsComponent> createState() => _ButTicketsComponentState();
}

class _ButTicketsComponentState extends State<ButTicketsComponent> {
  TextEditingController? ticketCountController;
  // final TambolaHomeViewModel model;
  int oneTambolaTicketCost = AppConfig.getValue(AppConfigKey.tambola_cost);
  int ticketCount = 5;
  int? ticketCost;

  void addTicket() {
    HapticFeedback.vibrate();
    setState(() {
      if (ticketCount >= 30) {
        ticketCount = 30;
      } else {
        ticketCount++;
      }
      ticketCost = ticketCount * oneTambolaTicketCost;
      ticketCountController!.text = ticketCount.toString();
    });
  }

  void reduceTicket() {
    HapticFeedback.vibrate();
    setState(() {
      if (ticketCount == 1) {
        ticketCount = 1;
      } else {
        ticketCount--;
      }
      ticketCost = ticketCount * oneTambolaTicketCost;
      ticketCountController!.text = ticketCount.toString();
    });
  }

  void updateTicketCount(String count) {
    int ticketCount = int.tryParse(count) ?? 5;
    if (ticketCount < 0) {
      ticketCount = 5;
    } else if (ticketCount > 30) {
      ticketCount = 30;
    }
    setState(() {
      ticketCost = ticketCount * oneTambolaTicketCost;
      ticketCountController!.text = ticketCount.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    ticketCountController = TextEditingController(text: '5');
    ticketCost = 5 * oneTambolaTicketCost;
  }

  @override
  void dispose() {
    ticketCountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding32,
      ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness40),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: reduceTicket,
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: SizeConfig.padding16,
                      ),
                    ),

                    SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SvgPicture.asset(
                          //   'assets/svg/ticket_icon.svg',
                          //   height: 12,
                          // ),
                          // SizedBox(width: SizeConfig.padding4),
                          SizedBox(
                            width: SizeConfig.screenWidth! * 0.05,
                            child: Center(
                              child: TextField(
                                style: TextStyles.sourceSans.body2
                                    .colour(Colors.white)
                                    .setHeight(1),
                                textAlign: TextAlign.center,
                                controller: ticketCountController,
                                enableInteractiveSelection: false,
                                enabled: false,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: updateTicketCount,
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
                    IconButton(
                      onPressed: addTicket,
                      icon: Icon(
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
                "=   ₹ $ticketCost",
                style: TextStyles.sourceSansB.body2.colour(Colors.white),
              ),
              const Spacer(),
              AppPositiveBtn(
                width: SizeConfig.screenWidth! * 0.22,

                height: SizeConfig.screenWidth! * 0.14,
                // decoration: const BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   color: UiConstants.primaryColor,
                // ),
                onPressed: () {
                  BaseUtil.openDepositOptionsModalSheet(
                    amount: ticketCost,
                    timer: 0,
                  );
                },
                btnText: "SAVE",
                // child: MaterialButton(
                //   // padding: EdgeInsets.zero,

                //   child: Center(
                //     child: Text(
                //       'SAVE',
                //       style: TextStyles.rajdhaniB.body1,
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuyTicketPriceWidget extends StatelessWidget {
  const BuyTicketPriceWidget({required this.amount, Key? key})
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
