import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/flavor_config.dart';

class SaveRepo extends BaseRepo {
  final _cacheService = CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://rco4comkpa.execute-api.ap-south-1.amazonaws.com"
      : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com";
}
