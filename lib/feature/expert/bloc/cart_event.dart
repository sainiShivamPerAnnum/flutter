part of 'cart_bloc.dart';

sealed class CartEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final Expert advisor;
  final String? selectedDate;
  final String? selectedTime;
  final int? selectedDuration;

  const AddToCart({
    required this.advisor,
    this.selectedDate,
    this.selectedTime,
    this.selectedDuration,
  });
}

class ClearCart extends CartEvent {}
