import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/quick_save_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class QuickSaveModalSheet extends StatelessWidget {
  const QuickSaveModalSheet({required this.quickSaveData, Key? key})
      : super(key: key);

  final List<QuickSaveData> quickSaveData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
        decoration: BoxDecoration(
          color: const Color(0xff1B262C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Quick Actions with Fello
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding24),
                child: Text('Quick Actions with Fello',
                    style: TextStyles.rajdhaniSB.body1),
              ),
              SizedBox(height: SizeConfig.padding4),
              //Select anyone option to perform a quick action
              Text('Select anyone option to perform a quick action',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6))),
              SizedBox(height: SizeConfig.padding20),

              ...quickSaveData.map((data) {
                log("QuickSaveModalSheet: ${data.toJson()}");
                return GestureDetector(
                  onTap: () {
                    AppState.backButtonDispatcher?.didPopRoute();
                    if (data.misc?.asset == 'AUGGOLD99') {
                      BaseUtil().openRechargeModalSheet(
                          investmentType: InvestmentType.AUGGOLD99,
                          amt: data.misc?.amount);
                    } else if (data.misc?.asset == 'LENDBOXP2P') {
                      BaseUtil().openRechargeModalSheet(
                          investmentType: InvestmentType.LENDBOXP2P,
                          amt: data.misc?.amount);
                    } else {
                      if (data.action!.startsWith('Http') ||
                          data.action!.startsWith('Https')) {
                        AppState.delegate!.parseRoute(Uri.parse(data.action!),
                            isExternal: true);
                      } else {
                        AppState.delegate!.parseRoute(Uri.parse(data.action!));
                      }
                    }

                    locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.quickCheckoutTileTapped,
                        properties: {
                          'Text Title': data.title ?? '',
                          'Text Subtitle': data.subTitle ?? '',
                          'Asset': data.misc?.asset ?? '',
                          'Amount': data.misc?.amount ?? '',
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding26,
                        vertical: SizeConfig.padding16),
                    margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                    decoration: BoxDecoration(
                        color: data.theme?.backgroundColor != null
                            ? data.theme?.backgroundColor?.toColor()
                            : const Color(0xff1B262C),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                        border: Border.all(
                            color: data.theme?.borderColor != null
                                ? data.theme!.borderColor!.toColor()!
                                : const Color(0xffD3D3D3).withOpacity(0.2))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.padding38,
                          height: SizeConfig.padding38,
                          child: BaseUtil.getWidgetBasedOnUrl(
                            data.icon!,
                            width: SizeConfig.padding54,
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding26),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              data.title!,
                              style: TextStyles.rajdhaniB.title5.colour(
                                  data.theme?.titleColor != null
                                      ? data.theme?.titleColor?.toColor()
                                      : const Color(0xffF4EDD9)),
                            ),
                            Flexible(
                              child: Text(
                                data.subTitle!,
                                style: TextStyles.sourceSans.body4.colour(
                                    data.theme?.subtitleColor != null
                                        ? data.theme?.subtitleColor?.toColor()
                                        : Colors.white.withOpacity(0.6)),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),

              SizedBox(height: SizeConfig.padding20),
            ]),
      ),
    );
  }
}
