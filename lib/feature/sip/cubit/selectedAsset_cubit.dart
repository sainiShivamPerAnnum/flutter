import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';

part 'selectedAsset_state.dart';

class SelectAssetCubit extends Cubit<SelectAssetCubitState> {
  SelectAssetCubit() : super(const SelectAssetCubitState());

  void setSelectedAsset(SIPAssetTypes asset) {
    emit(state.copyWith(selectedAsset: asset));

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.sipAssetSelected,
      properties: {
        "asset selected": asset.name,
      },
    );
  }

  void submitAsset(SIPAssetTypes asset, bool isMandateAvailable) {
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.asChooseAssetNextTapped, properties: {
      "asset selected": asset,
    });
    AppState.delegate!.appState.currentAction = PageAction(
      page: SipFormPageConfig,
      widget: SipFormAmountView(
        mandateAvailable: isMandateAvailable,
        sipAssetType: asset,
      ),
      state: PageState.addWidget,
    );
  }
}
