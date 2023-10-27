import 'dart:developer';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/contact_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/ui/referral_home.dart';
import 'package:felloapp/util/debouncer.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactListWidget extends StatefulWidget {
  const ContactListWidget(
      {required this.contacts,
      required this.scrollController,
      required this.onStateChanged,
      super.key});

  final List<Contact> contacts;
  final ScrollController scrollController;
  final Function onStateChanged;

  @override
  State<ContactListWidget> createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  TextEditingController controller = TextEditingController();
  List<Contact> filteredContacts = []; // List to store filtered contacts
  late final Debouncer _debouncer;

  final int _displayLimit = 30; // Number of contacts to display at a time
  int _displayedContactsCount = 30; // Number of contacts currently displayed

  void searchContacts(String query) {
    log('searchContacts: $query', name: 'ReferralDetailsScreen');
    if (query.isEmpty || query.length < 3) {
      // If the query is empty, display all contacts
      setState(() {
        filteredContacts = List.from(widget.contacts);
        _displayedContactsCount = _displayLimit;
      });
    } else {
      // Filter contacts based on the query
      setState(() {
        filteredContacts = widget.contacts
            .where((contact) =>
                contact.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();

        _displayedContactsCount = filteredContacts.length;
      });
      // log('filteredContacts name: ${filteredContacts[0].displayName}',
      //     name: 'ReferralDetailsScreen');
    }

    // context.read<ReferralCubit>().refreshContacts();
  }

  @override
  void initState() {
    super.initState();
    filteredContacts = widget.contacts;
    _debouncer = Debouncer(delay: const Duration(milliseconds: 700));

    widget.scrollController.addListener(() {
      // log('Scroll offset: ${widget.scrollController.offset}',
      //     name: 'ReferralDetailsScreen');
      if (widget.scrollController.offset ==
          widget.scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
      if (widget.scrollController.offset <= 0.0) {
        widget.onStateChanged(false);
      }
    });
  }

  String formatCurrency(int amount) {
    if (amount >= 100000) {
      // Convert to Lacs
      double lacs = amount / 100000;
      return '${lacs.toStringAsFixed(1)} Lacs';
    } else {
      return amount.toString();
    }
  }

  void loadNextPage() {
    // setState(() {
    //   _isLoading = true;
    // });
    // Simulate loading more contacts
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _displayedContactsCount += _displayLimit;
      });
    });
  }

  String get referralAmount => ((AppConfig.getValue(
                      AppConfigKey.revamped_referrals_config)?['rewardValues']
                  ?['invest1k'] ??
              50) +
          (AppConfig.getValue(AppConfigKey.revamped_referrals_config)?[
                  'rewardValues']?['invest10kflo12'] ??
              450))
      .toString();

  @override
  Widget build(BuildContext context) {
    // log('ContactListWidget build ', name: 'ReferralDetailsScreen');
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      color: const Color(0xff454545).withOpacity(0.3),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding22,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/play_gift.svg',
                height: SizeConfig.padding16,
              ),
              SizedBox(
                width: SizeConfig.padding6,
              ),
              'You can earn upto *₹${formatCurrency(widget.contacts.length * 500)}* by referring!'
                  .beautify(
                boldStyle: TextStyles.sourceSansB.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
                style: TextStyles.sourceSans.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          _SearchBar(
            controller: controller,
            onChanged: (query) {
              log('Text changed: $query');
              _debouncer.call(() => searchContacts(query));
              // _debouncer.call(
              //         () => searchContacts(query)); // will be called after 700ms
            },
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          if (filteredContacts.isEmpty)
            Center(
              child: Text(
                'No contacts found',
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              ),
            ),
          ListView.builder(
            itemCount: _displayedContactsCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < filteredContacts.length) {
                final contact = filteredContacts[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: SizeConfig.padding44,
                          width: SizeConfig.padding44,
                          padding: EdgeInsets.all(SizeConfig.padding3),
                          decoration: const ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                  width: 0.5, color: Color(0xFF1ADAB7)),
                            ),
                          ),
                          child: Container(
                            height: SizeConfig.padding38,
                            width: SizeConfig.padding38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                contact.displayName.substring(0, 1),
                                style: TextStyles.rajdhaniSB.body0
                                    .colour(const Color(0xFF3A3A3C)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.displayName.checkOverFlow(maxLength: 40),
                              style: TextStyles.rajdhaniSB.body2
                                  .colour(Colors.white),
                            ),
                            Row(
                              children: [
                                Text(
                                  (contact.isRegistered ?? false)
                                      ? "Already on Fello"
                                      : 'Invite and earn ₹$referralAmount',
                                  style: TextStyles.sourceSans.body4.colour(
                                      (contact.isRegistered ?? false)
                                          ? const Color(0xFF61E3C4)
                                          : Colors.white.withOpacity(0.48)),
                                ),
                                if (contact.isRegistered ?? false)
                                  Container(
                                      height: SizeConfig.padding12,
                                      width: SizeConfig.padding12,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.padding4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF61E3C4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: SizeConfig.padding10,
                                          color: Colors.black,
                                          weight: 700,
                                          grade: 200,
                                          opticalSize: 48,
                                        ),
                                      ))
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (!(contact.isRegistered ?? false))
                          GestureDetector(
                            onTap: () {
                              navigateToWhatsApp(contact.phoneNumber,
                                  locator<ReferralService>().shareMsg);

                              locator<AnalyticsService>().track(
                                eventName:
                                    AnalyticsEvents.inviteOnContactCardTapped,
                                properties: {
                                  'Contact Name': contact.displayName,
                                  'Contact Number': contact.phoneNumber,
                                },
                              );
                            },
                            child: Text(
                              'INVITE',
                              textAlign: TextAlign.right,
                              style: TextStyles.rajdhaniB.body3
                                  .colour(const Color(0xFF61E3C4)),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    )
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          if (filteredContacts.length > _displayedContactsCount)
            SpinKitThreeBounce(
              size: SizeConfig.title5,
              color: Colors.white,
            ),

          SizedBox(
            height: SizeConfig.padding24,
          ),
          // SpinKitThreeBounce()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.cancel();
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, this.onChanged});

  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding40,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF454545).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.padding36),
            child: TextFormField(
              controller: controller,
              style: TextStyles.sourceSans.body3.colour(Colors.white),
              onChanged: onChanged,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'number length should be greater than 3';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                hintText: "Search by name",
                hintStyle: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.3)),
                errorStyle: TextStyles.sourceSans.body3.colour(Colors.red),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
