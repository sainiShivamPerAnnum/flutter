import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

part 'live_details_event.dart';
part 'live_details_state.dart';

class ScheduleLiveBloc extends Bloc<ScheduleCallEvent, ScheduleCallState> {
  final AdvisorRepo _advisorRepo;
  ScheduleLiveBloc(this._advisorRepo) : super(ScheduleCallInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<ScheduleEvent>(_onScheduleEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<LoadCategoriesWithPrefill>(_onPreFill);
  }
  FutureOr<void> _onPreFill(
    LoadCategoriesWithPrefill event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final categories = [
      "Personal Finance",
      "Mutual Funds",
      "Retirement Planning",
      "Loan Expert",
      "Tax and Compliance",
      "Stock Market",
      "Savings and Planning",
      "Alternate Assets",
    ];
    final dates = generateDates(5);
    final times = [
      {'TimeUI': '10:00 AM'},
      {'TimeUI': '11:00 AM'},
      {'TimeUI': '12:00 PM'},
      {'TimeUI': '1:00 PM'},
      {'TimeUI': '2:00 PM'},
      {'TimeUI': '3:00 PM'},
      {'TimeUI': '4:00 PM'},
      {'TimeUI': '5:00 PM'},
      {'TimeUI': '6:00 PM'},
      {'TimeUI': '7:00 PM'},
      {'TimeUI': '8:00 PM'},
    ];
    if (event.timeSlot != null) {
      emit(ScheduleCallLoading());
      int? selectedDateIndex;
      int? selectedTimeIndex;
      final DateTime parsedDateTime = DateTime.parse(event.timeSlot!);

      selectedDateIndex = dates.indexWhere((date) {
        final dateInList = DateFormat("MMMM d, yyyy").parse(date['dateTime']!);
        return dateInList.year == parsedDateTime.year &&
            dateInList.month == parsedDateTime.month &&
            dateInList.day == parsedDateTime.day;
      });

      selectedTimeIndex = times.indexWhere((time) {
        return time['TimeUI'] == DateFormat('h:mm a').format(parsedDateTime);
      });
      emit(
        ScheduleCallLoaded(
          categories: categories,
          dates: dates,
          times: times,
          selectedCategory: event.selectedCategory ?? categories[0],
          selectedDateIndex: selectedDateIndex,
          selectedTimeIndex: selectedTimeIndex,
        ),
      );
    }
  }

  FutureOr<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ScheduleCallState> emit,
  ) async {
    emit(ScheduleCallLoading());

    // Generate categories, dates, and times
    final categories = [
      "Personal Finance",
      "Mutual Funds",
      "Retirement Planning",
      "Loan Expert",
      "Tax and Compliance",
      "Stock Market",
      "Savings and Planning",
      "Alternate Assets",
    ];

    final dates = generateDates(5);
    final times = [
      {'TimeUI': '10:00 AM'},
      {'TimeUI': '11:00 AM'},
      {'TimeUI': '12:00 PM'},
      {'TimeUI': '1:00 PM'},
      {'TimeUI': '2:00 PM'},
      {'TimeUI': '3:00 PM'},
      {'TimeUI': '4:00 PM'},
      {'TimeUI': '5:00 PM'},
      {'TimeUI': '6:00 PM'},
      {'TimeUI': '7:00 PM'},
      {'TimeUI': '8:00 PM'},
    ];

    emit(
      ScheduleCallLoaded(
        categories: categories,
        dates: dates,
        times: times,
        selectedCategory: categories[0],
        selectedDateIndex: null,
        selectedTimeIndex: null,
      ),
    );
  }

  FutureOr<void> _onSelectCategory(
    SelectCategory event,
    Emitter<ScheduleCallState> emit,
  ) {
    final currentState = state as ScheduleCallLoaded;
    emit(currentState.copyWith(selectedCategory: event.category));
  }

  FutureOr<void> _onSelectDate(
    SelectDate event,
    Emitter<ScheduleCallState> emit,
  ) {
    final currentState = state as ScheduleCallLoaded;
    emit(currentState.copyWith(selectedDateIndex: event.index));
  }

  FutureOr<void> _onSelectTime(
    SelectTime event,
    Emitter<ScheduleCallState> emit,
  ) {
    final currentState = state as ScheduleCallLoaded;
    emit(currentState.copyWith(selectedTimeIndex: event.index));
  }

  FutureOr<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final picker = ImagePicker();
    XFile? profilePicture = await picker.pickImage(source: ImageSource.gallery);
    if (profilePicture != null) {
      final currentState = state as ScheduleCallLoaded;
      emit(currentState.copyWith(profilePicture: profilePicture));
    }
  }

  FutureOr<void> _onScheduleEvent(
    ScheduleEvent event,
    Emitter<ScheduleCallState> emit,
  ) async {
    await _handleEventCreation(event, emit);
  }

  FutureOr<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<ScheduleCallState> emit,
  ) async {
    await _handleEventCreation(event, emit);
  }

  Future<void> _handleEventCreation(
    event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final currentState = state as ScheduleCallLoaded;
    emit(ScheduleCallLoading());
    try {
      String date =
          currentState.dates[currentState.selectedDateIndex!]['dateTime']!;
      DateTime parsedDateTime =
          DateFormat("MMMM d, yyyy hh:mm:ss a").parse(date);
      String dateOnlyString = DateFormat("MMMM d, yyyy").format(parsedDateTime);
      String time =
          currentState.times[currentState.selectedTimeIndex!]['TimeUI']!;
      String dateTimeString = "$dateOnlyString $time";
      DateTime dateTime =
          DateFormat("MMMM d, yyyy hh:mm a").parse(dateTimeString);
      if (event is UpdateEvent) {
        String? predignedUrl;
        String? uploadUrl;
        if (currentState.profilePicture != null) {
          final res = await _advisorRepo.getPresignedUrl(
            format: currentState.profilePicture!.name.split('.').last,
          );
          predignedUrl = res.model!;
        }
        if (predignedUrl != null) {
          uploadUrl = predignedUrl.split('?')[0];
          await _advisorRepo.putToPresignedUrl(
            url: predignedUrl,
            file: currentState.profilePicture!,
          );
        }
        final payload = {};

        if (event.topic.isNotEmpty) {
          payload["topic"] = event.topic;
        }
        if (event.description.isNotEmpty) {
          payload["description"] = event.description;
        }
        if (currentState.selectedCategory != null) {
          payload["categories"] = [currentState.selectedCategory];
        }
        if (uploadUrl != null && uploadUrl.isNotEmpty) {
          payload["coverImage"] = uploadUrl;
        }
        if (dateTime != null) {
          payload["eventTimeSlot"] = dateTime.toString();
        }
        payload["duration"] = 60;
        final response = await _advisorRepo.putEvent(payload, event.id);
        if (response.isSuccess()) {
          emit(
            ScheduleCallSuccess(
              'Event updated successfully!',
              dateTime.toString(),
            ),
          );
        } else {
          emit(
            ScheduleCallFailure(
              response.errorMessage ?? 'Failed to update event',
            ),
          );
        }
      } else {
        final predignedUrl = await _advisorRepo.getPresignedUrl(
          format: currentState.profilePicture!.name.split('.').last,
        );
        if (predignedUrl.model != null) {
          final uploadUrl = predignedUrl.model!.split('?')[0];
          await _advisorRepo.putToPresignedUrl(
            url: predignedUrl.model!,
            file: currentState.profilePicture!,
          );
          final payload = {
            "topic": event.topic,
            "description": event.description,
            "categories": [currentState.selectedCategory],
            "coverImage": uploadUrl,
            "eventTimeSlot": dateTime.toString(),
            "duration": 60,
          };
          final response = await _advisorRepo.saveEvent(payload);
          if (response.isSuccess()) {
            emit(
              ScheduleCallSuccess(
                'Event scheduled successfully!',
                dateTime.toString(),
              ),
            );
          } else {
            emit(
              ScheduleCallFailure(
                response.errorMessage ?? 'Failed to schedule event',
              ),
            );
          }
          unawaited(_advisorRepo.getEvents());
        }
      }
    } catch (error) {
      emit(ScheduleCallFailure(error.toString()));
    }
  }

  List<Map<String, String>> generateDates(int numberOfDays) {
    final List<Map<String, String>> dates = [];
    final DateFormat dayFormat =
        DateFormat('E'); // Format for day (e.g., Mon, Tue)
    final DateFormat dateFormat =
        DateFormat('d'); // Format for day of the month (e.g., 12, 13)
    final DateFormat dateTimeFormat = DateFormat();
    for (int i = 1; i < numberOfDays + 1; i++) {
      DateTime currentDate = DateTime.now().add(Duration(days: i));
      dates.add({
        'day': dayFormat.format(currentDate), // 'Thu', 'Fri', etc.
        'date': dateFormat.format(currentDate),
        'dateTime': dateTimeFormat.format(currentDate), // '12', '13', etc.
      });
    }

    return dates;
  }
}
