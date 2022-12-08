import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/asset_options_model.dart' as I;
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/draw_time_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BannerWidget extends StatefulWidget {
  BannerWidget({Key? key, required this.model, required this.happyHourCampign})
      : showHappyHour = happyHourCampign?.data?.showHappyHour ?? false,
        super(key: key);
  final I.Banner model;
  final bool showHappyHour;
  final HappyHourCampign? happyHourCampign;
  @override
  State<BannerWidget> createState() => _BannerWidgetState(
      endTime: DateTime.tryParse(happyHourCampign?.data?.endTime ?? ''));
}

class _BannerWidgetState extends TimerUtil<BannerWidget> {
  _BannerWidgetState({required DateTime? endTime})
      : super(endTime: endTime ?? DateTime.now());

  late bool showHappyHour;
  @override
  void initState() {
    showHappyHour = widget.showHappyHour;
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: showHappyHour
            ? Colors.black.withOpacity(0.5)
            : UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding8,
        horizontal: SizeConfig.padding12,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeConfig.padding32,
              width: SizeConfig.padding32,
              child: showHappyHour
                  ? SvgPicture.asset(Assets.sandTimer)
                  : SvgPicture.network(
                      widget.model.image,
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(width: SizeConfig.padding4),
            Flexible(
              child: showHappyHour
                  ? RichText(
                      text: TextSpan(
                          style: TextStyles.rajdhaniSB.body3
                              .colour(Color(0XFFB5CDCB)),
                          text: "Happy Hour ends in ",
                          children: [
                            TextSpan(
                                text:
                                    inHours + ":" + inMinutes + ":" + inSeconds,
                                style: TextStyles.rajdhaniB
                                    .colour(Color(0xff51EADD)))
                          ]),
                    )
                  : Text(
                      widget.model.title,
                      maxLines: 2,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor3),
                    ),
            ),
            SizedBox(
              width: 8,
            ),
            if (showHappyHour)
              GestureDetector(
                onTap: () => locator<BaseUtil>()
                    .showHappyHourDialog(locator<HappyHourCampign>()),
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xffB5CDCB),
                ),
              ),
          ]),
    );
  }
}
