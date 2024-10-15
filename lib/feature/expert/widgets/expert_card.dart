import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class ExpertCard extends StatelessWidget {
  final Expert expert;
  final VoidCallback onBookCall;
  final VoidCallback onTap;

  const ExpertCard({
    required this.expert,
    required this.onBookCall,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String price = expert.isFree ? 'Free' : '₹${expert.rating}/min';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness8),
                    bottomLeft: Radius.circular(
                      SizeConfig.roundness8,
                    ),
                  ),
                  child: Image.network(
                    expert.image,
                    height: SizeConfig.padding156,
                    width: SizeConfig.padding140,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: SizeConfig.padding8,
                  left: SizeConfig.padding10,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          SizeConfig.padding4,
                        ),
                        decoration: BoxDecoration(
                          color: UiConstants.kTextColor4.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.badge,
                              color: UiConstants.kTabBorderColor,
                              size: SizeConfig.body6,
                            ),
                            SizedBox(
                              width: SizeConfig.padding2,
                            ),
                            Text(
                              expert.experience.toString(),
                              style: TextStyles.sourceSans.body6,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                          SizeConfig.padding4,
                        ),
                        margin: EdgeInsets.only(left: SizeConfig.padding12),
                        decoration: BoxDecoration(
                          color: UiConstants.kTextColor4.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: UiConstants.kamber,
                              size: SizeConfig.body6,
                            ),
                            SizedBox(
                              width: SizeConfig.padding2,
                            ),
                            Text(
                              '${expert.rating}',
                              style: TextStyles.sourceSans.body6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding10,
                ),
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.padding156,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expert.name,
                          style: TextStyles.sourceSansSB.body1.colour(
                            UiConstants.kTextColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: UiConstants.kTextColor,
                          size: SizeConfig.body2,
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding4),
      
                    // Expertise List
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: UiConstants.kTextColor6,
                          size: SizeConfig.body4,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        Expanded(
                          child: Text(
                            expert.expertise,
                            style: TextStyles.sourceSans.body4.colour(
                              UiConstants.kTextColor6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding4),
      
                    // Qualifications List
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: UiConstants.kTextColor6,
                          size: SizeConfig.body4,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        Expanded(
                          child: Text(
                            expert.qualifications,
                            style: TextStyles.sourceSans.body4.colour(
                              UiConstants.kTextColor6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    const Divider(
                      color: UiConstants.grey6,
                    ),
                    SizedBox(height: SizeConfig.padding8),
      
                    // Price and Book Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyles.sourceSansSB.body3.colour(
                            UiConstants.kTextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: onBookCall,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding8,
                              vertical: SizeConfig.padding6,
                            ),
                            decoration: BoxDecoration(
                              color: UiConstants.kTextColor,
                              borderRadius: BorderRadius.circular(
                                SizeConfig.roundness5,
                              ),
                            ),
                            child: Text(
                              'Book a Call',
                              style: TextStyles.sourceSansSB.body4.colour(
                                UiConstants.kTextColor4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
