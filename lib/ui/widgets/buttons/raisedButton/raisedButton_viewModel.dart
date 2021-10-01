import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';

class RBtnVM extends BaseModel {
  executeOnPress(Future<void> Function() function) async {
    setState(ViewState.Busy);
    function().then((value) {
      setState(ViewState.Idle);
    });
  }
}
