import 'package:felloapp/core/model/advisor/advisor_upcoming_call.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Call extends StatefulWidget {
  final String callType;
  const Call({required this.callType, Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
  return formatter.format(dateTime);
}

class _CallState extends State<Call> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvisorBloc, AdvisorState>(
      builder: (context, state) {
        if (state is AdvisorData) {
          final List<AdvisorCall> data = widget.callType == 'upcoming'
              ? state.advisorUpcomingCalls
              : state.advisorPastCalls;
          final displayedData = showAll ? data : data.take(3).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleSubtitleContainer(
                    title: widget.callType == 'upcoming'
                        ? 'Upcoming Calls'
                        : 'Past Scheduled Calls',
                    zeroPadding: true,
                  ),
                  if (data.length > 3)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAll = !showAll;
                        });
                      },
                      child: Text(
                        showAll ? 'View Less' : 'View More',
                        style: TextStyles.sourceSans.body4,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              data.isEmpty
                  ? const Center(
                      child: Text(
                        "No calls available",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : Column(
                      children: displayedData
                          .map(
                            (call) => callContainer(
                              call.userName ?? 'Unknown Title',
                              call.scheduledOn.toString(),
                              call.duration,
                              widget.callType,
                            ),
                          )
                          .toList(),
                    ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget callContainer(
  String title,
  String scheduledOn,
  String duration,
  String callType,
) {
  return Container(
    margin: EdgeInsets.only(bottom: SizeConfig.padding24),
    padding: EdgeInsets.symmetric(
      vertical: SizeConfig.padding14,
      horizontal: SizeConfig.padding18,
    ),
    decoration: BoxDecoration(
      color: UiConstants.greyVarient,
      borderRadius: BorderRadius.circular(
        SizeConfig.roundness12,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: SizeConfig.padding28,
              height: SizeConfig.padding28,
              child: Image.asset(
                Assets.user,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: SizeConfig.padding10,
            ),
            Text(
              title,
              style: TextStyles.sourceSansSB.body1,
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Call Time',
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor5),
                  ),
                  Text(
                    formatDateTime(DateTime.parse(scheduledOn)),
                    style: TextStyles.sourceSansSB.body3,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Duration',
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor5),
                ),
                Text(
                  duration,
                  style: TextStyles.sourceSansSB.body3,
                ),
              ],
            ),
          ],
        ),
        if (callType == 'upcoming')
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding16,
            ),
            child: const Divider(
              color: UiConstants.grey6,
              height: 0,
              thickness: 1,
            ),
          ),
        if (callType == 'upcoming')
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'View Details',
                style: TextStyles.sourceSansSB.body3,
              ),
              SizedBox(
                width: SizeConfig.padding28,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add join call logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding6,
                    horizontal: SizeConfig.padding8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
                child: Text(
                  'Join Call',
                  style: TextStyles.sourceSansSB.body3.colour(
                    UiConstants.kTextColor4,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
