import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const String LOCAL_ASSET_DATABASE = "localAssetDatabase";

class JourneyRepository {
  static const String PAGE_DIRECTION_UP = "up";
  static const String PAGE_DIRECTION_DOWN = "down";
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  Api _api = locator<Api>();
  String _filePathDirectory;

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
      _logger.e(ex.toString());
      filePath = '';
      return false;
    }
    dev.log(filePath);
    return true;
  }

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
        _logger.d(
            "JOURNEYREPO:: Android asset file successfully saved to local directory with path: ${file.path}");
      } catch (e) {
        filePath = '';
        _logger.e(
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
        _logger.d(
            "JOURNEYREPO:: IOS asset file successfully saved to local directory with path: ${file.path}");
      } catch (e) {
        filePath = '';
        _logger.e(
            "JOURNEYREPO:: IOS asset file failed to save into local directory with error $e");
      }
    }
    return filePath;
  }

  bool addToLocalAssetDatabase(String filePath) {
    String filename = filePath.split('/').last;
    String fileKey = filename.split('.').first;
    if (!PreferenceHelper.exists(fileKey)) {
      PreferenceHelper.setString(fileKey, filePath);
      return true;
    }
    return false;
  }

  bool checkIfAssetIsAvailableLocally(String assetKey) {
    return PreferenceHelper.exists(assetKey);
  }

  String getAssetLocalFilePath(String assetKey) {
    return PreferenceHelper.getString(assetKey);
  }

  Future<ApiResponse<List<JourneyPage>>> fetchJourneyPages(
      int start, String direction) async {
    List<JourneyPage> journeyPages = [];
    try {
      final _token = await _getBearerToken();
      final _queryParams = {"page": start.toString(), "direction": direction};
      final response = await APIService.instance.getData(
        ApiPath().kJourney,
        token: _token,
        cBaseUrl: FlavorConfig.isDevelopment()
            ? "https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev"
            : "not yet found",
        queryParams: _queryParams,
      );

      final responseData = response["data"];
      int startPage = responseData["startPage"];
      int endPage = responseData["endPage"];
      for (int i = startPage, k = 0; i <= endPage; i++, k++) {
        List<dynamic> page = responseData["pages"];
        journeyPages.add(JourneyPage.fromMap(page[k], i));
      }
      return ApiResponse<List<JourneyPage>>(model: journeyPages, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to journey pages", 400);
    }
  }

  Future<void> uploadJourneyPage(JourneyPage page) async {
    try {
      // final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _body = page.toMap();
      dev.log(json.encode(_body));
      final response = await APIService.instance.postData(
        ApiPath.getJourney(2),
        token: _token,
        body: _body,
        cBaseUrl: "https://i2mkmm61d4.execute-api.ap-south-1.amazonaws.com/dev",
      );
      _logger.d(response);
      return true;
    } catch (e) {
      _logger.e(e.toString());
      return false;
    }
  }

  Future<ApiResponse<UserJourneyStatsModel>> getUserJourneyStats() async {
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.journeyStats(_uid),
        token: _token,
        cBaseUrl: "https://l6e3g2pr2b.execute-api.ap-south-1.amazonaws.com/dev",
      );

      final responseData = response["data"];
      _logger.d("Response from get Journey stats: $response");
      return ApiResponse(
          model: UserJourneyStatsModel.fromMap(responseData), code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch user stats", 400);
    }
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);
    return token;
  }
}
