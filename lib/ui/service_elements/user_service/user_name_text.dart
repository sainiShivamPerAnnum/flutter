import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserNameTextSE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.myUserName],
      builder: (context, model, property) => Text(
        model!.myUserName?.split(' ').first ?? "user",
        style: TextStyles.sourceSansSB.title4,
      ),
    );
  }
}
