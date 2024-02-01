part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  int currentPage;
  AllSubscriptionModel? activeSubscription;
  bool isFetchingTransactions;
  AutosaveCubitState({
    this.currentPage = 0,
    this.activeSubscription,
    this.isFetchingTransactions = false,
  });

  AutosaveCubitState copyWith({required bool visible}) {
    return AutosaveCubitState();
  }
}

class CalculatorState extends AutoSaveSetupState {
  int sipAmount;
  int timePeriod;
  double returnPercentage;
  int maxSipValue;
  int minSipValue;
  int maxTimePeriod;
  int minTimePeriod;

  CalculatorState(
      {this.sipAmount = 500,
      this.timePeriod = 5,
      this.returnPercentage = 10,
      this.maxSipValue = 5000,
      this.minSipValue = 100,
      this.maxTimePeriod = 10,
      this.minTimePeriod = 1});
  CalculatorState copyWith(
      {int? sipAmount,
      int? timePeriod,
      double? returnPercentage,
      int? maxSipValue,
      int? minSipValue,
      int? maxTimePeriod,
      int? minTimePeriod}) {
    return CalculatorState(
      sipAmount: sipAmount ?? this.sipAmount,
      timePeriod: timePeriod ?? this.timePeriod,
      returnPercentage: returnPercentage ?? this.returnPercentage,
      maxSipValue: maxSipValue ?? this.maxSipValue,
      minSipValue: minSipValue ?? this.minSipValue,
      maxTimePeriod: maxTimePeriod ?? this.maxTimePeriod,
      minTimePeriod: minTimePeriod ?? this.minTimePeriod,
    );
  }
}

// class ContactsLoaded extends AutoSaveSetupState {
//   final List<Contact> contacts;

//   ContactsLoaded(this.contacts);

//   ContactsLoaded copyWith({
//     List<Contact>? contacts,
//   }) {
//     return ContactsLoaded(
//       contacts ?? this.contacts,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is ContactsLoaded && listEquals(other.contacts, contacts);
//   }

//   @override
//   int get hashCode => contacts.hashCode;
// }
