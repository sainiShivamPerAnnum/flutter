import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class JourneyRepository extends BaseRepo {
  final _cacheService = CacheService();

  static const _journey = 'journey';

  //Local Variables
  static const String PAGE_DIRECTION_UP = "up";
  static const String PAGE_DIRECTION_DOWN = "down";
  static const String LOCAL_ASSET_DATABASE = "localAssetDatabase";
  String? _filePathDirectory;

  List<JourneyPage> journeyPages = [];

  final _baseUrlJourney = FlavorConfig.isDevelopment()
      ? 'https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://rs0wiakaw7.execute-api.ap-south-1.amazonaws.com/prod';

  final _baseUrlStats = FlavorConfig.isDevelopment()
      ? "https://l6e3g2pr2b.execute-api.ap-south-1.amazonaws.com/dev"
      : 'https://08wplse7he.execute-api.ap-south-1.amazonaws.com/prod';

  final _cdnBaseUrl = FlavorConfig.isDevelopment()
      ? 'https://d18gbwu7fwwwtf.cloudfront.net/'
      : 'https://d11q4cti75qmcp.cloudfront.net/';

  //Initiating instance for local directory of Android || iOS
  Future<void> init() async {
    if (_filePathDirectory?.isEmpty ?? true) {
      if (Platform.isAndroid) {
        final directory = await getApplicationDocumentsDirectory();
        if (directory.existsSync()) await directory.create(recursive: true);
        _filePathDirectory = '${directory.path}/journey_assets/';
        logger.d("Android Directory Created with path : $_filePathDirectory");
      } else if (Platform.isIOS) {
        final directory = await getTemporaryDirectory();
        if (directory.existsSync()) await directory.create(recursive: true);
        _filePathDirectory = '${directory.path}/journey_assets/';
        logger.d("IOS Directory Created with path : $_filePathDirectory");
      }
    }
  }

  void dump() {
    journeyPages.clear();
    if (_filePathDirectory == null) return;
    if (Directory(_filePathDirectory!).existsSync()) {
      Directory(_filePathDirectory!).deleteSync(recursive: true);
    }
  }

  //Downloads the file and calls the saveFileToLocalDirectory()
  //Assumes that it will always recieve a network url and that too of an image file
  //Regex for network url and asset extension can be added.

  Future<bool> downloadAndSaveFile(String url) async {
    HttpClient httpClient = HttpClient();
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
        filePath = 'Error code: ${response.statusCode}';
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
    try {
      filePath = '$_filePathDirectory$fileName';
      final file = await File(filePath).create(recursive: true);
      file.writeAsBytesSync(svgBytes);
      logger.d(
          "JOURNEYREPO:: ${defaultTargetPlatform.name} asset file successfully saved to local directory with path: ${file.path}");
    } catch (e) {
      filePath = '';
      logger.e(
          "JOURNEYREPO:: ${defaultTargetPlatform.name} asset file failed to save into local directory with error $e");
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
    return PreferenceHelper.exists(assetKey) &&
        File(PreferenceHelper.getString(assetKey)).existsSync();
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
      const limit = 1; // inclusive limit so actually 2 pages are returned

      final startPage = max(isUp ? page : page - limit, 1);
      final endPage = isUp ? page + limit : page;

      final queryParams = {"page": page.toString(), "direction": direction};

      return await _cacheService.paginatedCachedApi(
          CacheKeys.JOURNEY_PAGE,
          startPage,
          endPage,
          TTL.ONE_DAY,
          () => APIService.instance.getData(
                ApiPath.kJourney,
                cBaseUrl: _baseUrlJourney,
                queryParams: queryParams,
                apiName: _journey,
              ), (responseData) {
        // parser
        final start = responseData["start"];
        final end = responseData["end"];
        List<dynamic>? items = responseData["items"];

        List<JourneyPage> journeyPages = [];
        if (items!.isEmpty) {
          return ApiResponse<List<JourneyPage>>(model: [], code: 200);
        }

        for (int i = start; i <= end; i++) {
          journeyPages.add(JourneyPage.fromMap(items[i - start as int], i));
        }

        return ApiResponse<List<JourneyPage>>(model: journeyPages, code: 200);
      });
    } on FetchDataException catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 500);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<JourneyPage>>> fetchNewJourneyPages(
    int page,
    String direction,
    String version,
  ) async {
    try {
      // final isUp = direction == PAGE_DIRECTION_UP;
      // final limit = 1; // inclusive limit so actually 2 pages are returned

      final startPage = page - 1; // max(isUp ? page : page - limit, 1);
      final endPage = page; // isUp ? page + limit : page;

      final queryParams = {"page": page.toString(), "direction": direction};

      if (journeyPages.isNotEmpty) {
        if (journeyPages.length - 1 >= endPage) {
          return ApiResponse(
            model: [journeyPages[startPage], journeyPages[endPage]],
            code: 200,
          );
        } else {
          if (page > journeyPages.length) {
            return ApiResponse(
              model: [],
              code: 200,
            );
          } else {
            return ApiResponse(
              model: journeyPages.sublist(startPage),
              code: 200,
            );
          }
        }
      }

      final v = version.toLowerCase();

      return await _cacheService.cachedApi(
          CacheKeys.JOURNEY_PAGE,
          TTL.ONE_DAY,
          isFromCdn: true,
          () => APIService.instance.getData(
                "journey_$v.txt",
                cBaseUrl: _cdnBaseUrl,
                queryParams: queryParams,
                decryptData: true,
                apiName: '$_journey/$v',
              ), (responseData) {
        List<dynamic>? items = responseData;

        if (items!.isEmpty) {
          return ApiResponse<List<JourneyPage>>(model: [], code: 200);
        }

        for (int i = 0; i < items.length; i++) {
          journeyPages.add(JourneyPage.fromMap(items[i], i + 1));
        }

        return ApiResponse<List<JourneyPage>>(
            model: [journeyPages[0], journeyPages[1]], code: 200);
      });
    } on FetchDataException catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 500);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Returns User Journey stats
  // refer UserJourneyStatsModel for the response
  Future<ApiResponse<UserJourneyStatsModel>> getUserJourneyStats() async {
    try {
      final String? uid = userService.baseUser!.uid;
      final response = await APIService.instance.getData(
        ApiPath.journeyStats(uid),
        cBaseUrl: _baseUrlStats,
        apiName: '$_journey/statsByID',
      );

      final responseData = response["data"];
      logger.d("Response from get Journey stats: $response");
      return ApiResponse(
          model: UserJourneyStatsModel.fromMap(responseData), code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch user stats", 400);
    }
  }

  Future<ApiResponse<List<JourneyLevel>>> getJourneyLevels(
      String version) async {
    try {
      List<JourneyLevel> journeyLevels = [];

      final v = version.toUpperCase();
      final response = await APIService.instance.getData(
        "journeyLevels$v.txt",
        cBaseUrl: _cdnBaseUrl,
        decryptData: true,
        apiName: '$_journey/levels$v',
      );

      // final response = await APIService.instance.getData(
      //   ApiPath.kJourneyLevel,
      //   token: _token,
      //   cBaseUrl: _baseUrlJourney,
      // );

      // final responseData = response["data"];
      journeyLevels = JourneyLevel.helper.fromMapArray(response);

      logger.d("Response from get Journey Level: $response");
      return ApiResponse(model: journeyLevels, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FelloBadgesModel>> getFelloBadges() async {
    try {
      final uid = userService.baseUser!.uid;
      final token = await getBearerToken();
      final res = await APIService.instance.getData(
        ApiPath.felloBadges(uid!),
        cBaseUrl: _baseUrlStats,
        token: token,
      );

      if (res != null && res['data'] != null && res['data'].isNotEmpty) {
        return ApiResponse<FelloBadgesModel>(
            model: FelloBadgesModel.fromJson(res), code: 200);
      } else {
        return ApiResponse<FelloBadgesModel>(model: null, code: 200);
      }
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
