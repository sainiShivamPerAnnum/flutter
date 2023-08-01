import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/core/model/contact_model.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  ReferralCubit(this.model) : super(ReferralInitial()) {
    // _loadContacts();
  }

  final ReferralDetailsViewModel model;

  Future<void> checkPermission({bool fromRefresh = false}) async {
    PermissionStatus hasPermission = await Permission.contacts.status;

    if (hasPermission == PermissionStatus.granted) {
      await getContacts(fromRefresh: fromRefresh);
    } else {
      emit(NoPermissionState());
    }
  }

  Future<void> requestPermission() async {
    log('requestPermission', name: 'ReferralDetailsScreen');
    AppState.backButtonDispatcher?.didPopRoute();
    PermissionStatus permissionStatus = await Permission.contacts.request();
    log('Permission status: $permissionStatus');
    if (permissionStatus.isGranted) {
      await getContacts();
    } else if (permissionStatus.isPermanentlyDenied) {
      // Show a dialog or screen explaining why the permission is required
      // and direct the user to the app settings to manually enable the permission
      await openAppSettings(); // This opens the app settings page
    } else {
      emit(NoPermissionState());
    }
  }

  Future<void> getContacts({bool fromRefresh = false}) async {
    emit(ContactsLoading());

    if (model.contactsList != null && model.contactsList!.isNotEmpty) {
      emit(ContactsLoaded(model.contactsList!));
      getRegisteredUser(fromRefresh: fromRefresh);
      return;
    }

    try {
      final contacts = await model.loadContacts();

      log("Contacts length ${contacts.length}", name: 'ReferralDetailsScreen');

      if (contacts.isNotEmpty) {
        emit(ReferralInitial());
        emit(ContactsLoaded(contacts));
        getRegisteredUser(fromRefresh: fromRefresh);
      } else {
        emit(ContactsError('No contacts found!'));
      }
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  // Future<void> _loadContacts() async {
  //   if (model.contactsList != null && model.contactsList!.isNotEmpty) {
  //     emit(ContactsLoaded(model.contactsList!));
  //     getRegisteredUser();
  //     return;
  //   }
  // }

  Future<void> getRegisteredUser({bool fromRefresh = false}) async {
    final ReferralRepo referralRepo = locator<ReferralRepo>();

    var currentState = state;

    if (currentState is ContactsLoaded) {
      List<String> registeredUser = [];
      await Future.delayed(const Duration(seconds: 5));

      await referralRepo
          .getRegisteredUsers(model.phoneNumbers, forceRefresh: fromRefresh)
          .then((res) {
        if (res.isSuccess()) {
          registeredUser = res.model?.data ?? [];

          // if registeredUser contains contact.phoneNumber
          // then set contact.isRegistered = true
          // else set contact.isRegistered = false
          // emit currentState with updated contacts

          for (final contact in currentState.contacts) {
            if (registeredUser.contains(contact.phoneNumber)) {
              contact.isRegistered = true;
            } else {
              contact.isRegistered = false;
            }
          }
          emit(ReferralInitial());
          emit(currentState.copyWith(contacts: currentState.contacts));
        }
      });
    }
  }

  Future<void> refreshContacts() async {
    var currentState = state;

    if (currentState is ContactsLoaded) {
      emit(ReferralInitial());
      emit(currentState.copyWith(contacts: currentState.contacts));
    }
  }

// void searchContacts(String query) {
//   log('searchContacts: $query', name: 'ReferralDetailsScreen');
//
//   var currentState = state;
//   if (currentState is ContactsLoaded) {
//     List<Contact> filteredContacts = currentState.contacts
//         .where((contact) =>
//             contact.displayName.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//
//     log('filteredContacts: ${filteredContacts.length}', name: 'ReferralDetailsScreen');
//
//     emit(ReferralInitial());
//
//     emit(currentState.copyWith(contacts: filteredContacts));
//   }
// }
}
