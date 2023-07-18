import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/core/model/contact_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  ReferralCubit() : super(ReferralInitial());

  Future<void> checkPermission() async {
    PermissionStatus hasPermission = await Permission.contacts.status;

    if (hasPermission == PermissionStatus.granted) {
      await getContacts();
    } else {
      emit(NoPermissionState());
    }
  }

  Future<void> requestPermission() async {
    AppState.backButtonDispatcher?.didPopRoute();
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      await getContacts();
    }
  }

  Future<void> getContacts() async {
    emit(ContactsLoading());
    try {
      final contacts = await _loadContacts();

      log("Contacts length ${contacts.length}", name: 'ReferralDetailsScreen');

      if (contacts.isNotEmpty) {
        emit(ContactsLoaded(contacts));
      } else {
        emit(ContactsError('No contacts found!'));
      }
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<List<Contact>> _loadContacts() async {
    const MethodChannel methodChannel = MethodChannel('methodChannel/contact');

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final List<dynamic>? contacts =
          await methodChannel.invokeMethod<List<dynamic>>('getContacts');
      if (contacts != null) {
        // Parse the contacts data
        final Set<String> uniquePhoneNumbers = {};
        final List<Contact> parsedContacts = [];

        for (final contactData in contacts) {
          final phoneNumber = contactData['phoneNumber'];
          if (phoneNumber == null) continue;

          final filteredPhoneNumber = _applyFilters(phoneNumber);

          if (filteredPhoneNumber == null) continue;

          if (!uniquePhoneNumbers.contains(filteredPhoneNumber)) {
            uniquePhoneNumbers.add(filteredPhoneNumber);
            parsedContacts.add(Contact(
              displayName: contactData['displayName'],
              phoneNumber: filteredPhoneNumber,
            ));
          }
        }

        log('Contacts loaded successfully!', name: 'ReferralDetailsScreen');
        return parsedContacts;

        //Print all contacts
        // for (final contact in _contacts) {
        //   log('${contact.displayName}, ${contact.phoneNumber}',
        //       name: 'ReferralDetailsScreen');
        // }
      }
      return [];
    } on PlatformException catch (e) {
      log('Error loading contacts: ${e.message}',
          name: 'ReferralDetailsScreen');
      return [];
    }
  }

  String? _applyFilters(String phoneNumber) {
    String filteredPhoneNumber = phoneNumber;

    // Remove spaces
    filteredPhoneNumber = filteredPhoneNumber.replaceAll(' ', '');

    // Remove "+91" prefix if present
    if (filteredPhoneNumber.startsWith('+91')) {
      filteredPhoneNumber = filteredPhoneNumber.substring(3);
    }

    // Filter out numbers less than 10 digits and not starting with 6, 7, 8, or 9
    if (filteredPhoneNumber.length < 10 ||
        !RegExp(r'^[6-9]').hasMatch(filteredPhoneNumber)) {
      return null;
    }

    return filteredPhoneNumber.isNotEmpty ? filteredPhoneNumber : null;
  }
}
