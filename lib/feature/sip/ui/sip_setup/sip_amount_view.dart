import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SipAmountView extends StatefulWidget {
  const SipAmountView({super.key, required this.mandateAvailable});
  final bool mandateAvailable;

  @override
  State<SipAmountView> createState() => _SipAmountViewState();
}

class _SipAmountViewState extends State<SipAmountView> {
  ValueNotifier<double>? _amount;
  late num _upperLimit;
  late num _lowerLimit;
  late num _division;
  int _currentTab = 0;
  num ticketMultiplier = AppConfig.getValue(AppConfigKey.tambola_cost);
  int calculateMaturityValue(double P, double i, int n) {
    double compoundInterest = ((pow(1 + i, n) - 1) / i) * (1 + i);
    double M = P * compoundInterest;
    return M.round();
  }

  String getReturn() {
    final sipmodel = context.watch<AutosaveCubit>();
    ValueNotifier<double> principalAmount = _amount!;
    int numberOfPeriods = sipmodel
            .sipScreenData
            ?.amountSelectionScreen
            ?.data?[sipmodel
                .sipScreenData?.amountSelectionScreen?.options?[_currentTab]]
            ?.numberOfPeriodsPerYear ??
        1;

    ///TODO(@Hirdesh2101)
    double interest = 8;
    double interestRate = (interest * .001) / numberOfPeriods;
    int numberOfYear = 5;

    int numberOfInvestments = numberOfYear * numberOfPeriods;
    final maturityValue = calculateMaturityValue(
        principalAmount.value, interestRate, numberOfInvestments);
    final totalInterest = maturityValue - _amount!.value;
    return BaseUtil.formatRupees(double.parse(totalInterest.toString()));
  }

  onTabChange() {
    final sipmodel = context.read<AutosaveCubit>();
    var options = sipmodel
        .sipScreenData
        ?.amountSelectionScreen
        ?.data?[sipmodel
            .sipScreenData?.amountSelectionScreen?.options?[_currentTab]]
        ?.options;
    var maxValueOption = options?.reduce((currentMax, next) =>
        next.value! > currentMax.value! ? next : currentMax);
    var bestOption = options
        ?.firstWhere((option) => option.best != null && option.best == true);
    double currentAmount = bestOption!.value!.toDouble();
    _amount = ValueNotifier<double>(currentAmount);
    _division = options?.length ?? 4;
    _upperLimit = maxValueOption!.value as num;
    _lowerLimit = _upperLimit / _division;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sipmodel = context.read<AutosaveCubit>();
    var editSipTab = sipmodel.sipScreenData?.amountSelectionScreen?.options
        ?.indexOf(sipmodel.state.currentSipFrequency ?? 'DAILY');
    _currentTab = editSipTab ?? 0;
    var options = sipmodel
        .sipScreenData
        ?.amountSelectionScreen
        ?.data?[sipmodel
            .sipScreenData?.amountSelectionScreen?.options?[_currentTab]]
        ?.options;
    var maxValueOption = options?.reduce((currentMax, next) =>
        next.value! > currentMax.value! ? next : currentMax);
    var bestOption = options
        ?.firstWhere((option) => option.best != null && option.best == true);
    double currentAmount =
        (sipmodel.state.editSipAmount ?? bestOption!.value!).toDouble();
    _amount = ValueNotifier<double>(currentAmount);
    _division = options?.length ?? 4;
    _upperLimit = maxValueOption!.value as num;
    _lowerLimit = _upperLimit / _division;
  }

  @override
  void dispose() {
    super.dispose();
    _amount!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sipmodel = context.read<AutosaveCubit>();
    var options = sipmodel.sipScreenData?.amountSelectionScreen?.options ?? [];
    return DefaultTabController(
      length: options.length,
      initialIndex: _currentTab,
      child: BaseScaffold(
        showBackgroundGrid: false,
        backgroundColor: UiConstants.bg,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding34,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
                child: TabSlider<String>(
                  tabs: options,
                  labelBuilder: (label) => label,
                  onTap: (_, i) {
                    setState(() {
                      _currentTab = i;
                      onTabChange();
                    });
                  },
                ),
              ),
              SizedBox(
                height: SizeConfig.padding28,
              ),
              Text(
                'Select SIP amount',
                style: TextStyles.rajdhaniSB.body1.copyWith(height: 1.2),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              ValueListenableBuilder(
                valueListenable: _amount!,
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountInputWidget(
                      lowerLimit: _lowerLimit.toDouble(),
                      upperLimit: _upperLimit.toDouble(),
                      division: _division.toInt(),
                      amount: _amount!,
                      ticketMultiplier: ticketMultiplier,
                      onChange: (v) => _amount!.value = v,
                    ),
                    if (_amount!.value < _lowerLimit.toDouble())
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.padding16,
                          right: SizeConfig.padding16,
                        ),
                        child: Text(
                          'Minimum amount - ₹${_lowerLimit.toDouble()}',
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.errorText),
                        ),
                      ),
                    if (_amount!.value > _upperLimit.toDouble())
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.padding16,
                          right: SizeConfig.padding16,
                        ),
                        child: Text(
                          'Maximum amount - ₹${_upperLimit.toDouble()}',
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.errorText),
                        ),
                      ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    AmountSlider(
                      lowerLimit: _lowerLimit.toDouble(),
                      upperLimit: _upperLimit.toDouble(),
                      division: _division.toInt(),
                      amount: _amount!.value,
                      onChanged: (v) => _amount!.value = v,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: UiConstants.grey5,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expected Returns in 5Y',
                          style: TextStyles.sourceSans.body2,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _amount!,
                          builder: (context, value, child) => Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text:
                                    '${BaseUtil.formatIndianRupees(double.parse(_amount!.value.toString()))}+',
                              ),
                              TextSpan(
                                text: getReturn(),
                                style: TextStyles.sourceSansSB.body1
                                    .colour(UiConstants.kTabBorderColor),
                              ),
                            ]),
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'with Fello SIP',
                          style: TextStyles.sourceSans.body4
                              .copyWith(color: UiConstants.grey1),
                        ),
                        Text(
                          'with 12% returns',
                          style: TextStyles.sourceSans.body4
                              .copyWith(color: UiConstants.grey1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
            ],
          ),
        ),
        bottomNavigationBar: _Footer(
          mandateAvailable: widget.mandateAvailable,
          amount: _amount!.value,
          frequency: sipmodel
              .sipScreenData!.amountSelectionScreen!.options![_currentTab],
          id: (sipmodel.state.isEdit ?? false)
              ? sipmodel
                  .state.activeSubscription!.subs![sipmodel.state.editIndex!].id
              : null,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer(
      {required this.mandateAvailable,
      required this.amount,
      required this.frequency,
      required this.id});
  final bool mandateAvailable;
  final num amount;
  final String frequency;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.roundness12),
        ),
        color: UiConstants.grey5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AppImage(
                Assets.bulb,
                height: 45,
                width: 45,
              ),
              SizedBox(
                width: SizeConfig.padding18,
              ),
              Expanded(
                child: Text(
                  mandateAvailable
                      ? 'Your SIP amount will be deducted fro your existing mandate . No new mandate will be created for this SIP'
                      : 'You will receive a mandate for ₹5000 on the selected UPI App. But don’t worry, We will not deduct anymore than ₹1100/week.',
                  style: TextStyles.sourceSans.body3.copyWith(
                    color: UiConstants.textGray50,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding22,
          ),
          SecondaryButton(
            label: '2 CLICKS AWAY',
            onPressed: () {
              var model = context.read<AutosaveCubit>();
              if (model.state.isEdit!) {
                model.editSipTrigger(amount, frequency, id!);
              }
            },
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
        ],
      ),
    );
  }
}

class SipAmountChip extends StatelessWidget {
  final bool isBest;
  final bool isSelected;
  final String label;

  const SipAmountChip({
    required this.label,
    super.key,
    this.isBest = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    const nippleHeight = 14.0;
    final locale = locator<S>();
    final borderColor =
        isSelected ? UiConstants.yellow3 : UiConstants.kSnackBarBgColor;
    final textColor = isSelected ? UiConstants.yellow3 : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isBest)
          Container(
            decoration: BoxDecoration(
              color: UiConstants.yellow3,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.roundness2),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
            ),
            child: Text(
              locale.best,
              style: TextStyles.sourceSansB.copyWith(
                fontSize: 10,
                height: 1.4,
                color: UiConstants.grey3,
              ),
            ),
          ),
        SizedBox(
          width: SizeConfig.padding60,
          height: SizeConfig.padding44,
          child: CustomPaint(
            painter: BorderPainter(
              nippleHeight: nippleHeight,
              borderColor: borderColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: nippleHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10,
                  vertical: SizeConfig.padding8,
                ),
                child: FittedBox(
                  child: Text(
                    label,
                    style: TextStyles.sourceSans.body3.colour(
                      textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BorderPainter extends CustomPainter {
  const BorderPainter({
    this.cornerRadius = 6.0,
    this.nippleHeight = 5.0,
    this.nippleBaseWidth = 20.0,
    this.nippleRadius = 2.5,
    this.nippleEdgeRadius = 2,
    this.borderColor = UiConstants.yellow3,
  });

  final double cornerRadius;
  final double nippleHeight;
  final double nippleBaseWidth;
  final double nippleRadius;
  final double nippleEdgeRadius;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(cornerRadius, 0);

    path.lineTo(size.width - cornerRadius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    path.lineTo(size.width, size.height - nippleHeight - cornerRadius);

    path.quadraticBezierTo(
      size.width,
      size.height - nippleHeight,
      size.width - cornerRadius,
      size.height - nippleHeight,
    );

    final halfOfBaseWidthWithoutNippleBase = (size.width - nippleBaseWidth) / 2;

    path.lineTo(
      size.width - halfOfBaseWidthWithoutNippleBase + (2 * nippleEdgeRadius),
      size.height - nippleHeight,
    );

    final edgeSpacing =
        (nippleEdgeRadius * nippleBaseWidth * .5) / nippleHeight;

    final rightPoint =
        halfOfBaseWidthWithoutNippleBase + nippleBaseWidth - edgeSpacing;

    final leftPoint = halfOfBaseWidthWithoutNippleBase + edgeSpacing;

    path.quadraticBezierTo(
      size.width - halfOfBaseWidthWithoutNippleBase,
      size.height - nippleHeight,
      rightPoint,
      size.height - nippleHeight + nippleRadius,
    );

    final y = size.height - nippleRadius;
    final spacing = (nippleRadius * nippleBaseWidth) / nippleHeight;
    final addition = (nippleBaseWidth - spacing) / 2;
    final x2 = halfOfBaseWidthWithoutNippleBase + nippleBaseWidth - addition;
    final x1 = halfOfBaseWidthWithoutNippleBase + addition;

    path.lineTo(x2, y);

    path.quadraticBezierTo(size.width / 2, size.height, x1, y);

    path.lineTo(leftPoint, size.height - nippleHeight + nippleEdgeRadius);

    path.quadraticBezierTo(
      halfOfBaseWidthWithoutNippleBase,
      size.height - nippleHeight,
      halfOfBaseWidthWithoutNippleBase - 2 * nippleEdgeRadius,
      size.height - nippleHeight,
    );

    path.lineTo(cornerRadius, size.height - nippleHeight);

    path.quadraticBezierTo(
      0,
      size.height - nippleHeight,
      0,
      size.height - nippleHeight - cornerRadius,
    );

    path.lineTo(0, cornerRadius);

    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) =>
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.nippleBaseWidth != nippleBaseWidth ||
      oldDelegate.nippleEdgeRadius != nippleEdgeRadius ||
      oldDelegate.nippleHeight != nippleHeight ||
      oldDelegate.nippleRadius != nippleRadius;
}

class AmountSlider extends StatelessWidget {
  const AmountSlider({
    required this.onChanged,
    this.amount = 10000,
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    super.key,
    this.division = 5,
  });

  final void Function(double) onChanged;
  final double amount;
  final double upperLimit;
  final double lowerLimit;
  final int division;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < division; i++)
                Builder(
                  builder: (context) {
                    final amt = (upperLimit / division) * (i + 1).toInt();
                    return GestureDetector(
                      onTap: () => onChanged(amt),
                      child: SipAmountChip(
                        isBest: i == division - 1, // Change it.
                        isSelected: amount == amt,
                        label: '₹${amt.toInt()}',
                      ),
                    );
                  },
                ),
            ],
          ),
          Slider(
            max: upperLimit,
            min: lowerLimit,
            divisions: division - 1,
            value: amount < lowerLimit
                ? lowerLimit
                : amount > upperLimit
                    ? upperLimit
                    : amount,
            onChanged: onChanged,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class AmountInputWidget extends StatefulWidget {
  const AmountInputWidget({
    required this.amount,
    required this.onChange,
    required this.ticketMultiplier,
    super.key,
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    this.division = 5,
  });

  final ValueNotifier<double> amount;
  final double upperLimit;
  final double lowerLimit;
  final num ticketMultiplier;
  final int division;
  final void Function(double value) onChange;

  @override
  State<AmountInputWidget> createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  TextEditingController? _amountController;

  void _onIncrement() {
    if (widget.amount.value < widget.upperLimit) {
      final value = widget.amount.value + (widget.upperLimit / widget.division);
      widget.onChange(value);
    }
  }

  void _onDecrement() {
    if (widget.amount.value > widget.lowerLimit) {
      final value = widget.amount.value - (widget.upperLimit / widget.division);
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    _amountController =
        TextEditingController(text: widget.amount.value.round().toString());
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
      ),
      padding: EdgeInsets.only(
        left: SizeConfig.padding16,
        right: SizeConfig.padding16,
        top: SizeConfig.padding20,
        bottom: SizeConfig.padding12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            actionType: _ActionType.decrement,
            onPressed: _onDecrement,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹ ',
                      style: TextStyles.rajdhaniB.title2,
                    ),
                    Expanded(
                      // width: (SizeConfig.padding20) *
                      //         _amountController!.text
                      //             .replaceAll('.', "")
                      //             .length +
                      //     (_amountController!.text.contains('.')
                      //         ? SizeConfig.padding6
                      //         : 0),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          widget.onChange(double.parse(value));
                        },
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            var decimalSeparator =
                                NumberFormat().symbols.DECIMAL_SEP;
                            var r = RegExp(
                                r'^\d*(\' + decimalSeparator + r'\d*)?$');
                            return r.hasMatch(newValue.text)
                                ? newValue
                                : oldValue;
                          })
                        ],
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyles.rajdhaniB.title2.colour(Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+${widget.amount.value ~/ widget.ticketMultiplier} Tambola Ticket',
                      style: TextStyles.sourceSans.body3.copyWith(
                        color: UiConstants.teal3,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding4,
                    ),
                  ],
                )
              ],
            ),
          ),
          _ActionButton(
            actionType: _ActionType.increment,
            onPressed: _onIncrement,
          )
        ],
      ),
    );
  }
}

enum _ActionType {
  increment,
  decrement;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    this.actionType = _ActionType.increment,
  });

  final _ActionType actionType;
  final VoidCallback onPressed;

  IconData _getIcon() {
    return switch (actionType) {
      _ActionType.increment => Icons.add,
      _ActionType.decrement => Icons.remove
    };
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: SizeConfig.padding24,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: Icon(
          _getIcon(),
        ),
      ),
    );
  }
}
