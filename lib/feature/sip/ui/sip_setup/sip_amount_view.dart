import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/sip_model/sip_options.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/cubit/sip_form_cubit.dart';
import 'package:felloapp/feature/sip/shared/interestCalculator.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SipFormAmountView extends StatelessWidget {
  const SipFormAmountView({
    required this.mandateAvailable,
    required this.sipAssetType,
    super.key,
    this.prefillAmount,
    this.prefillFrequency,
    this.isEdit,
    this.editId,
  });
  final bool mandateAvailable;
  final int? prefillAmount;
  final String? prefillFrequency;
  final bool? isEdit;
  final String? editId;
  final SIPAssetTypes sipAssetType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SipFormCubit(),
      child: SipFormAmount(
        mandateAvailable: mandateAvailable,
        prefillAmount: prefillAmount,
        prefillFrequency: prefillFrequency,
        isEdit: isEdit,
        editId: editId,
        sipAssetType: sipAssetType,
      ),
    );
  }
}

class SipFormAmount extends StatefulWidget {
  const SipFormAmount(
      {required this.mandateAvailable,
      required this.sipAssetType,
      super.key,
      this.prefillAmount,
      this.isEdit,
      this.editId,
      this.prefillFrequency});
  final bool mandateAvailable;
  final int? prefillAmount;
  final String? prefillFrequency;
  final bool? isEdit;
  final String? editId;
  final SIPAssetTypes sipAssetType;

  @override
  State<SipFormAmount> createState() => _SipFormAmountState();
}

class _SipFormAmountState extends State<SipFormAmount> {
  late num _upperLimit;
  late num _lowerLimit;
  late num _division;
  int _currentTab = 0;
  late SipOptions bestOption;
  num ticketMultiplier = AppConfig.getValue(AppConfigKey.tambola_cost);
  List<String> tabOptions =
      SipDataHolder.instance.data.amountSelectionScreen.options;
  final locale = locator<S>();

  void onTabChange() {
    final formmodel = context.read<SipFormCubit>();
    List<SipOptions>? options = SipDataHolder.instance.data
        .amountSelectionScreen.data[tabOptions[_currentTab]]?.options;
    SipOptions? maxValueOption = options?.reduce((currentMax, next) =>
        next.value > currentMax.value ? next : currentMax);
    bestOption = options!.firstWhere((option) => option.best);
    int currentAmount = bestOption.value;
    formmodel.setAmount(currentAmount);
    _division = options.length;
    _upperLimit = maxValueOption!.value;
    _lowerLimit = _upperLimit / _division;
  }

  @override
  void initState() {
    super.initState();
    final formmodel = context.read<SipFormCubit>();
    int editSipTab = SipDataHolder.instance.data.amountSelectionScreen.options
        .indexOf(widget.prefillFrequency ?? 'DAILY');
    _currentTab = editSipTab;
    List<SipOptions>? options = SipDataHolder.instance.data
        .amountSelectionScreen.data[tabOptions[_currentTab]]?.options;
    SipOptions? maxValueOption = options?.reduce((currentMax, next) =>
        next.value > currentMax.value ? next : currentMax);
    bestOption = options!.firstWhere((option) => option.best);
    int currentAmount = widget.prefillAmount ?? bestOption.value;
    formmodel.setAmount(currentAmount);
    _division = options.length;
    _upperLimit = maxValueOption!.value;
    _lowerLimit = _upperLimit / _division;
  }

  @override
  Widget build(BuildContext context) {
    num percentage = SipDataHolder.instance.data.selectAssetScreen.options
        .where((element) => element.type == widget.sipAssetType)
        .first
        .interest;
    final formmodel = context.read<SipFormCubit>();
    return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async =>
                await AppState.backButtonDispatcher!.didPopRoute(),
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          ),
          backgroundColor: UiConstants.bg,
          title: Text(locale.siptitle),
          titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
          centerTitle: true,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: DefaultTabController(
          length: tabOptions.length,
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
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding28),
                      child: TabSlider<String>(
                        tabs: tabOptions,
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
                      locale.selectSipAmount,
                      style: TextStyles.rajdhaniSB.body1.copyWith(height: 1.2),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    BlocConsumer<SipFormCubit, SipFormCubitState>(
                      listener: (context, state) {},
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AmountInputWidget(
                            lowerLimit: _lowerLimit.toDouble(),
                            upperLimit: _upperLimit.toDouble(),
                            division: _division.toInt(),
                            amount: state.formAmount,
                            ticketMultiplier: ticketMultiplier,
                            onChange: formmodel.setAmount,
                          ),
                          if (state.formAmount < _lowerLimit.toDouble())
                            Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.padding16,
                                right: SizeConfig.padding16,
                              ),
                              child: Text(
                                locale.minSipAmount(_lowerLimit.toDouble()),
                                style: TextStyles.sourceSans.body4
                                    .colour(UiConstants.errorText),
                              ),
                            ),
                          if (state.formAmount > _upperLimit.toDouble())
                            Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.padding16,
                                right: SizeConfig.padding16,
                              ),
                              child: Text(
                                locale.maxSipAmount(_upperLimit.toDouble()),
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
                            amount: state.formAmount.toDouble(),
                            onChanged: formmodel.setAmount,
                            bestOption: bestOption.order,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(SizeConfig.padding16),
                      decoration: BoxDecoration(
                        color: UiConstants.grey5,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.expectedReturns5y,
                                style: TextStyles.sourceSans.body2,
                              ),
                              BlocConsumer<SipFormCubit, SipFormCubitState>(
                                  builder: (context, state) => Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                            text:
                                                '${BaseUtil.formatIndianRupees(double.parse(state.formAmount.toString()))}+',
                                          ),
                                          TextSpan(
                                            text: SipCalculation.getReturn(
                                              formAmount: state.formAmount,
                                              currentasset: widget.sipAssetType,
                                              currentTab: _currentTab,
                                            ),
                                            style: TextStyles.sourceSansSB.body1
                                                .colour(UiConstants
                                                    .kTabBorderColor),
                                          ),
                                        ]),
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor),
                                      ),
                                  listener: (context, state) {})
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.padding3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.returnSubText,
                                style: TextStyles.sourceSans.body4
                                    .copyWith(color: UiConstants.grey1),
                              ),
                              Text(
                                locale.percentageReturns(percentage),
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
              bottomNavigationBar:
                  BlocConsumer<SipFormCubit, SipFormCubitState>(
                      builder: (context, state) => _Footer(
                            isValidAmount: _lowerLimit <= state.formAmount &&
                                state.formAmount <= _upperLimit,
                            isEdit: widget.isEdit ?? false,
                            mandateAvailable: widget.mandateAvailable,
                            amount: state.formAmount,
                            frequency: SipDataHolder.instance.data
                                .amountSelectionScreen.options[_currentTab],
                            id: (widget.isEdit ?? false) ? widget.editId : null,
                          ),
                      listener: (context, state) {})),
        ));
  }
}

class _Footer extends StatefulWidget {
  const _Footer({
    required this.mandateAvailable,
    required this.amount,
    required this.frequency,
    required this.isEdit,
    required this.id,
    required this.isValidAmount,
  });
  final bool mandateAvailable;
  final num amount;
  final String frequency;
  final String? id;
  final bool isEdit;
  final bool isValidAmount;

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  final locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    final formmodel = context.watch<SipFormCubit>();
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
                  widget.mandateAvailable
                      ? locale.existingMandate
                      : locale.newMandate,
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
          Opacity(
            opacity: widget.isValidAmount ? 1 : 0.5,
            child: SecondaryButton(
              label: widget.isEdit
                  ? locale.updateSip
                  : widget.mandateAvailable
                      ? locale.oneClickAway
                      : locale.twoClickAway,
              onPressed: () async {
                if (widget.isValidAmount) {
                  if (widget.isEdit) {
                    var res = await formmodel.editSipTrigger(
                        widget.amount, widget.frequency, widget.id!);
                    if (!res) {}
                  } else {
                    if (!widget.mandateAvailable) {
                    } else {}
                    // await model.pageController.animateToPage(3,
                    //     duration: const Duration(milliseconds: 100),
                    //     curve: Curves.easeIn);
                  }
                }
              },
              child: formmodel.state.isLoading
                  ? const CupertinoActivityIndicator()
                  : null,
            ),
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
    required this.bestOption,
    this.amount = 10000,
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    super.key,
    this.division = 5,
  });

  final void Function(int) onChanged;
  final double amount;
  final double upperLimit;
  final double lowerLimit;
  final int division;
  final int bestOption;

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
                    final amt = ((upperLimit / division) * (i + 1)).toInt();
                    return GestureDetector(
                      onTap: () => onChanged(amt),
                      child: SipAmountChip(
                        isBest: i == bestOption,
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
            onChanged: (value) => onChanged(value.toInt()),
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

  final int amount;
  final double upperLimit;
  final double lowerLimit;
  final num ticketMultiplier;
  final int division;
  final void Function(int value) onChange;

  @override
  State<AmountInputWidget> createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  TextEditingController? _amountController;

  void _onIncrement() {
    if (widget.amount < widget.upperLimit) {
      final value =
          (widget.amount + (widget.upperLimit / widget.division)).toInt();
      widget.onChange(value);
    }
  }

  void _onDecrement() {
    if (widget.amount > widget.lowerLimit) {
      final value =
          (widget.amount - (widget.upperLimit / widget.division)).toInt();
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    _amountController =
        TextEditingController(text: widget.amount.round().toString());
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
                    IntrinsicWidth(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          widget.onChange(int.parse(value));
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
                        cursorColor: UiConstants
                            .kModalSheetMutedTextBackgroundColor
                            .withOpacity(0.4),
                        style: TextStyles.rajdhaniB.title2.colour(Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+${widget.amount ~/ widget.ticketMultiplier} Tambola Ticket',
                      style: TextStyles.sourceSans.body3.copyWith(
                        color: UiConstants.teal3,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding4,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        Icon(
                          Icons.info_outline,
                          size: SizeConfig.iconSize2,
                          color: UiConstants.teal3,
                        ),
                      ],
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
