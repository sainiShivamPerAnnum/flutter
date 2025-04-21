part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
}

class InitialCartState extends CartState {
  const InitialCartState();
  @override
  List<Object?> get props => const [];
}

class CartItemAdded extends CartState {
  final Expert advisor;
  final String? selectedDate;
  final String? selectedTime;
  final int? selectedDuration;

  const CartItemAdded({
    required this.advisor,
    this.selectedDate,
    this.selectedTime,
    this.selectedDuration,
  });
  CartItemAdded copyWith({
    Expert? advisor,
    String? selectedDate,
    String? selectedTime,
    int? selectedDuration,
  }) {
    return CartItemAdded(
      advisor: advisor ?? this.advisor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }

  @override
  List<Object?> get props => [
        advisor,
        selectedDate,
        selectedTime,
        selectedDuration,
      ];
}
