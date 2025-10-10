import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationOffer offer;
  final Function(ConsultationOffer)? onBook;

  const ConsultationCard({
    required this.offer,
    super.key,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
      padding: EdgeInsets.all(12.r),
      constraints: BoxConstraints(
        maxWidth: 268.w,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: UiConstants.grey6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: UiConstants.teal4.withOpacity(0.25),
              borderRadius: BorderRadius.all(
                Radius.circular(8.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a Consultation',
                  style: TextStyles.sourceSansSB.body3,
                ),
                const SizedBox(height: 4),
                Text(
                  '${offer.price.startsWith('₹') ? offer.price : BaseUtil.formatIndianRupees(num.tryParse(offer.price) ?? 0)}/${offer.duration.contains('min') ? offer.duration : '${offer.duration} min'}',
                  style: TextStyles.sourceSansM.body4,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: const Divider(
              color: UiConstants.grey6,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4.r,
                height: 4.r,
                margin: EdgeInsets.only(top: 6.h, right: 8.w),
                decoration: BoxDecoration(
                  color: UiConstants.kTextColor.withOpacity(.75),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  offer.description,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor.withOpacity(.75),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          GestureDetector(
            onTap: onBook != null ? () => onBook!(offer) : null,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  5.r,
                ),
              ),
              child: Text(
                'Book a call',
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
