import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                InkWell(
                  onTap: () async {
                    String? deviceId;
                    try {
                      const platform =
                          MethodChannel("methodChannel/deviceData");

                      final String result =
                          await platform.invokeMethod('getDeviceId');
                      deviceId = result;
                    } catch (e) {
                      debugPrint(e.toString());
                      deviceId = "";
                    }
                    BaseUtil.showPositiveAlert(
                        "Your device Id is:", "$deviceId");
                    log("DEVICE ID: $deviceId");
                  },
                  child: Chip(
                    backgroundColor: Colors.indigo,
                    label: Text(
                      "DeviceId",
                      style: TextStyles.body3.colour(Colors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final res =
                        await locator<UserService>().logUserInstalledApps();
                    log(res.toString());

                    locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.installedApps,
                        properties: {
                          "apps": Map<String, dynamic>.from(res)
                              .keys
                              .map((e) => e.toString())
                              .toList()
                        });
                  },
                  child: Chip(
                    backgroundColor: Colors.indigo,
                    label: Text(
                      "Apps",
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
