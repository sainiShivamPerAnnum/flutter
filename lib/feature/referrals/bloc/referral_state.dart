part of 'referral_cubit.dart';

@immutable
abstract class ReferralState {}

class ReferralInitial extends ReferralState {}

class NoPermissionState extends ReferralState {}

class ContactsLoading extends ReferralState {}

class ContactsLoaded extends ReferralState {
  final List<Contact> contacts;

  ContactsLoaded(this.contacts);

  ContactsLoaded copyWith({
    List<Contact>? contacts,
  }) {
    return ContactsLoaded(
      contacts ?? this.contacts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactsLoaded && listEquals(other.contacts, contacts);
  }

  @override
  int get hashCode => contacts.hashCode;
}

class ContactsError extends ReferralState {
  final String message;

  ContactsError(this.message);
}
