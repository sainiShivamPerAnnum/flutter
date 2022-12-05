import 'dart:async';

import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HappyHourModal extends StatefulWidget {
  const HappyHourModal({Key? key}) : super(key: key);

  @override
  State<HappyHourModal> createState() => _HappyHourModalState();
}

class _HappyHourModalState extends State<HappyHourModal> {
  late ValueNotifier<Duration> _countDown;
  late Timer _timer;
  @override
  void initState() {
    _countDown = ValueNotifier(getDifferance());
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _countDown.value = getDifferance();
    });
    super.initState();
  }

  Duration getDifferance() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 0, 10);
    Duration timeDiff = drawTime.difference(currentTime);

    return timeDiff;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  getTime(int index, Duration duration) {
    switch (index) {
      case 0:
        return twoDigits(duration.inHours);
      case 1:
        return twoDigits(duration.inMinutes.remainder(60));
      case 2:
        return twoDigits(duration.inSeconds.remainder(60));
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: SizeConfig.screenHeight! * 0.48,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: UiConstants.kSaveDigitalGoldCardBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  SizeConfig.roundness32,
                ),
              ),
              border: Border.all(color: Color(0xff93B5FE))),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * .1,
              ),
              Text(
                'It\'s Happy Hour ',
                style: TextStyles.sourceSansSB.body1,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .07,
              ),
              ValueListenableBuilder<Duration>(
                  valueListenable: _countDown,
                  builder: (context, value, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => index % 2 == 0
                            ? Container(
                                height: SizeConfig.screenHeight! * 0.08,
                                width: SizeConfig.screenHeight! * 0.08,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff1F2C65).withOpacity(0.6),
                                  boxShadow: [
                                    BoxShadow(
                                      blurStyle: BlurStyle.outer,
                                      color: Color(0xff93B5FE).withOpacity(0.4),
                                      // spreadRadius: 2,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  getTime((index / 2).round(), value),
                                  style: TextStyles.rajdhaniSB.title3,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  ":",
                                  style: TextStyles.sourceSans.body1
                                      .colour(Color(0XFFBDBDBE)),
                                ),
                              ),
                      ),
                    );
                  }),
              SizedBox(height: SizeConfig.screenHeight! * 0.05),
              Text(
                '100% cashback for any transaction for the next 10 mins',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(.6)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "10 lucky winners get the 100% cashback",
                style: TextStyles.sourceSans.body4
                    .colour(Colors.white.withOpacity(0.6)),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .04,
              ),
              CustomSaveButton(
                onTap: () {},
                title: 'SAVE NOW',
                color: Colors.black.withOpacity(0.5),
                showBorder: false,
                width: SizeConfig.screenWidth! * 0.3,
                height: SizeConfig.screenWidth! * 0.11,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            Assets.sandTimer,
            height: 120,
            width: 120,
          ),
        )
      ],
    );
  }
}
