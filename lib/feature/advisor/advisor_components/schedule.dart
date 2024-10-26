//Project Imports
// ignore_for_file: prefer_const_constructors

import 'package:felloapp/feature/advisor/bloc/live_details_bloc.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCallWrapper extends StatelessWidget {
  final String? id;
  final String? status;
  final String? title;
  final String? subTitle;
  final String? author;
  final String? category;
  final String? bgImage;
  final int? liveCount;
  final int? duration;
  final String? timeSlot;

  const ScheduleCallWrapper({
    this.id,
    this.status,
    this.title,
    this.subTitle,
    this.author,
    this.category,
    this.bgImage,
    this.liveCount,
    this.duration,
    this.timeSlot,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        title:
            const Text('Schedule Live', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(
          color: UiConstants.kTextColor,
        ),
      ),
      body: BlocProvider(
        create: (context) => ScheduleLiveBloc(locator())..add(LoadCategories()),
        child: BlocBuilder<ScheduleLiveBloc, ScheduleCallState>(
          builder: (context, state) {
            if (state is ScheduleCallLoading) {
              return FullScreenLoader();
            } else if (state is ScheduleCallLoaded) {
              return _buildScheduleCallContent(context, state);
            } else if (state is ScheduleCallFailure) {
              return ErrorPage();
            } else if (state is ScheduleCallSuccess) {
              return Center(child: Text(state.message));
            }
            return FullScreenLoader();
          },
        ),
      ),
    );
  }

  Widget _buildScheduleCallContent(
    BuildContext context,
    ScheduleCallLoaded state,
  ) {
    final topicController = TextEditingController(text: title ?? '');
    final descriptionController = TextEditingController(text: subTitle ?? '');

    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What is the Topic of Live",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: topicController,
              decoration: _inputDecoration("Start typing here"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              "Add description",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: _inputDecoration("Start typing here"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Category for Live",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategorySelection(context, state),
            const SizedBox(height: 24),
            const Text(
              "Upload Cover Image",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildUploadImageButton(context, state),
            const SizedBox(height: 24),
            const Text(
              "Select Date",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildDateSelection(context, state),
            const SizedBox(height: 24),
            const Text(
              "Select Time",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeSelection(context, state),
            const SizedBox(height: 48),
            _buildSubmitButton(
              context,
              topicController,
              descriptionController,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }

  Widget _buildCategorySelection(
    BuildContext context,
    ScheduleCallLoaded state,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        final isSelected = category == state.selectedCategory;

        return GestureDetector(
          onTap: () =>
              context.read<ScheduleLiveBloc>().add(SelectCategory(category)),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.white : Color(0xff1A1A1A),
                width: 1,
              ),
            ),
            child: Center(
              child:
                  Text(category, style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadImageButton(
    BuildContext context,
    ScheduleCallLoaded state,
  ) {
    final profilePictureText =
        state.profilePicture != null ? "Re-upload Image" : "Upload Image";
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Upload and resize image to be used as cover for your upcoming live",
            style: TextStyle(
              color: Color(0xffA2A0A2),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () =>
              context.read<ScheduleLiveBloc>().add(UploadProfilePicture()),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(
            profilePictureText,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection(BuildContext context, ScheduleCallLoaded state) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List<Widget>.generate(state.dates.length, (index) {
        final date = state.dates[index];
        final isSelected = index == state.selectedDateIndex;

        return GestureDetector(
          onTap: () => context.read<ScheduleLiveBloc>().add(SelectDate(index)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? Colors.white : Color(0xff2D3135),
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date['day']!,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  date['date']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimeSelection(BuildContext context, ScheduleCallLoaded state) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List<Widget>.generate(state.times.length, (index) {
        final time = state.times[index]['TimeUI']!;
        final isSelected = index == state.selectedTimeIndex;

        return GestureDetector(
          onTap: () => context.read<ScheduleLiveBloc>().add(SelectTime(index)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? Colors.white : Color(0xff2D3135),
                width: 2.0,
              ),
            ),
            child:
                Text(time, style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        );
      }),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    TextEditingController topicController,
    TextEditingController descriptionController,
  ) {
    final bloc = context.read<ScheduleLiveBloc>();

    return ElevatedButton(
      onPressed: () {
        final topic = topicController.text;
        final description = descriptionController.text;
        if (id != null) {
          bloc.add(UpdateEvent(id!, topic, description));
        } else {
          bloc.add(ScheduleEvent(topic, description));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Schedule Live',
        style: TextStyle(
          color: Color(0xff3F4748),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
