import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/flavor_config.dart';
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    await CacheService.invalidateAll();
                    BaseUtil.showPositiveAlert(
                        "Isar cleared successfully", "get back to work");
                  },
                  child: Chip(
                    backgroundColor: Colors.purple,
                    label: Text(
                      "clear Isar cache",
                      style: TextStyles.body3.colour(Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    PreferenceHelper.clear();
                    BaseUtil.showPositiveAlert(
                        "Preferences cleared successfully", "get back to work");
                  },
                  child: Chip(
                    backgroundColor: Colors.indigo,
                    label: Text(
                      "clear Shared Prefs",
                      style: TextStyles.body3.colour(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
