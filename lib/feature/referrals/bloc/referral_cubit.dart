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
    _loadContacts();
  }

  final ReferralDetailsViewModel model;

  Future<void> checkPermission() async {
    PermissionStatus hasPermission = await Permission.contacts.status;

    if (hasPermission == PermissionStatus.granted) {
      await getContacts();
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

  Future<void> getContacts() async {
    emit(ContactsLoading());

    if (model.contactsList != null && model.contactsList!.isNotEmpty) {
      emit(ContactsLoaded(model.contactsList!));
      getRegisteredUser();
      return;
    }

    try {
      final contacts = await model.loadContacts();

      log("Contacts length ${contacts.length}", name: 'ReferralDetailsScreen');

      if (contacts.isNotEmpty) {
        emit(ContactsLoaded(contacts));
        getRegisteredUser();
      } else {
        emit(ContactsError('No contacts found!'));
      }
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _loadContacts() async {
    if (model.contactsList != null && model.contactsList!.isNotEmpty) {
      emit(ContactsLoaded(model.contactsList!));
      getRegisteredUser();
      return;
    }
  }

  Future<void> getRegisteredUser() async {
    final ReferralRepo referralRepo = locator<ReferralRepo>();

    var currentState = state;

    if (currentState is ContactsLoaded) {
      List<String> registeredUser = [];
      await referralRepo.getRegisteredUsers(model.phoneNumbers).then((res) {
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
}