import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/ui/pages/hamburger/faq_page.dart';
import 'package:felloapp/ui/pages/hamburger/referral_policy_page.dart';
import 'package:felloapp/ui/pages/root.dart';
import 'package:felloapp/ui/pages/tabs/profile/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var uri = Uri.parse(settings.name);
  // BuildContext context;
  for (int i = 0; i < uri.pathSegments.length; i++) {
    //last process ..we need to return
    if (i == uri.pathSegments.length - 1) {
      switch (uri.pathSegments[i]) {
        case "approot":
          print("OUtputing root");
          return MaterialPageRoute(builder: (ctx) => Root());
        case "editprof":
          return MaterialPageRoute(builder: (ctx) => EditProfile());
        case 'refpolicy':
          return MaterialPageRoute(builder: (ctx) => ReferralPolicy());
        case 'faq':
          return MaterialPageRoute(builder: (ctx) => FAQPage());
      }
    }
    // we just need to carry out the process
    else {
      switch (uri.pathSegments[i]) {
        case "approot":
          print("OUtputing root");
          MaterialPageRoute(builder: (ctx) => Root());
          break;
        case "editprof":
          MaterialPageRoute(builder: (ctx) => EditProfile());
          break;
        case 'refpolicy':
          MaterialPageRoute(builder: (ctx) => ReferralPolicy());
          break;
        case 'faq':
          MaterialPageRoute(builder: (ctx) => FAQPage());
          break;
      }
    }
    // print(uri.pathSegments[i]);
    // if (uri.pathSegments[i].startsWith('D')) {
    //   print("We need to open a dialog");
    //   // showDialog(
    //   //   context: context,
    //   //   builder: (BuildContext context) => GuideDialog(),
    //   // );
    // } else if (uri.pathSegments[i].startsWith('T')) {
    //   print("We need to change the tab");
    // } else {}
  }
}
