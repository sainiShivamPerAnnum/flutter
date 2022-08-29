import 'package:app_install_date/utils.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'dart:developer';

class SourceAdaptiveAssetViewModel extends BaseModel {
  final _journeyRepo = locator<JourneyRepository>();
  String assetType = "NTWRK";
  String _assetName;
  String _assetUrl;
  String get assetName => this._assetName;

  set assetName(String value) => this._assetName = value;

  String get assetUrl => this._assetUrl;

  set assetUrl(value) {
    this._assetUrl = value;
  }

  init(String value) {
    assetUrl = value;
    assetName = assetUrl.split('/').last.split('.').first;
    if (!PlatformUtils.isWeb) completeNViewDownloadSaveLViewAsset();
  }

  dump() {}

  Future<void> completeNViewDownloadSaveLViewAsset() async {
    if (_journeyRepo.checkIfAssetIsAvailableLocally(assetName)) {
      log("ROOTVM: Asset path found cached in local storage.showing asset from cache");
      assetUrl = _journeyRepo.getAssetLocalFilePath(assetName);
    } else {
      // svgSource = "https://journey-assets-x.s3.ap-south-1.amazonaws.com/b1.svg";
      log("ROOTVM: Asset path not found in cache. Downloading and caching it now. also showing network Image for now");
      final bool result = await _journeyRepo.downloadAndSaveFile(assetUrl);
      if (result) {
        log("ROOTVM: Asset downloading & caching completed successfully. will load it from local next start onwards");
        // assetUrl = _journeyRepo.getAssetLocalFilePath(assetName);
      } else {
        log("ROOTVM: Asset downlaoding & caching failed. showing asset from network this time, will try again on next startup");
      }
    }
  }
}
