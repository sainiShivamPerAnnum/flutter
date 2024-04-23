import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/sip/shared/sip.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class P2PInvestmentCalculator extends StatefulWidget {
  const P2PInvestmentCalculator({super.key});

  @override
  State<P2PInvestmentCalculator> createState() =>
      _P2PInvestmentCalculatorState();
}

class _P2PInvestmentCalculatorState extends State<P2PInvestmentCalculator> {
  final _amountNotifier = ValueNotifier(100);
  final _durationNotifier = ValueNotifier(2);

  @override
  void dispose() {
    super.dispose();
    _amountNotifier.dispose();
    _durationNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Return Calculator',
              style: TextStyles.rajdhaniSB.title5.colour(
                Colors.white,
              ),
            ),
            Text(
              'Calculate your Returns',
              style: TextStyles.rajdhaniSB.body3.colour(
                UiConstants.textGray70,
              ),
            )
          ],
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Container(
          padding: EdgeInsets.all(SizeConfig.padding16),
          decoration: BoxDecoration(
            color: UiConstants.grey4,
            borderRadius: BorderRadius.circular(
              SizeConfig.roundness12,
            ),
            border: Border.all(
              color: Color(0xffFFF9F900).withOpacity(.10),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, SizeConfig.padding14),
                blurRadius: SizeConfig.padding20,
                spreadRadius: 0,
                color: UiConstants.bg,
              )
            ],
          ),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _amountNotifier,
                builder: (context, value, child) {
                  return CalculatorField(
                    onChangeEnd: (x) => _amountNotifier.value = x,
                    requiresQuickButtons: false,
                    onChange: (x) => _amountNotifier.value = int.parse(x),
                    label: 'Investment Amount -',
                    prefixText: "₹",
                    inputFormatters: [
                      MaxValueInputFormatter(maxValue: 100000),
                      FilteringTextInputFormatter.deny(
                        RegExp(r'^0+'),
                      ),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        var decimalSeparator =
                            NumberFormat().symbols.DECIMAL_SEP;
                        var r =
                            RegExp(r'^\d*(\' + decimalSeparator + r'\d*)?$');
                        return r.hasMatch(newValue.text) ? newValue : oldValue;
                      })
                    ],
                    maxValue: 100000,
                    minValue: 100,
                    value: value,
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              ValueListenableBuilder<int>(
                valueListenable: _durationNotifier,
                builder: (context, value, child) {
                  return CalculatorField(
                    onChangeEnd: (x) => _durationNotifier.value = x,
                    requiresQuickButtons: false,
                    onChange: (x) => _durationNotifier.value = int.parse(x),
                    label: 'Time Period -',
                    suffixText: 'Year',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      MaxValueInputFormatter(maxValue: 10),
                      FilteringTextInputFormatter.deny(
                        RegExp(r'^0+'),
                      ),
                    ],
                    maxValue: 10,
                    minValue: 1,
                    value: value,
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Money in 5 Years-',
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.kTextColor),
                  ),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      _amountNotifier,
                      _durationNotifier,
                    ]),
                    builder: (context, child) {
                      return Text(
                        formatter.format(
                          _amountNotifier.value +
                              BaseUtil.calculateCompoundInterest(
                                amount: _amountNotifier.value, //principle
                                interestRate: 10, // tbd
                                maturityDuration: 12, // yearly
                                terms: _durationNotifier.value, //years
                              ),
                        ),
                        style: TextStyles.sourceSansSB.title5.colour(
                          UiConstants.kTabBorderColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
