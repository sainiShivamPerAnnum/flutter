part of 'live_details_bloc.dart';

sealed class ScheduleCallEvent {
  const ScheduleCallEvent();
}

class LoadCategories extends ScheduleCallEvent {}

class SelectCategory extends ScheduleCallEvent {
  final String category;
  SelectCategory(this.category);
}

class SelectDate extends ScheduleCallEvent {
  final int index;
  SelectDate(this.index);
}

class SelectTime extends ScheduleCallEvent {
  final int index;
  SelectTime(this.index);
}

class UploadProfilePicture extends ScheduleCallEvent {}

class ScheduleEvent extends ScheduleCallEvent {
  final String topic;
  final String description;
  ScheduleEvent(this.topic, this.description);
}

class UpdateEvent extends ScheduleCallEvent {
  final String id;
  final String topic;
  final String description;
  UpdateEvent(this.id, this.topic, this.description);
}

class LoadCategoriesWithPrefill extends ScheduleCallEvent {
  final String? title;
  final String? description;
  final String? selectedCategory;
  final String? timeSlot;

  LoadCategoriesWithPrefill({
    required this.title,
    required this.description,
    required this.selectedCategory,
    required this.timeSlot,
  });
}
