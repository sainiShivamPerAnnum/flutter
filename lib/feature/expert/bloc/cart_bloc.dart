import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
// import 'package:felloapp/core/repository/experts_repo.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // final ExpertsRepository _expertsRepository;
  CartBloc(
      // this._expertsRepository,
      )
      : super(const InitialCartState()) {
    on<AddToCart>(_addToCart);
    on<ClearCart>(_clearCart);
  }
  FutureOr<void> _addToCart(
    AddToCart event,
    Emitter<CartState> emitter,
  ) async {
    emitter(
      CartItemAdded(
        advisor: event.advisor,
        selectedDate: event.selectedDate,
        selectedTime: event.selectedTime,
        selectedDuration: event.selectedDuration,
      ),
    );
  }

  FutureOr<void> _clearCart(
    ClearCart event,
    Emitter<CartState> emitter,
  ) async {
    emitter(
      const InitialCartState(),
    );
  }
}
