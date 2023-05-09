import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TambolaTicketInfo extends StatelessWidget {
  const TambolaTicketInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Container(
      height: SizeConfig.screenHeight! * 0.10,
      width: SizeConfig.screenWidth! * 0.80,
      decoration: BoxDecoration(
        border: Border.all(color: UiConstants.kFAQDividerColor),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          tileMode: TileMode.mirror,
          end: Alignment.centerRight,
          stops: const [0, 0.5, 0.5, 1],
          colors: [
            const Color(
              0xff627F8E,
            ).withOpacity(0.2),
            const Color(
              0xff627F8E,
            ).withOpacity(0.2),
            Colors.transparent,
            Colors.transparent
          ],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth! * 0.37,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ ${AppConfig.getValue(AppConfigKey.tambola_cost).toString().isEmpty ? '500' : AppConfig.getValue<int>(AppConfigKey.tambola_cost).toString()}",
                  style: TextStyles.sourceSansB.title3,
                ),
                Text(
                  "invested",
                  style: TextStyles.sourceSansSB.body3,
                )
              ],
            ),
          ),
          Text('=', style: TextStyles.sourceSansB.title1),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.37,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("1 Ticket", style: TextStyles.sourceSansB.title3),
                Text(
                  "every week for lifetime",
                  style: TextStyles.sourceSansSB.body4,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
