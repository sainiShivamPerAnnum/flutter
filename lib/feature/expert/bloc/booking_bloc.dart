import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:felloapp/core/model/bookings/payment_response.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/upi_pay.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ExpertsRepository _expertsRepository;
  final SaveViewModel _saveViewModel;
  final CustomLogger _logger;
  BookingBloc(
    this._expertsRepository,
    this._logger,
    this._saveViewModel,
  ) : super(const LoadingBookingsData()) {
    on<LoadBookingDates>(_onLoadBookingDates);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<GetPricing>(_getPricing);
    on<SelectDuration>(_onSelectDuration);
    on<EditBooking>(_editBooking);
  }
  FutureOr<void> _onLoadBookingDates(
    LoadBookingDates event,
    Emitter<BookingState> emitter,
  ) async {
    final currentSelectedDate = (state is BookingsLoaded)
        ? (state as BookingsLoaded).selectedDate
        : null;
    // emitter(const LoadingBookingsData());

    final data = await _expertsRepository.getExpertAvailableSlots(
      advisorId: event.advisorId,
      duration: event.duration,
    );
    final availableDates = data.model?.slots?.keys.toList() ?? [];
    String? selectedDate;

    if (event.scheduledOn != null) {
      final formattedScheduledOn = DateFormat('yyyy-MM-dd').format(
        event.scheduledOn!,
      );

      if (availableDates.contains(formattedScheduledOn)) {
        selectedDate = formattedScheduledOn;
      } else if (availableDates.isNotEmpty) {
        selectedDate = availableDates.first;
      }
    } else if (availableDates.isNotEmpty) {
      selectedDate = availableDates.first;
    }

    if (availableDates.isNotEmpty) {
      emitter(
        BookingsLoaded(
          advisorId: event.advisorId,
          schedule: data.model,
          selectedDate: currentSelectedDate ?? selectedDate,
          selectedDuration: event.duration,
          isFree: data.model?.hasFreeCall ?? false,
        ),
      );
    } else {
      emitter(
        BookingsLoaded(
          schedule: data.model,
          advisorId: event.advisorId,
          isFree: data.model?.hasFreeCall ?? false,
        ),
      );
    }
  }

  void _onSelectDate(SelectDate event, Emitter<BookingState> emitter) {
    if (state is BookingsLoaded) {
      emitter(
        (state as BookingsLoaded).copyWith(
          selectedDate: event.selectedDate,
          selectedTime: null,
        ),
      );
    }
  }

  void _onSelectDuration(SelectDuration event, Emitter<BookingState> emitter) {
    if (state is BookingsLoaded) {
      add(
        LoadBookingDates(
          (state as BookingsLoaded).advisorId,
          event.selectDuration,
          null,
        ),
      );
    }
  }

  void _onSelectTime(SelectTime event, Emitter<BookingState> emitter) {
    if (state is BookingsLoaded) {
      emitter(
        (state as BookingsLoaded).copyWith(
          selectedTime: event.selectedTime,
        ),
      );
    }
  }

  Future<void> _getPricing(
    GetPricing event,
    Emitter<BookingState> emitter,
  ) async {
    emitter(const LoadingBookingsData());

    // Make your API call here
    final response = await _expertsRepository.getPricing(
      advisorId: event.advisorId,
      duration: event.duration,
    );

    if (response.isSuccess()) {
      emitter(
        PricingData(
          advisorId: event.advisorId,
          advisorName: event.advisorName,
          time: event.selectedTime,
          date: event.selectedDate,
          price: response.model?.price ?? 0,
          duration: event.duration,
          gst: response.model?.gst ?? 0,
          totalPayable: response.model?.totalPrice ?? 0,
        ),
      );
    } else {
      // Handle failure case, if necessary
      emitter(const BookingError("Failed to submit booking"));
      _logger.d('Failed to submit booking');
    }
  }

  Future<void> _editBooking(
    EditBooking event,
    Emitter<BookingState> emitter,
  ) async {
    emitter(const LoadingBookingsData());
    final response = await _expertsRepository.updateBooking(
      bookingId: event.bookingId,
      duration: event.duration,
      selectedDate: event.selectedDate,
    );

    if (response.isSuccess()) {
      await AppState.backButtonDispatcher!.didPopRoute();
      BaseUtil.showPositiveAlert(
        'Booking updated Successfully!',
        "New date is ${BaseUtil.formatDateTime(
          DateTime.parse(event.selectedDate),
        )}",
      );
      unawaited(_saveViewModel.getUpcomingBooking());
    } else {
      _logger.d('Failed to submit booking');
      await AppState.backButtonDispatcher!.didPopRoute();
      BaseUtil.showNegativeAlert(
        'Updating booking Failed!',
        response.errorMessage ?? 'Error',
      );
    }
  }
}

class PaymentBloc extends Bloc<BookingEvent, PaymentState> {
  final ExpertsRepository _expertsRepository;
  final CustomLogger _logger;
  PaymentBloc(
    this._expertsRepository,
    this._logger,
  ) : super(const MandateInitialState()) {
    on<LoadPSPApps>(_onLoadPSPApps);
    on<SubmitPaymentRequest>(_onSubmitPayment);
  }
  FutureOr<void> _onLoadPSPApps(
    LoadPSPApps event,
    Emitter<PaymentState> emitter,
  ) async {
    emitter(const ListingPSPApps());
    final apps = await getUPIApps();
    emitter(ListedPSPApps(apps));
  }

  FutureOr<void> _onSubmitPayment(
    SubmitPaymentRequest event,
    Emitter<PaymentState> emitter,
  ) async {
    emitter(const SubmittingPayment());
    final response = await _expertsRepository.submitBooking(
      advisorId: event.advisorId,
      amount: event.amount,
      fromTime: event.fromTime,
      duration: event.duration,
      appuse: event.appuse?.upiApplication.appName ?? '',
      isFree: event.isFree,
    );
    final data = response.model?.data;
    final paymentId = data?.paymentId;
    final intentData = data?.intent;
    if (response.isSuccess() && event.isFree) {
      emitter(SubmittedPayment(data: response.model!));
    } else if (response.isSuccess() &&
        intentData != null &&
        paymentId != null) {
      if (intentData.isNotEmpty) {
        await _openPSPApp(intentData, event.appuse!.packageName);
      }
      emitter(SubmittedPayment(data: response.model!));
    } else {
      emitter(SubmittingPaymentFailed(response.errorMessage!));
      await AppState.backButtonDispatcher!.didPopRoute();
      BaseUtil.showNegativeAlert(
        'Failed to collect payment',
        response.errorMessage,
      );
    }
  }

  /// Launches the psp and wait until it re-opens the application.
  ///
  /// In case of android it uses `startActivityForResult` method to retrieve
  /// result back out of the launching activity and wait until result is
  /// completed.
  ///
  /// In case of ios there is no such way to get result back out of view/activity
  /// ,so in that case it will poll async for duration 1 sec until app is opened
  /// again and then after it will continue the execution.
  Future<void> _openPSPApp(String intentUrl, String package) async {
    try {
      if (Platform.isIOS) {
        final result = await BaseUtil.launchUrl(intentUrl);
        if (result) {
          while (WidgetsBinding.instance.lifecycleState !=
              AppLifecycleState.resumed) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
        return;
      } else {
        const platform = MethodChannel("methodChannel/upiIntent");
        await platform.invokeMethod('initiatePsp', {
          'redirectUrl': intentUrl,
          'packageName': package,
        });
      }
    } catch (e) {
      _logger.d('Failed launch intent url');
    }
  }

  Future<List<ApplicationMeta>> getUPIApps() async {
    S locale = locator<S>();
    List<ApplicationMeta> appMetaList = [];

    if (Platform.isIOS) {
      const platform = MethodChannel("methodChannel/deviceData");
      try {
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps_booking)
            .contains('E')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "phonepe"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.phonePe));
          }
        }
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps_booking)
            .contains('P')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "paytm"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.paytm));
          }
        }
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps_booking)
            .contains('G')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "gpay"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.googlePay));
          }
        }
        return appMetaList;
      } on PlatformException catch (e) {
        _logger.d('Failed to fetch installed applications on ios $e');
        return appMetaList;
      }
    } else {
      try {
        List<ApplicationMeta> allUpiApps =
            await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all,
        );

        for (final element in allUpiApps) {
          if (element.upiApplication.appName == "Paytm" &&
              AppConfig.getValue<String>(
                AppConfigKey.enabled_psp_apps_booking,
              ).contains('P')) {
            appMetaList.add(element);
          }
          if (element.upiApplication.appName == "PhonePe" &&
              AppConfig.getValue<String>(
                AppConfigKey.enabled_psp_apps_booking,
              ).contains('E')) {
            appMetaList.add(element);
          }

          // debug assertion to avoid this in production.
          assert(() {
          if (element.upiApplication.appName == "PhonePe Simulator" &&
              AppConfig.getValue<String>(
                AppConfigKey.enabled_psp_apps_booking,
              ).contains('E')) {
            appMetaList.add(element);
          }
            return true;
          }());

          if (element.upiApplication.appName == "PhonePe Preprod" &&
              AppConfig.getValue<String>(
                AppConfigKey.enabled_psp_apps_booking,
              ).contains('E')) {
            appMetaList.add(element);
          }

          if (element.upiApplication.appName == "Google Pay" &&
              AppConfig.getValue<String>(
                AppConfigKey.enabled_psp_apps_booking,
              ).contains('G')) {
            appMetaList.add(element);
          }
        }

        return appMetaList;
      } catch (e) {
        _logger.d('Failed to list all psp app due to error: $e');

        BaseUtil.showNegativeAlert(
          locale.unableToGetUpi,
          locale.tryLater,
        );

        return [];
      }
    }
  }
}
