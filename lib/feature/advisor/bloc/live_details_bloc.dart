import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
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
        selectedDateIndex: 0,
        selectedTimeIndex: 0,
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
    emit(ScheduleCallLoading());
    final currentState = state as ScheduleCallLoaded;

    try {
      DateTime selectedDate = DateTime.parse(
        currentState.dates[currentState.selectedDateIndex]['dateTime']!,
      );
      DateTime selectedTime = DateFormat("h:mm a")
          .parse(currentState.times[currentState.selectedTimeIndex]['TimeUI']!);
      DateTime eventDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final payload = {
        "id": event is UpdateEvent ? event.id : "event-123",
        "topic": event.topic,
        "description": event.description,
        "categories": [currentState.selectedCategory],
        "coverImage": currentState.profilePicture?.path ?? 'example.jpg',
        "eventTimeSlot": eventDateTime.toIso8601String(),
        "duration": 90,
        "advisorId": "advisor-123",
        "status": "live",
        "totalLiveCount": 100,
        "broadcasterLive": "https://example.com/live/broadcast",
        "viewerLink": "https://example.com/viewerLink",
        "100msEventId": "100ms-event-123",
        "token": "token-123",
      };

      final response = event is UpdateEvent
          ? await _advisorRepo.putEvent(payload)
          : await _advisorRepo.saveEvent(payload);

      if (response.isSuccess()) {
        emit(const ScheduleCallSuccess('Event scheduled successfully!'));
      } else {
        emit(
          ScheduleCallFailure(
            response.errorMessage ?? 'Failed to schedule event',
          ),
        );
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
    for (int i = 0; i < numberOfDays; i++) {
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
