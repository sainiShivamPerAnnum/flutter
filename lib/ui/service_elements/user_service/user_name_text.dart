import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserNameTextSE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserName],
      builder: (context, model, property) => Text(
        "${model.myUserName?.split(' ')?.first ?? "user"}",
        style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.w600, fontSize: SizeConfig.largeTextSize),
      ),
    );
  }
}
