import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/feature/sip/shared/sip.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/analytics_events_constants.dart';
import '../../../../../core/service/analytics/analytics_service.dart';

class P2PInvestmentCalculator extends StatefulWidget {
  const P2PInvestmentCalculator({super.key});

  @override
  State<P2PInvestmentCalculator> createState() =>
      _P2PInvestmentCalculatorState();
}

class _P2PInvestmentCalculatorState extends State<P2PInvestmentCalculator> {
  final _amountNotifier = ValueNotifier(100);
  final _durationNotifier = ValueNotifier(2);
  final _assetSelected = ValueNotifier(0);
  final assets = AppConfigV2.instance.lbV2.values.toList();

  @override
  void initState() {
    super.initState();
    _amountNotifier.value = assets[0].minAmount.toInt();
  }

  @override
  void dispose() {
    super.dispose();
    _amountNotifier.dispose();
    _durationNotifier.dispose();
    _assetSelected.dispose();
  }

  void trackReturnCalculatorUsed(String assetName) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.returnCalculatorUsed,
      properties: {
        "range": assetName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.p2pReturnsCalculatorTitle,
              style: TextStyles.rajdhaniSB.title5.colour(
                Colors.white,
              ),
            ),
            Text(
              locale.p2pReturnsCalculatorSubtitle,
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
              color: const Color(0xfffff9f900).withOpacity(.10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: Listenable.merge([_amountNotifier, _assetSelected]),
                builder: (context, child) {
                  return CalculatorField(
                    onChangeEnd: (x) => _amountNotifier.value = x,
                    requiresQuickButtons: false,
                    onChange: (x) => _amountNotifier.value = int.parse(x),
                    label: locale.p2pCalculatorInvestmentAmount,
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
                    minValue: assets[_assetSelected.value].minAmount.toDouble(),
                    value: _amountNotifier.value,
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
                    label: locale.p2pCalculatorInvestmentDuration,
                    suffixText: locale.p2pCalculatorInvestmentDurationUnit,
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
              Text(
                locale.assetSelectionCalculator,
                style: TextStyles.sourceSansSB.body2
                    .colour(UiConstants.kTextFieldTextColor),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              ValueListenableBuilder<int>(
                valueListenable: _assetSelected,
                builder: (context, value, child) {
                  return _OptionsGrid(
                    runItemCount: 3,
                    itemCount: assets.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        _amountNotifier.value = assets[index].minAmount.toInt();
                        _assetSelected.value = index;
                        trackReturnCalculatorUsed(assets[index].assetName);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding8,
                          horizontal: SizeConfig.padding12,
                        ),
                        decoration: BoxDecoration(
                          color: UiConstants.bg,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              SizeConfig.padding10,
                            ),
                          ),
                          border: _assetSelected.value == index
                              ? Border.all(
                                  color: UiConstants.teal3,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            assets[index].assetName,
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSansSB.body2.colour(
                              _assetSelected.value == index
                                  ? UiConstants.teal3
                                  : UiConstants.kTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              ListenableBuilder(
                listenable: Listenable.merge([
                  _amountNotifier,
                  _durationNotifier,
                  _assetSelected,
                ]),
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.p2pCalculator5YearsReturns,
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor),
                      ),
                      Text(
                        BaseUtil.formatIndianRupees(
                          _amountNotifier.value +
                              BaseUtil.calculateCompoundInterest(
                                amount: _amountNotifier.value,
                                interestRate:
                                    assets[_assetSelected.value].interest,
                                maturityDuration: assets[_assetSelected.value]
                                    .maturityDuration,
                                terms: (_durationNotifier.value * 12) ~/
                                    assets[_assetSelected.value]
                                        .maturityDuration,
                              ),
                        ),
                        style: TextStyles.sourceSansSB.title5.colour(
                          UiConstants.kTabBorderColor,
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
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  const _OptionsGrid({
    required this.itemBuilder,
    required this.itemCount,
    this.runItemCount = 3,
  });

  final int runItemCount;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final maxWidth = constraints.biggest.width;
        final containerWidth =
            (maxWidth - ((runItemCount - 1) * spacing)) / runItemCount;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < itemCount; i++)
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: containerWidth,
                ),
                child: itemBuilder(context, i),
              )
          ],
        );
      },
    );
  }
}
