part of 'live_details_bloc.dart';

sealed class ScheduleCallState extends Equatable {
  const ScheduleCallState();
}

class ScheduleCallInitial extends ScheduleCallState {
  @override
  List<Object?> get props => const [];
}

class ScheduleCallLoading extends ScheduleCallState {
  @override
  List<Object?> get props => const [];
}

class ScheduleCallLoaded extends ScheduleCallState {
  final List<String> categories;
  final List<Map<String, String>> dates;
  final List<Map<String, String>> times;
  final String selectedCategory;
  final int? selectedDateIndex;
  final int? selectedTimeIndex;
  final XFile? profilePicture;

  const ScheduleCallLoaded({
    required this.categories,
    required this.dates,
    required this.times,
    required this.selectedCategory,
    required this.selectedDateIndex,
    required this.selectedTimeIndex,
    this.profilePicture,
  });
  ScheduleCallLoaded copyWith({
    List<String>? categories,
    List<Map<String, String>>? dates,
    List<Map<String, String>>? times,
    String? selectedCategory,
    int? selectedDateIndex,
    int? selectedTimeIndex,
    XFile? profilePicture,
  }) {
    return ScheduleCallLoaded(
      categories: categories ?? this.categories,
      dates: dates ?? this.dates,
      times: times ?? this.times,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedTimeIndex: selectedTimeIndex ?? this.selectedTimeIndex,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        dates,
        times,
        selectedCategory,
        selectedDateIndex,
        selectedTimeIndex,
        profilePicture,
      ];
}

class ScheduleCallSuccess extends ScheduleCallState {
  final String message;
  final String date;
  const ScheduleCallSuccess(this.message,this.date);
  @override
  List<Object?> get props => [message,date];
}

class ScheduleCallFailure extends ScheduleCallState {
  final String error;
  const ScheduleCallFailure(this.error);
  @override
  List<Object?> get props => [error];
}
