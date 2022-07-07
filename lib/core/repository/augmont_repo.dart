import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';

class AugmontRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<ApiResponse<UserAugmontDetail>> getUserAugmontDetails() async {
    UserAugmontDetail augmont;
    try {
      final augmontRespone = await APIService.instance.getData(
        ApiPath.getAugmontDetail(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
      );

      augmont = UserAugmontDetail.fromMap(augmontRespone['data']);
      return ApiResponse<UserAugmontDetail>(model: augmont, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch augmont", 400);
    }
  }
}
