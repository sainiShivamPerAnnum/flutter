import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class CacheClearWidget extends StatelessWidget {
  const CacheClearWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlavorConfig.isDevelopment()
        ? Container(
            margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                ActionChip(
                  onPressed: () async {
                    await CacheService.invalidateAll();
                    BaseUtil.showPositiveAlert(
                        "Isar cleared successfully", "get back to work");
                  },
                  backgroundColor: Colors.amber,
                  label: Text(
                    "clear Isar cache",
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                ),
                ActionChip(
                  onPressed: () {
                    PreferenceHelper.clear();
                    BaseUtil.showPositiveAlert(
                        "Preferences cleared successfully", "get back to work");
                  },
                  backgroundColor: Colors.redAccent,
                  label: Text(
                    "clear Shared Prefs",
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                ),
                ActionChip(
                  onPressed: () {
                    locator<UserService>().userSegments.remove('NEW_USER');
                    BaseUtil.showPositiveAlert(
                        "Preferences cleared successfully", "get back to work");
                  },
                  backgroundColor: Colors.teal,
                  label: Text(
                    "clear new user segment",
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
