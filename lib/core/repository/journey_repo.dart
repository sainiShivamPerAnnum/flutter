import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class JourneyRepository extends BaseRepo {
  final _cacheService = new CacheService();

  //Local Variables
  static const String PAGE_DIRECTION_UP = "up";
  static const String PAGE_DIRECTION_DOWN = "down";
  static const String LOCAL_ASSET_DATABASE = "localAssetDatabase";
  String _filePathDirectory;

  //Initiating instance for local directory of Android || iOS
  Future<void> init() async {
    if (_filePathDirectory == null) {
      if (Platform.isAndroid) {
        final directory = await getApplicationDocumentsDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);
        _filePathDirectory = '${directory.path}/journey_assets/';
      } else if (Platform.isIOS) {
        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);
        _filePathDirectory = '${directory.path}/journey_assets/';
      }
    }
  }

  //Downloads the file and calls the saveFileToLocalDirectory()
  //Assumes that it will always recieve a network url and that too of an image file
  //Regex for network url and asset extension can be added.

  Future<bool> downloadAndSaveFile(String url) async {
    HttpClient httpClient = new HttpClient();
    String filePath = '';
    try {
      String fileName = url.split('/').last;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = await saveFileToLocalDirectory(bytes, fileName);
        addToLocalAssetDatabase(filePath);
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
        return false;
      }
    } catch (ex) {
      logger.e(ex.toString());
      filePath = '';
      return false;
    }
    dev.log(filePath);
    return true;
  }

  //Saving Uint8List type data into journey_assets/ named directory using recursive approach
  //ensures that return String will never be null

  Future<String> saveFileToLocalDirectory(
      Uint8List svgBytes, String fileName) async {
    String filePath = '';
    if (Platform.isAndroid) {
      try {
        // final directory = await getApplicationDocumentsDirectory();
        // if (!await directory.exists()) await directory.create(recursive: true);
        // filePath = '${directory.path}/journey_assets/$fileName';

        filePath = '$_filePathDirectory$fileName';
        File file = await new File(filePath).create(recursive: true);
        file.writeAsBytesSync(svgBytes);
        logger.d(
            "JOURNEYREPO:: Android asset file successfully saved to local directory with path: ${file.path}");
      } catch (e) {
        filePath = '';
        logger.e(
            "JOURNEYREPO:: Android asset file failed to save into local directory with error $e");
      }
    } else if (Platform.isIOS) {
      try {
        // final directory = await getTemporaryDirectory();
        // if (!await directory.exists()) await directory.create(recursive: true);
        // filePath = '${directory.path}/journey_assets/$fileName';
        filePath = '$_filePathDirectory$fileName';
        File file = await new File(filePath).create(recursive: true);
        file.writeAsBytesSync(svgBytes);
        logger.d(
            "JOURNEYREPO:: IOS asset file successfully saved to local directory with path: ${file.path}");
      } catch (e) {
        filePath = '';
        logger.e(
            "JOURNEYREPO:: IOS asset file failed to save into local directory with error $e");
      }
    }
    return filePath;
  }

  //Saving data of every asset in shared Prefernces as a key-value pair where
  //key: asset_name -|- value: asset local filepath
  //to be updated with isar
  bool addToLocalAssetDatabase(String filePath) {
    String filename = filePath.split('/').last;
    String fileKey = filename.split('.').first;
    if (!PreferenceHelper.exists(fileKey)) {
      PreferenceHelper.setString(fileKey, filePath);
      return true;
    }
    return false;
  }

  //Checks the existence of asset locally
  //only check in shared prefs and cannot ensure if the
  //file exists on the device or not!
  bool checkIfAssetIsAvailableLocally(String assetKey) {
    return (PreferenceHelper.exists(assetKey) &&
        File(PreferenceHelper.getString(assetKey)).existsSync());
  }

  //Returns the local filepath of the asset from Shared Prefs
  String getAssetLocalFilePath(String assetKey) =>
      PreferenceHelper.getString(assetKey);

  //Fetch Journey pages from journey collection
  //params: start page and direction[up,down]
  Future<ApiResponse<List<JourneyPage>>> fetchJourneyPages(
    int page,
    String direction,
  ) async {
    try {
      final isUp = direction == PAGE_DIRECTION_UP;
      final limit = 1; // inclusive limit so actually 2 pages are returned

      final startPage = max(isUp ? page : page - limit, 1);
      final endPage = isUp ? page + limit : page;

      final token = await getBearerToken();
      final queryParams = {"page": page.toString(), "direction": direction};

      return await _cacheService.paginatedCachedApi(
          CacheKeys.JOURNEY_PAGE,
          startPage,
          endPage,
          TTL.ONE_DAY,
          () => APIService.instance.getData(
                ApiPath().kJourney,
                token: token,
                cBaseUrl: FlavorConfig.isDevelopment()
                    ? "https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev"
                    : "not yet found",
                queryParams: queryParams,
              ), (dynamic responseData) {
        // parser
        final start = responseData["start"];
        final end = responseData["end"];
        List<dynamic> items = responseData["items"];

        List<JourneyPage> journeyPages = [];
        for (int i = start; i <= end; i++) {
          journeyPages.add(JourneyPage.fromMap(items[i - start], i));
        }

        return ApiResponse<List<JourneyPage>>(model: journeyPages, code: 200);
      });
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to journey pages", 400);
    }
  }

  //Returns User Journey stats
  //refer UserJourneyStatsModel for the response
  Future<ApiResponse<UserJourneyStatsModel>> getUserJourneyStats() async {
    try {
      final String _uid = userService.baseUser.uid;
      final _token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.journeyStats(_uid),
        token: _token,
        cBaseUrl: "https://l6e3g2pr2b.execute-api.ap-south-1.amazonaws.com/dev",
      );

      final responseData = response["data"];
      logger.d("Response from get Journey stats: $response");
      return ApiResponse(
          model: UserJourneyStatsModel.fromMap(responseData), code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch user stats", 400);
    }
  }

  // Helper Methods
  // Just the upload created journey page data
  // Future<void> uploadJourneyPage(JourneyPage page) async {
  //   try {
  //     // final String _uid = _userService.baseUser.uid;
  //     final _token = await getBearerToken();
  //     final _body = page.toMap();
  //     dev.log(json.encode(_body));
  //     final response = await APIService.instance.postData(
  //       ApiPath.getJourney(2),
  //       token: _token,
  //       body: _body,
  //       cBaseUrl: "https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev",
  //     );
  //     logger.d(response);
  //     return true;
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return false;
  //   }
  // }

  Future<ApiResponse<List<JourneyLevel>>> getJourneyLevels() async {
    try {
      List<JourneyLevel> journeylevels = [];
      final _token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.kJourneyLevel,
        token: _token,
        cBaseUrl: "https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev",
      );

      final responseData = response["data"];
      responseData.forEach((level, levelDetails) {
        journeylevels.add(JourneyLevel.fromMap(levelDetails));
      });
      logger.d("Response from get Journey Level: $response");
      return ApiResponse(model: journeylevels, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch user levels", 400);
    }
  }
}
