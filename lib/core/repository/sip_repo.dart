import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/cache_service.dart';

class SipRepository extends BaseRepo {
  final CacheService cacheService;
  SipRepository(this.cacheService);
}
