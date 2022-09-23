import 'package:felloapp/core/repository/base_repo.dart';

import '../../util/flavor_config.dart';

class LendboxRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://lczsbr3cjl.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://sdypt3fcnh.execute-api.ap-south-1.amazonaws.com/prod';
}
