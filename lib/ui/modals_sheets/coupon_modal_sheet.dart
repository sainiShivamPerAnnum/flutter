import 'dart:developer';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponModalSheet extends StatelessWidget {
  CouponModalSheet({Key key, @required this.model}) : super(key: key);
  final AugmontGoldBuyViewModel model;
  final TextEditingController couponCodeController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.padding24, top: SizeConfig.padding24),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: SizeConfig.padding24,
                  color: Colors.white,
                ),
                onPressed: () {
                  AppState.backButtonDispatcher.didPopRoute();
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: AppTextField(
                fillColor: UiConstants.kBackgroundColor,
                textEditingController: couponCodeController,
                hintText: 'Enter coupon code here',
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                suffixIcon: InkWell(
                  child: Text(
                    "Apply",
                    style: TextStyles.sourceSans.body3.bold
                        .colour(UiConstants.kPrimaryColor),
                  ),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      model.applyCoupon(couponCodeController.text.trim());
                      AppState.backButtonDispatcher.didPopRoute();
                    }
                  },
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 40,
                ),
                validator: (val) {
                  if (val.trim().length == 0 || val == null)
                    return "Please enter a code to continue";
                  if (val.trim().length < 3 || val.trim().length > 10)
                    return "Invalid Coupon code";
                  return null;
                },
                isEnabled: true,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
              physics: BouncingScrollPhysics(),
              children: List.generate(
                model.couponList.length,
                (i) => Container(
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: _buildCoupenListTile(
                    couponCode: model.couponList[i].code,
                    desc: model.couponList[i].description,
                    onTap: () {
                      model.applyCoupon(model.couponList[i].code);
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                  ),
                ),
              ),
            ),
            // child: ListView.builder(
            //   itemCount: 5,
            //   shrinkWrap: true,
            //   scrollDirection: Axis.vertical,
            //   itemBuilder: (context, index) {
            //     return _buildCoupenListTile();
            //   },
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoupenListTile(
      {@required String couponCode,
      @required String desc,
      @required Function onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/temp/ticket.svg',
                width: SizeConfig.iconSize0,
                height: SizeConfig.iconSize0,
                color: UiConstants.kpurpleTicketColor,
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    couponCode,
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  Container(
                    // margin:
                    //     EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                    width: SizeConfig.screenWidth * 0.55,
                    child: Text(
                      desc,
                      style: TextStyles.sourceSans.body3
                          .setOpecity(0.6)
                          .setHeight(1.5),
                    ),
                  ),
                ],
              ),
              Spacer(),
              TextButton(
                onPressed: onTap,
                child: Text(
                  'APPLY',
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTabBorderColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
          Divider(
            thickness: SizeConfig.border0,
            color: UiConstants.kWinnerPlayerLightPrimaryColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
