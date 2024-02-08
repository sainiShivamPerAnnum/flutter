import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/cubit/sip_form_cubit.dart';
import 'package:felloapp/feature/sip/mandate_page/view/mandate_view.dart';
import 'package:felloapp/feature/sip/shared/interestCalculator.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
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
      create: (_) => SipFormCubit()..init(prefillAmount, prefillFrequency),
      child: SipFormAmount(
        mandateAvailable: mandateAvailable,
        editId: editId,
        sipAssetType: sipAssetType,
        isEdit: isEdit,
      ),
    );
  }
}

class SipFormAmount extends StatefulWidget {
  const SipFormAmount(
      {required this.mandateAvailable,
      required this.sipAssetType,
      super.key,
      this.isEdit,
      this.editId});
  final bool mandateAvailable;
  final bool? isEdit;
  final String? editId;
  final SIPAssetTypes sipAssetType;

  @override
  State<SipFormAmount> createState() => _SipFormAmountState();
}

class _SipFormAmountState extends State<SipFormAmount> {
  num ticketMultiplier = AppConfig.getValue(AppConfigKey.tambola_cost);
  List<String> tabOptions =
      SipDataHolder.instance.data.amountSelectionScreen.options;
  final locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    num percentage = SipDataHolder.instance.data.selectAssetScreen.options
        .where((element) => element.type == widget.sipAssetType)
        .first
        .interest;
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
        body: BlocConsumer<SipFormCubit, SipFormState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            final formmodel = context.read<SipFormCubit>();
            return switch (state) {
              SipFormCubitState() => DefaultTabController(
                  length: tabOptions.length,
                  initialIndex: state.currentTab,
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
                                return formmodel.onTabChange(i);
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding28,
                          ),
                          Text(
                            locale.selectSipAmount,
                            style: TextStyles.rajdhaniSB.body1
                                .copyWith(height: 1.2),
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AmountInputWidget(
                                mandateAvailable: widget.mandateAvailable,
                                lowerLimit: state.lowerLimit.toDouble(),
                                upperLimit: state.upperLimit.toDouble(),
                                division: state.division.toInt(),
                                amount: state.formAmount,
                                ticketMultiplier: ticketMultiplier,
                                onChange: formmodel.setAmount,
                              ),
                              if (state.formAmount <
                                  state.lowerLimit.toDouble())
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.padding16,
                                    right: SizeConfig.padding16,
                                  ),
                                  child: Text(
                                    locale.minSipAmount(
                                        state.lowerLimit.toDouble()),
                                    style: TextStyles.sourceSans.body4
                                        .colour(UiConstants.errorText),
                                  ),
                                ),
                              if (state.formAmount >
                                  state.upperLimit.toDouble())
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.padding16,
                                    right: SizeConfig.padding16,
                                  ),
                                  child: Text(
                                    locale.maxSipAmount(
                                        state.upperLimit.toDouble()),
                                    style: TextStyles.sourceSans.body4
                                        .colour(UiConstants.errorText),
                                  ),
                                ),
                              SizedBox(
                                height: SizeConfig.padding32,
                              ),
                              AmountSlider(
                                lowerLimit: state.lowerLimit.toDouble(),
                                upperLimit: state.upperLimit.toDouble(),
                                division: state.division.toInt(),
                                amount: state.formAmount.toDouble(),
                                onChanged: formmodel.setAmount,
                                bestOption: state.bestOption.order,
                              ),
                            ],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      locale.expectedReturns5y,
                                      style: TextStyles.sourceSans.body2,
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${BaseUtil.formatIndianRupees(SipCalculation.getPrincipal(
                                            formAmount: state.formAmount,
                                            currentTab: state.currentTab,
                                          ).toDouble())}+',
                                        ),
                                        TextSpan(
                                          text: SipCalculation.getReturn(
                                              formAmount: state.formAmount,
                                              currentasset: widget.sipAssetType,
                                              currentTab: state.currentTab,
                                              interestOnly: true),
                                          style: TextStyles.sourceSansSB.body1
                                              .colour(
                                                  UiConstants.kTabBorderColor),
                                        ),
                                      ]),
                                      style: TextStyles.sourceSans.body3
                                          .colour(UiConstants.kTextColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.padding3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                    bottomNavigationBar: _Footer(
                      isValidAmount: state.lowerLimit <= state.formAmount &&
                          state.formAmount <= state.upperLimit,
                      isEdit: widget.isEdit ?? false,
                      mandateAvailable: widget.mandateAvailable,
                      amount: state.formAmount,
                      sipAssetType: widget.sipAssetType,
                      frequency: SipDataHolder.instance.data
                          .amountSelectionScreen.options[state.currentTab],
                      id: (widget.isEdit ?? false) ? widget.editId : null,
                    ),
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
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
    required this.sipAssetType,
  });
  final bool mandateAvailable;
  final num amount;
  final String frequency;
  final String? id;
  final bool isEdit;
  final bool isValidAmount;
  final SIPAssetTypes sipAssetType;

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
          BlocConsumer<SipFormCubit, SipFormState>(
            listener: (context, state) {},
            builder: (context, state) {
              return switch (state) {
                SipFormCubitState() => Opacity(
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
                            await formmodel
                                .editSipTrigger(
                                    widget.amount, widget.frequency, widget.id!)
                                .then((value) {
                              context.read<SipCubit>().getData();
                            });
                          } else {
                            if (widget.mandateAvailable) {
                              await formmodel.createSubscription(
                                  amount: widget.amount,
                                  freq: widget.frequency,
                                  assetType: widget.sipAssetType);
                            } else {
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                page: SipMandatePageConfig,
                                widget: SipMandateView(
                                    amount: widget.amount,
                                    frequency: widget.frequency,
                                    assetType: widget.sipAssetType),
                                state: PageState.addWidget,
                              );
                            }
                          }
                        }
                      },
                      child: state.isLoading
                          ? const CupertinoActivityIndicator()
                          : null,
                    ),
                  ),
                _ => SizedBox.shrink(),
              };
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
    required this.mandateAvailable,
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
  final bool mandateAvailable;
  final void Function(int value) onChange;

  @override
  State<AmountInputWidget> createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.amount.round().toString());
  }

  @override
  void didUpdateWidget(covariant AmountInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _amountController.value = TextEditingValue(
        text: widget.amount.round().toString(),
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: widget.amount.round().toString().length,
          ),
        ),
      );
    }
  }

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
    int tambolaTickets = widget.amount ~/ widget.ticketMultiplier;
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
                if (!widget.mandateAvailable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+$tambolaTickets Tambola Ticket',
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
