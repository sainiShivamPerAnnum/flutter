import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/core/model/contact_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:meta/meta.dart';
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
    }
  }

  Future<void> getContacts() async {
    emit(ContactsLoading());

    if (model.contactsList != null && model.contactsList!.isNotEmpty) {
      emit(ContactsLoaded(model.contactsList!));
      return;
    }

    try {
      final contacts = await model.loadContacts();

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

  Future<void> _loadContacts() async {
    if (model.contactsList != null && model.contactsList!.isNotEmpty) {
      emit(ContactsLoaded(model.contactsList!));
      return;
    }
  }
}
