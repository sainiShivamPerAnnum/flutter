import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/service/connectivity_service.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/util/locator.dart';

class FBtnVM extends BaseModel {
  executeOnPress(Function function) async {
    function();
  }
}
