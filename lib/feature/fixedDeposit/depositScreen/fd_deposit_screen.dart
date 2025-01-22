import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/feature/fixedDeposit/depositScreen/bloc/fixed_deposit_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/consultant_card.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FDDepositView extends StatelessWidget {
  final AllFdsData fdData;
  const FDDepositView({
    required this.fdData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FDCalculatorBloc(locator()),
      child: _FDDepositView(fdData: fdData),
    );
  }
}

class _FDDepositView extends StatefulWidget {
  final AllFdsData fdData;

  const _FDDepositView({
    required this.fdData,
  });

  @override
  State<_FDDepositView> createState() => __FDDepositViewState();
}

class __FDDepositViewState extends State<_FDDepositView> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedTenure = 0;
  String? _selectedLabel;
  String _selectedFrequency = '';

  void _onInputChange() {
    context.read<FDCalculatorBloc>().add(
          UpdateFDVariables(
            investmentAmount:
                double.tryParse(_amountController.text.replaceAll(',', '')) ??
                    0,
            investmentPeriod: _getSelectedTenureMonths(),
            isSeniorCitizen: false,
            payoutFrequency: _selectedFrequency,
            isFemale: false,
            issuerId: widget.fdData.id,
          ),
        );
  }

  int _getSelectedTenureMonths() {
    final selectedTenureOption =
        widget.fdData.detailsPage.cta.lockInTenure.options[_selectedTenure];

    if (selectedTenureOption == '0-2 yrs') {
      return 24;
    } else if (selectedTenureOption == '2-3 yrs') {
      return 36;
    } else if (selectedTenureOption == '3-5 yrs') {
      return 60;
    }
    return 0;
  }

  @override
  void initState() {
    _amountController.text =
        widget.fdData.detailsPage.cta.displayAmounts[0].toString();
    _selectedLabel = widget.fdData.detailsPage.cta.lockInTenure.selected;
    _selectedFrequency =
        widget.fdData.detailsPage.cta.frequencyValues.keys.first;
    super.initState();
    _amountController.addListener(_onInputChange);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      // backgroundColor: UiConstants.bg,
      appBar: _CustomAppBar(
        fdData: widget.fdData,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.padding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.padding18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: UiConstants.greyVarient,
                borderRadius: BorderRadius.circular(SizeConfig.padding10),
                border: Border.all(color: UiConstants.grey6, width: 0.2),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 14,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(.06),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Investment Amount",
                    style: TextStyles.sourceSansM.body4,
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  TextField(
                    controller: _amountController,
                    style: const TextStyle(
                      color: UiConstants.kTextColor,
                    ),
                    inputFormatters: [
                      CurrencyInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(
                          SizeConfig.padding12,
                        ),
                        child: Text(
                          '₹',
                          style: TextStyles.sourceSansM.body3,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: UiConstants.grey6,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: UiConstants.grey6,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: UiConstants.grey6,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  Wrap(
                    spacing: 8.0,
                    children: widget.fdData.detailsPage.cta.displayAmounts
                        .asMap()
                        .entries
                        .map((entry) {
                      final amount = entry.value;
                      return GestureDetector(
                        onTap: () {
                          _amountController.text = amount.toString();
                        },
                        child: Chip(
                          backgroundColor: UiConstants.kChipColor,
                          label: Text(
                            BaseUtil.formatIndianRupees(amount),
                            style: TextStyles.sourceSansM.body4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.roundness32,
                            ),
                            side: const BorderSide(
                              color: UiConstants.kChipColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Text(
                    "Lock-in Tenure",
                    style: TextStyles.sourceSansM.body4,
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  Wrap(
                    spacing: 8.0,
                    children: widget.fdData.detailsPage.cta.lockInTenure.options
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final tenure = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTenure = index;
                            _onInputChange();
                          });
                        },
                        child: Chip(
                          backgroundColor: _selectedTenure == index
                              ? UiConstants.kTextColor
                              : UiConstants.greyVarient,
                          label: Text(
                            tenure,
                            style: _selectedTenure == index
                                ? TextStyles.sourceSansM.body4.colour(
                                    UiConstants.kTextColor4,
                                  )
                                : TextStyles.sourceSansM.body4.colour(
                                    UiConstants.kTextColor.withOpacity(.6),
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.roundness32,
                            ),
                            side: BorderSide(
                              color: UiConstants.kTextColor.withOpacity(.6),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(color: UiConstants.grey6, width: 0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.roundness16),
                      ),
                      color: UiConstants.greyVarient,
                    ),
                    child: Table(
                      border: TableBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness16),
                        ),
                        top: const BorderSide(
                          color: UiConstants.grey6,
                          width: .6,
                          style: BorderStyle.solid,
                        ),
                        bottom: const BorderSide(
                          color: UiConstants.grey6,
                          width: .6,
                          style: BorderStyle.solid,
                        ),
                        left: const BorderSide(
                          color: UiConstants.grey6,
                          width: .6,
                          style: BorderStyle.solid,
                        ),
                        right: const BorderSide(
                          color: UiConstants.grey6,
                          width: .6,
                          style: BorderStyle.solid,
                        ),
                        horizontalInside: const BorderSide(
                          color: UiConstants.grey6,
                          width: .6,
                          style: BorderStyle.solid,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(65, 65, 65, 69),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                SizeConfig.padding8,
                              ),
                              child: Center(
                                child: Text(
                                  "#",
                                  style: TextStyles.sourceSans.body4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                SizeConfig.padding8,
                              ),
                              child: Center(
                                child: Text(
                                  "Tenure",
                                  style: TextStyles.sourceSans.body4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                SizeConfig.padding8,
                              ),
                              child: Center(
                                child: Text(
                                  "General",
                                  style: TextStyles.sourceSans.body4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                SizeConfig.padding8,
                              ),
                              child: Center(
                                child: Text(
                                  "Sr. Citizen",
                                  style: TextStyles.sourceSans.body4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...widget.fdData.detailsPage.cta
                            .frequencyValues[_selectedFrequency]!.entries
                            .where((entry) {
                          final tenureOptions = widget
                              .fdData.detailsPage.cta.lockInTenure.options;
                          final selectedTenureOption =
                              tenureOptions[_selectedTenure];

                          if (selectedTenureOption == '0-2 yrs') {
                            return entry.value.months <= 24;
                          } else if (selectedTenureOption == '2-3 yrs') {
                            return entry.value.months > 24 &&
                                entry.value.months <= 36;
                          } else if (selectedTenureOption == '3-5 yrs') {
                            return entry.value.months > 36 &&
                                entry.value.months <= 60;
                          }
                          return true;
                        }).map((entry) {
                          final value = entry.value;
                          return TableRow(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_selectedLabel == value.label) {
                                      _selectedLabel = null;
                                    } else {
                                      _selectedLabel = value.label;
                                    }
                                    _onInputChange();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(SizeConfig.padding8),
                                  child: Icon(
                                    _selectedLabel == value.label
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: _selectedLabel == value.label
                                        ? UiConstants.kblue3
                                        : UiConstants.kTextColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.padding8),
                                child: Center(
                                  child: Text(
                                    value.label,
                                    style: TextStyles.sourceSans.body4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.padding8),
                                child: Center(
                                  child: Text(
                                    value.returns,
                                    style: TextStyles.sourceSans.body4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.padding8),
                                child: Center(
                                  child: Text(
                                    value.seniorReturns ?? '',
                                    style: TextStyles.sourceSans.body4,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  Text(
                    "Interest payout",
                    style: TextStyles.sourceSansM.body4,
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  DropdownButton2(
                    value: _selectedFrequency,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFrequency = newValue!;
                        _onInputChange();
                      });
                    },
                    items: widget.fdData.detailsPage.cta.frequencyValues.keys
                        .map((frequencyKey) {
                      return DropdownMenuItem<String>(
                        value: frequencyKey,
                        child: Text(
                          frequencyKey,
                          style: TextStyles.sourceSansM.body3,
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: UiConstants.kChipColor,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                      ),
                      height: SizeConfig.padding48,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding16,
                        vertical: SizeConfig.padding14,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: SizeConfig.padding252,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: UiConstants.kChipColor,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                      ),
                      offset: const Offset(
                        0,
                        0,
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Transform.rotate(
                        angle: math.pi / 2,
                        child: Icon(
                          Icons.chevron_right,
                          color: UiConstants.kTextColor,
                          size: SizeConfig.iconSize0,
                        ),
                      ),
                    ),
                    selectedItemBuilder: (context) {
                      return widget.fdData.detailsPage.cta.frequencyValues.keys
                          .map((frequencyKey) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            frequencyKey,
                            style: TextStyles.sourceSansM.body3,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  const Divider(
                    color: UiConstants.grey6,
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  Text(
                    'Your estimated payout after $_selectedLabel',
                    style: TextStyles.sourceSansM.body4,
                  ),
                  BlocBuilder<FDCalculatorBloc, FixedDepositCalculatorState>(
                    builder: (context, state) {
                      if (state is FdCalculationResult) {
                        return Row(
                          children: [
                            Text(
                              '₹${state.maturityAmount}',
                              style: TextStyles.sourceSansB.body1.colour(
                                UiConstants.kTabBorderColor,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding6,
                            ),
                            Text(
                              'giving ${state.interestRate}% gross returns',
                              style: TextStyles.sourceSans.body4.colour(
                                UiConstants.kTextColor.withOpacity(.6),
                              ),
                            ),
                          ],
                        );
                      } else if (state is FCalculatorError) {
                        return Text(
                          state.message,
                          style: TextStyles.sourceSans.body4.colour(
                            UiConstants.errorText,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Container(
                    width: double.infinity,
                    height: SizeConfig.padding48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          SizeConfig.roundness5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding12,
                        vertical: SizeConfig.padding8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Invest now',
                            style: TextStyles.sourceSansSB.body3.colour(
                              UiConstants.kTextColor4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding20),
            ConsultationWidget(
              margin: EdgeInsets.only(
                top: SizeConfig.padding10,
              ),
              bottomMargin: EdgeInsets.only(
                bottom: SizeConfig.padding10,
              ),
              header: 'Having Doubts?',
              zeroPadding: true,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final value = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatter = NumberFormat('#,##,##0');
    final formattedValue = formatter.format(int.parse(value));

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AllFdsData fdData;
  const _CustomAppBar({required this.fdData});
  @override
  Size get preferredSize => Size.fromHeight(SizeConfig.padding140);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.bg,
            UiConstants.bg2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20).copyWith(
        bottom: SizeConfig.padding16,
        top: MediaQuery.of(context).padding.top + SizeConfig.padding20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding2),
            child: GestureDetector(
              onTap: () async {
                await AppState.backButtonDispatcher!.didPopRoute();
              },
              child: Icon(
                Icons.arrow_back,
                color: UiConstants.kTextColor,
                size: SizeConfig.iconSize0,
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.padding18,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fdData.displayName,
                  style: TextStyles.sourceSansSB.body1,
                ),
                SizedBox(height: SizeConfig.padding2),
                Text(
                  fdData.subText + fdData.subText,
                  style: TextStyles.sourceSans.body3,
                ),
              ],
            ),
          ),
          Hero(
            tag: fdData.id,
            child: ClipOval(
              child: AppImage(
                fdData.icon,
                width: SizeConfig.padding48,
                height: SizeConfig.padding48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
