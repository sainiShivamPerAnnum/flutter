import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const String LOCAL_ASSET_DATABASE = "localAssetDatabase";

class JourneyRepository {
  final CustomLogger _logger = locator<CustomLogger>();
  Future<bool> downloadandSaveFile(String url) async {
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
    log(filePath);
    return true;
  }

  Future<String> saveFileToLocalDirectory(
      Uint8List svgBytes, String fileName) async {
    String filePath = '';
    if (Platform.isAndroid) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);
        filePath = '${directory.path}/journey_assets/$fileName';
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
        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);
        filePath = '${directory.path}/journey_assets/$fileName';
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
}
