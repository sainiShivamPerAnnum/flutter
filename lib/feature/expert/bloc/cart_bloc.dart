import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/util/locator.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ExpertsRepository _expertsRepository;
  CartBloc(
    this._expertsRepository,
  ) : super(const InitialCartState()) {
    on<InitalCart>(_getInitialCart);
    on<AddToCart>(_addToCart);
    on<ClearCart>(_clearCart);
  }
  FutureOr<void> _getInitialCart(
    InitalCart event,
    Emitter<CartState> emitter,
  ) async {
    final data = await _expertsRepository.getFromCart();
    if (data.isSuccess() && data.model != null) {
      if (data.model!.isAvailable) {
        emitter(
          CartItemAdded(
            advisor: Expert(
              advisorId: data.model!.advisorId,
              name: data.model!.advisorName,
              experience: '',
              rating: 0,
              expertise: '',
              qualifications: '',
              rate: 0,
              rateNew: '',
              image: data.model!.advisorImg,
              isFree: false,
            ),
            selectedDate: data.model!.fromTime,
            selectedTime: data.model!.fromTime,
            selectedDuration: data.model!.duration,
          ),
        );
      } else {
        emitter(
          CartItemAdded(
            advisor: Expert(
              advisorId: data.model!.advisorId,
              name: data.model!.advisorName,
              experience: '',
              rating: 0,
              expertise: '',
              qualifications: '',
              rate: 0,
              rateNew: '',
              image: data.model!.advisorImg,
              isFree: false,
            ),
          ),
        );
      }
    }
  }

  FutureOr<void> _addToCart(
    AddToCart event,
    Emitter<CartState> emitter,
  ) async {
    DateTime? startTime;
    DateTime? endTime;
    if (event.selectedDate != null &&
        event.selectedTime != null &&
        event.selectedDuration != null) {
      startTime = DateTime.parse(event.selectedTime!);
      endTime = startTime.add(Duration(minutes: event.selectedDuration!));
      endTime = endTime.toUtc();
    }
    if (startTime != null &&
        endTime != null &&
        event.selectedDuration != null) {
      unawaited(
        _expertsRepository.saveToCart(
          advisorId: event.advisor.advisorId,
          startTime: startTime.toIso8601String(),
          endTime: endTime.toIso8601String(),
          duration: event.selectedDuration,
        ),
      );
    } else {
      unawaited(
        _expertsRepository.saveToCart(
          advisorId: event.advisor.advisorId,
        ),
      );
    }
    emitter(
      CartItemAdded(
        advisor: event.advisor,
        selectedDate: event.selectedDate,
        selectedTime: event.selectedTime,
        selectedDuration: event.selectedDuration,
      ),
    );
    locator<AnalyticsService>().updateUserProperty(
      key: "Advisor in cart",
      value: event.advisor.name,
    );
  }

  FutureOr<void> _clearCart(
    ClearCart event,
    Emitter<CartState> emitter,
  ) async {
    unawaited(
      _expertsRepository.deleteFromCart(),
    );
    emitter(
      const InitialCartState(),
    );
    locator<AnalyticsService>().updateUserProperty(
      key: "Advisor in cart",
      value: '',
    );
  }
}
