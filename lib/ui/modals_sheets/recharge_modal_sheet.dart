import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modals_sheets/congratory_modal.dart';
import 'package:felloapp/ui/modals_sheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RechargeModalSheet extends StatefulWidget {
  const RechargeModalSheet({Key key}) : super(key: key);

  @override
  State<RechargeModalSheet> createState() => _RechargeModalSheetState();
}

class _RechargeModalSheetState extends State<RechargeModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            decoration: BoxDecoration(
              color: UiConstants.kProfileBorderColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            width: SizeConfig.screenWidth * 0.25,
            height: SizeConfig.padding4,
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Text(
            'Recharge',
            style: TextStyles.sourceSansSB.title4,
          ),
          SizedBox(
            height: SizeConfig.padding54,
          ),
          EnterAmountView(),
          Spacer(),
          GestureDetector(
            onTap: () {
              BaseUtil.openModalBottomSheet(
                content: CouponModalSheet(),
                addToScreenStack: true,
                backgroundColor: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness24),
                  topRight: Radius.circular(SizeConfig.roundness24),
                ),
                boxContraints: BoxConstraints(
                  maxHeight: SizeConfig.screenHeight * 0.88,
                  minHeight: SizeConfig.screenHeight * 0.88,
                ),
                isBarrierDismissable: false,
                isScrollControlled: true,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/temp/ticket.svg',
                  width: SizeConfig.iconSize0,
                  height: SizeConfig.iconSize0,
                ),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                Text(
                  'Apply a coupon code',
                  style: TextStyles.sourceSans.body2
                      .colour(UiConstants.kPrimaryColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          AppPositiveBtn(
            btnText: 'Invest',
            onPressed: () async {
              AppState.backButtonDispatcher.didPopRoute();
              await Future.delayed(Duration(seconds: 5));
              BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: true,
                boxContraints: BoxConstraints(
                  maxHeight: SizeConfig.screenHeight,
                ),
                backgroundColor: UiConstants.kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness24),
                  topRight: Radius.circular(SizeConfig.roundness24),
                ),
                hapticVibrate: true,
                isBarrierDismissable: true,
                isScrollControlled: true,
                content: CongratoryDialog(),
              );
              await Future.delayed(Duration(seconds: 5));
              // AppState.backButtonDispatcher.didPopRoute();
            },
            width: SizeConfig.screenWidth * 0.813,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
        ],
      ),
    );
  }
}

class EnterAmountView extends StatefulWidget {
  const EnterAmountView({Key key}) : super(key: key);

  @override
  State<EnterAmountView> createState() => _EnterAmountViewState();
}

class _EnterAmountViewState extends State<EnterAmountView> {
  final TextEditingController textEditingController =
      TextEditingController(text: '₹ 300');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color:
                  UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/temp/digital_gold.svg',
                      width: SizeConfig.screenWidth * 0.12,
                      height: SizeConfig.screenWidth * 0.12,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      'Digital Gold',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Current rate (00:04s)",
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kTextFieldTextColor),
                        ),
                        Text(
                          "\₹5445/gm",
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kPrimaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Container(
                  width: double.infinity,
                  height: SizeConfig.screenWidth * 0.1466,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          textEditingController: textEditingController,
                          isEnabled: true,
                          validator: (val) {
                            return null;
                          },
                          height: SizeConfig.screenWidth * 0.1466,
                          onChanged: (String val) {
                            if (val.isEmpty) {
                              textEditingController.text = '₹ ';
                            }
                            if (val.isNotEmpty) {
                              textEditingController.text =
                                  '₹ ' + val.split('₹')[0];
                            }
                            textEditingController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: textEditingController.text.length,
                              ),
                            );
                            // log(val);
                          },
                          inputDecoration: InputDecoration(
                            fillColor: UiConstants.kTextFieldColor,
                            filled: true,
                            contentPadding: EdgeInsets.only(
                              left: SizeConfig.padding24,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              borderSide: BorderSide(
                                color: UiConstants.kTextColor.withOpacity(0.1),
                                width: SizeConfig.border1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              borderSide: BorderSide(
                                color: UiConstants.kTextColor.withOpacity(0.1),
                                width: SizeConfig.border1,
                              ),
                            ),
                          ),
                          textStyle: TextStyles.rajdhaniSB.title4,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth * 0.2666,
                        decoration: BoxDecoration(
                          color: UiConstants.kBackgroundColor.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness12),
                            bottomRight:
                                Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '19.923 gm',
                            style: TextStyles.sourceSansSB.body2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'YOU GET',
                      style: TextStyles.sourceSans.body3,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    SvgPicture.asset(
                      'assets/temp/Tokens.svg',
                      width: SizeConfig.iconSize0,
                      height: SizeConfig.iconSize0,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      '100',
                      style: TextStyles.sourceSans.body3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountChip(150),
              _buildAmountChip(200),
              _buildAmountChip(300),
              _buildAmountChip(500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(
    int amount,
  ) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Haptic.vibrate();
        textEditingController.text = '₹ ' + amount.toString();
        setState(() {});
        // model.onAmountValueChanged(amount.toString());
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding8,
              horizontal: SizeConfig.padding16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    int.tryParse(textEditingController.text.split('₹ ')[1]) ==
                            amount
                        ? Color(0xFFFEF5DC)
                        : Color(0xFFFEF5DC).withOpacity(0.2),
                width: SizeConfig.border0,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              // color: UiConstants.primaryLight.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              "₹ ${amount.toInt()}",
              style: TextStyles.sourceSansL.body2,
            ),
          ),
        ],
      ),
    );
  }
}
