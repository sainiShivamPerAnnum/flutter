import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextWeekTicketInfo extends StatelessWidget {
  const NextWeekTicketInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTime.now().weekday == DateTime.sunday
        ? Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! * 0.06,
              vertical: SizeConfig.padding16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white.withOpacity(0.5), width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.transparent),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.padding6),
                  height: 45,
                  decoration: BoxDecoration(
                      color: UiConstants.kNextTicketInfo.withOpacity(0.5),
                      // borderRadius: BorderRadius.circular(50),
                      shape: BoxShape.circle),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    height: 24,
                    decoration: BoxDecoration(
                        color: UiConstants.kNextTicketInfo,
                        // borderRadius: BorderRadius.circular(50),
                        shape: BoxShape.circle),
                    child: SvgPicture.asset('assets/svg/bulb.svg'),
                  ),
                ),
                SizedBox(width: SizeConfig.padding12),
                Expanded(
                  child: Text(
                    'New tickets received from 6PM - 12AM on Sunday will be considered for next week’s draw',
                    maxLines: 3,
                    style: TextStyles.sourceSans.body4.colour(
                      Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}
