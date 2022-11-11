import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/widgets.dart';

class UserBrief extends StatelessWidget {
  UserBrief({Key key, @required this.model}) : super(key: key);
  final UserProfileVM model;
  final UserService userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          model.nameController.text,
          style: TextStyles.rajdhaniSB.title4,
        ),
        Text(
          '@${userService.diplayUsername(model.myUsername)}',
          style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
        ),
      ],
    );
  }
}
