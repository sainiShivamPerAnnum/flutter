import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/referrals/bloc/referral_cubit.dart';
import 'package:felloapp/feature/referrals/ui/contact_list_widget.dart';
import 'package:felloapp/feature/referrals/ui/referral_home.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InviteContactWidget extends StatefulWidget {
  const InviteContactWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ReferralDetailsViewModel model;

  @override
  State<InviteContactWidget> createState() => _InviteContactWidgetState();
}

class _InviteContactWidgetState extends State<InviteContactWidget>
    with AutomaticKeepAliveClientMixin<InviteContactWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().checkPermission();
  }

  void showPermissionBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: PermissionModalSheet(widget: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      builder: (context, state) {
        if (state is NoPermissionState) {
          return Column(
            children: [
              SizedBox(height: SizeConfig.padding20),
              SvgPicture.asset(
                'assets/svg/magnifying_glass.svg',
                height: SizeConfig.padding148,
              ),
              Text(
                'You haven’t added your contacts yet',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.8)),
              ),
              SizedBox(height: SizeConfig.padding12),
              SizedBox(
                width: SizeConfig.padding200 + SizeConfig.padding54,
                child: Text(
                  'Over 2000 users have given contact access to Fello',
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.body0
                      .colour(Colors.white.withOpacity(0.8)),
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              MaterialButton(
                onPressed: showPermissionBottomSheet,
                color: Colors.white,
                minWidth: SizeConfig.padding100,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding60,
                    vertical: SizeConfig.padding12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.padding34,
                child: Text(
                  "SYNC CONTACTS",
                  style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                ),
              ),
              SizedBox(height: SizeConfig.padding54),
            ],
          );
        }

        if (state is ContactsLoaded) {
          return ContactListWidget(
            contacts: state.contacts,
          );
        }

        if (state is ContactsError) {
          return SizedBox(
            height: SizeConfig.padding80,
            child: Center(
              child: Text(
                'Error loading contacts',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        }

        return SizedBox(
          height: SizeConfig.screenHeight! * 0.6,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
