import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/advisor/advisor_components/booking_confirm_sheet.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/advisor/bloc/live_details_bloc.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCallWrapper extends StatefulWidget {
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
  State<ScheduleCallWrapper> createState() => _ScheduleCallWrapperState();
}

class _ScheduleCallWrapperState extends State<ScheduleCallWrapper> {
  final topicController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    topicController.text = widget.title ?? '';
    descriptionController.text = widget.subTitle ?? '';
    super.initState();
  }

  @override
  void dispose() {
    topicController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
        leading: const BackButton(
          color: UiConstants.kTextColor,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ScheduleLiveBloc(locator())..add(LoadCategories()),
            ),
            BlocProvider(
              create: (context) => AdvisorBloc(locator()),
            ),
          ],
          child: BlocConsumer<ScheduleLiveBloc, ScheduleCallState>(
            listener: (context, state) {
              if (state is ScheduleCallSuccess) {
                BaseUtil.openModalBottomSheet(
                  isBarrierDismissible: false,
                  content: BookingConfirmSheet(
                    name: topicController.text.trim(),
                    date: state.date,
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  BlocProvider.of<AdvisorBloc>(
                    context,
                    listen: false,
                  ).add(const LoadAdvisorData());
                });
              }
            },
            builder: (context, state) {
              return switch (state) {
                ScheduleCallInitial() ||
                ScheduleCallLoading() =>
                  const FullScreenLoader(),
                ScheduleCallLoaded() =>
                  _buildScheduleCallContent(context, state),
                ScheduleCallFailure() => const ErrorPage(),
                ScheduleCallSuccess() => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCallContent(
    BuildContext context,
    ScheduleCallState state,
  ) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.padding16),
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
            _buildCategorySelection(context, state as ScheduleCallLoaded),
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
            padding: EdgeInsets.all(SizeConfig.padding10),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.white : const Color(0xff1A1A1A),
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

    final description = state.profilePicture != null
        ? "Image Uploaded"
        : "Upload and resize image to be used as cover for your upcoming live";
    return Column(
      children: [
        if (state.profilePicture != null)
          Container(
            decoration: BoxDecoration(
              color: UiConstants.kTambolaMidTextColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding20,
              vertical: SizeConfig.padding12,
            ),
            margin: EdgeInsets.only(
              bottom: SizeConfig.padding16,
            ),
            child: Row(
              children: [
                AppImage(
                  Assets.image,
                  height: SizeConfig.padding20,
                  width: SizeConfig.padding20,
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.profilePicture?.name ?? 'null',
                        style: TextStyles.sourceSansSB.body3
                            .colour(UiConstants.kTextColor),
                      ),
                      Text(
                        BaseUtil.formatDateTime(DateTime.now()),
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTextColor5),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context
                      .read<ScheduleLiveBloc>()
                      .add(UploadProfilePicture()),
                  child: AppImage(
                    Assets.garbageBin,
                    height: SizeConfig.padding18,
                    width: SizeConfig.padding18,
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                description,
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor5),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.read<ScheduleLiveBloc>().add(UploadProfilePicture()),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                profilePictureText,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ],
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? Colors.white : const Color(0xff2D3135),
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date['day']!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  date['date']!,
                  style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? Colors.white : const Color(0xff2D3135),
                width: 2.0,
              ),
            ),
            child: Text(
              time,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
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

    bool isButtonEnabled(ScheduleCallLoaded state) {
      return topicController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          state.selectedCategory.isNotEmpty &&
          state.selectedDateIndex != -1 &&
          state.selectedTimeIndex != -1 &&
          state.profilePicture != null;
    }

    return BlocBuilder<ScheduleLiveBloc, ScheduleCallState>(
      builder: (context, state) {
        bool isEnabled = state is ScheduleCallLoaded && isButtonEnabled(state);
        String getMissingFieldsMessage(ScheduleCallLoaded state) {
          List<String> missingFields = [];

          if (topicController.text.isEmpty) {
            missingFields.add("Topic");
          }
          if (descriptionController.text.isEmpty) {
            missingFields.add("Description");
          }
          if (state.selectedCategory.isEmpty) {
            missingFields.add("Category");
          }
          if (state.selectedDateIndex == null) {
            missingFields.add("Date");
          }
          if (state.selectedTimeIndex == null) {
            missingFields.add("Time");
          }
          if (state.profilePicture == null) {
            missingFields.add("Profile Picture");
          }

          return missingFields.isNotEmpty ? missingFields.join(', ') : "";
        }

        return GestureDetector(
          onTap: () {
            if (!isEnabled) {
              final message = getMissingFieldsMessage(
                state as ScheduleCallLoaded,
              );
              BaseUtil.showNegativeAlert(
                "Please complete the following fields",
                message,
              );
            }
          },
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    final topic = topicController.text;
                    final description = descriptionController.text;
                    if (widget.id != null) {
                      bloc.add(UpdateEvent(widget.id!, topic, description));
                    } else {
                      bloc.add(ScheduleEvent(topic, description));
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.white38,
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Schedule Live',
              style: TextStyle(
                color: Color(0xff3F4748),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
