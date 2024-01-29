part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveStatee extends Equatable {
  int currentPage;
  SubscriptionModel? activeSubscription;
  bool isFetchingTransactions;
  AutosaveStatee({
    this.currentPage = 0,
    this.activeSubscription,
    this.isFetchingTransactions = false,
  });

  AutosaveStatee copyWith({required bool visible}) {
    return AutosaveStatee();
  }

  @override
  List<Object> get props => [currentPage, isFetchingTransactions];
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
