import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class ConsultationWidget extends StatelessWidget {
  const ConsultationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding14),
        GestureDetector(
          onTap: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSubtitleContainer(
                title: "Book your session",
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: SizeConfig.padding10,
            left: SizeConfig.padding18,
            right: SizeConfig.padding18,
          ),
          padding: EdgeInsets.all(SizeConfig.padding16),
          decoration: BoxDecoration(
            color: UiConstants.greyVarient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness16),
              topRight: Radius.circular(SizeConfig.roundness16),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERSONALISED CONSULTATION',
                      style: TextStyles.sourceSansSB.body6.colour(
                        UiConstants.kTabBorderColor,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      'Get expert advice and start\nachieving financial goals!',
                      style: TextStyles.sourceSansSB.body2.colour(
                        UiConstants.kTextColor,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding12),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12,
                          vertical: SizeConfig.padding6,
                        ),
                        decoration: BoxDecoration(
                          color: UiConstants.kTextColor,
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Text(
                          'Book Now!',
                          style: TextStyles.sourceSansSB.body4.colour(
                            UiConstants.kTextColor4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.padding64,
                height: SizeConfig.padding64,
                child: Image.network(
                  Assets.calender,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: UiConstants.greyVarient.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.roundness16),
              bottomRight: Radius.circular(SizeConfig.roundness16),
            ),
          ),
          margin: EdgeInsets.only(
            bottom: SizeConfig.padding10,
            left: SizeConfig.padding18,
            right: SizeConfig.padding18,
          ),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: UiConstants.kTextColor.withOpacity(0.75),
                size: SizeConfig.body6,
              ),
              SizedBox(
                width: SizeConfig.padding4,
              ),
              Text(
                '135 users booked an appointment today',
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.kTextColor.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
