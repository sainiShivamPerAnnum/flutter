part of 'referral_cubit.dart';

@immutable
abstract class ReferralState {}

class ReferralInitial extends ReferralState {}

class NoPermissionState extends ReferralState {}

class ContactsLoading extends ReferralState {}

class ContactsLoaded extends ReferralState {
  final List<Contact> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ReferralState {
  final String message;

  ContactsError(this.message);
}
