import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class LiveCardWidget extends StatelessWidget {
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final String? duration;

  const LiveCardWidget({
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    super.key,
    this.liveCount,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.padding300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        color: UiConstants.greyVarient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: double.infinity,
                height: SizeConfig.padding152,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness8),
                    topRight: Radius.circular(SizeConfig.roundness8),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (status == 'live')
                Positioned(
                  bottom: SizeConfig.padding10,
                  left: SizeConfig.padding10,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding4,
                        ),
                        decoration: BoxDecoration(
                          color: UiConstants.kred1,
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Text(
                          'LIVE',
                          style: TextStyles.sourceSansSB.body4.colour(
                            UiConstants.titleTextColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.padding4),
                        decoration: BoxDecoration(
                          color: UiConstants.kTextColor4,
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding4,
                        ),
                        child: Row(
                          children: [
                            if (liveCount != null)
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: SizeConfig.body4,
                              ),
                            if (liveCount != null)
                              SizedBox(
                                width: SizeConfig.padding4,
                              ),
                            if (liveCount != null)
                              Text(
                                '${liveCount! ~/ 1000}K',
                                style: TextStyles.sourceSansSB.body4.colour(
                                  UiConstants.titleTextColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (status == 'live')
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.padding8),
                    decoration: BoxDecoration(
                      color: UiConstants.kTextColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: SizeConfig.iconSize5,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.padding4),
                  decoration: BoxDecoration(
                    color: UiConstants.kblue2.withOpacity(.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.kblue1,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),
                // Title
                Text(
                  title,
                  style: TextStyles.sourceSansSB.body2.colour(
                    UiConstants.kTextColor,
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),

                // Subtitle (time started or duration)
                Text(
                  subTitle,
                   style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor5,
                  ),
                ),
                SizedBox(height: SizeConfig.padding20),

                // Author's name
                Text(
                  author,
                 style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor,
                  ),
                ),
              ],
            ),
          )
          // Category tag
        ],
      ),
    );
  }
}
