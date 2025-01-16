import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({
    required this.advisorId,
    required this.onSubmit,
    super.key,
  });
  final String advisorId;
  final Function(num rating, String comment) onSubmit;

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  double rating = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding20,
            ).copyWith(
              top: SizeConfig.padding14,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Share Your Feedback',
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                      },
                      child: Icon(
                        Icons.close,
                        size: SizeConfig.body1,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: UiConstants.greyVarient,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding18,
              vertical: SizeConfig.padding16,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
              vertical: SizeConfig.padding20,
            ),
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate your call',
                  style: TextStyles.sourceSansSB.body2,
                ),
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  glow: false,
                  itemSize: SizeConfig.body1,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: SizeConfig.body1,
                  ),
                  onRatingUpdate: (value) {
                    rating = value;
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: UiConstants.greyVarient,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
              vertical: SizeConfig.padding14,
            ).copyWith(bottom: 0),
            child: Text(
              'How was your experience',
              style: TextStyles.sourceSans.body3,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
              vertical: SizeConfig.padding14,
            ),
            child: TextField(
              maxLines: 4,
              controller: _controller,
              style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor),
              decoration: InputDecoration(
                hintText: 'Start typing here',
                hintStyle: TextStyles.sourceSans.body3.colour(
                  UiConstants.kTextColor5,
                ),
                fillColor: UiConstants.greyVarient,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  borderSide: const BorderSide(color: UiConstants.greyVarient),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  borderSide: const BorderSide(color: UiConstants.greyVarient),
                ),
              ),
            ),
          ),
          const Divider(
            color: UiConstants.greyVarient,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding18,
              ).copyWith(
                top: SizeConfig.padding18,
                bottom: SizeConfig.padding40,
              ),
              child: ElevatedButton(
                onPressed: () =>
                    widget.onSubmit(rating, _controller.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UiConstants.kTextColor,
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                ),
                child: Text(
                  'Rate',
                  style: TextStyles.sourceSansSB.body3.colour(
                    UiConstants.kTextColor4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
