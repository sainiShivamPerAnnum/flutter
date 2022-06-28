import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponModalSheet extends StatelessWidget {
  const CouponModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(left: SizeConfig.padding16),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            child: AppTextField(
              height: SizeConfig.screenWidth * 0.1466,
              fillColor: UiConstants.kBackgroundColor,
              textEditingController: TextEditingController(),
              inputDecoration: InputDecoration(
                hintText: 'Enter coupon code here',
                hintStyle: TextStyles.body3.colour(UiConstants.kTextColor2),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  borderSide: BorderSide(
                    color: UiConstants.kTabBorderColor,
                    width: SizeConfig.border1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  borderSide: BorderSide(
                    color: UiConstants.kTextColor.withOpacity(0.1),
                    width: SizeConfig.border1,
                  ),
                ),
                filled: true,
                fillColor: UiConstants.kBackgroundColor,
              ),
              validator: (val) {
                return null;
              },
              isEnabled: true,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return _buildCoupenListTile();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoupenListTile() {
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
                    'EXTRA1%',
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  Container(
                    // margin:
                    //     EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                    width: SizeConfig.screenWidth * 0.6,
                    child: Text(
                      'Buy above Rs. 500 & get 1% extra Digital Gold',
                      style: TextStyles.sourceSans.body3
                          .setOpecity(0.6)
                          .setHeight(1.5),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'APPLY',
                style: TextStyles.sourceSans.body3
                    .colour(UiConstants.kTabBorderColor),
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
