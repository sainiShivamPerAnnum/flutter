import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/autosave_services.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class AutosaveCard extends StatefulWidget {
  AutosaveCard({Key key}) : super(key: key);

  @override
  State<AutosaveCard> createState() => _AutosaveCardState();
}

class _AutosaveCardState extends State<AutosaveCard> {
  bool isResumingInProgress = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<SubscriptionCardViewModel>(
        builder: (context, subscriptionModel, child) =>
            PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
              builder: (context, model, property) => model.autosaveVisible
                  ? InkWell(
                      onTap: () async {
                        if (connectivityStatus == ConnectivityStatus.Offline)
                          return BaseUtil.showNoInternetAlert();
                        if (isLoading) return;
                        setState(() {
                          isLoading = true;
                        });
                        await subscriptionModel.getActiveButtonAction();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutExpo,
                        width: SizeConfig.screenWidth,
                        margin: EdgeInsets.only(
                            left: SizeConfig.pageHorizontalMargins,
                            right: SizeConfig.pageHorizontalMargins,
                            bottom: SizeConfig.padding16),
                        decoration: BoxDecoration(
                          gradient: AutosaveServices.getGradient(
                              model.activeSubscription),
                          image: DecorationImage(
                              image: AssetImage(Assets.whiteRays),
                              fit: BoxFit.cover,
                              opacity: 0.06),
                          //color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness24),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: SizeConfig.padding16,
                              child: Image.asset(
                                subscriptionModel
                                    .getImage(model.activeSubscription),
                                width: SizeConfig.screenWidth / 2.8,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.pageHorizontalMargins),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: SizeConfig.pageHorizontalMargins),
                                  Container(
                                    // width: SizeConfig.screenWidth * 0.5,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            subscriptionModel.getActiveTitle(
                                                model.activeSubscription),
                                            style: TextStyles.body2.light
                                                .colour(Colors.white),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.padding6),
                                        subscriptionModel
                                            .getIcon(model.activeSubscription)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.padding2),
                                  model.activeSubscription != null &&
                                          model.activeSubscription.status ==
                                              Constants.SUBSCRIPTION_ACTIVE
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                        fontSize:
                                                            SizeConfig.title1,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        // letterSpacing: 2,
                                                        color: Colors.white)),
                                            Text(
                                              subscriptionModel.getFreq(model
                                                  .activeSubscription
                                                  .autoFrequency),
                                              style: GoogleFonts.sourceSansPro(
                                                  fontSize: SizeConfig.title5,
                                                  fontWeight: FontWeight.w300,
                                                  height: 1.6,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      : Text(
                                          subscriptionModel.getactiveSubtitle(
                                              model.activeSubscription),
                                          style: TextStyles.title4.bold
                                              .colour(Colors.white),
                                        ),
                                  SizedBox(height: SizeConfig.padding16),
                                  Row(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Container(
                                          height: SizeConfig.padding40,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.padding8,
                                              horizontal: SizeConfig.padding16),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: isResumingInProgress ||
                                                  isLoading
                                              ? Container(
                                                  height: SizeConfig.body2,
                                                  child: SpinKitThreeBounce(
                                                    color: Colors.white,
                                                    size: SizeConfig.padding12,
                                                  ),
                                                )
                                              : Text(
                                                  subscriptionModel
                                                      .getActiveButtonText(model
                                                          .activeSubscription),
                                                  style: TextStyles.body2
                                                      .colour(Colors.white),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.padding8),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  if (model.activeSubscription != null)
                                    AnimatedContainer(
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.padding16),
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeOutExpo,
                                      height:
                                          model.activeSubscription?.status ==
                                                  Constants.SUBSCRIPTION_ACTIVE
                                              ? SizeConfig.body3
                                              : 0,
                                      width: SizeConfig.screenWidth * 0.5,
                                      alignment: Alignment.centerLeft,
                                      child: (model.nextDebitString != null &&
                                              model.nextDebitString.isNotEmpty)
                                          ? Text(
                                              model.nextDebitString,
                                              style: TextStyles.body4
                                                  .colour(Colors.white),
                                              textAlign: TextAlign.left,
                                            )
                                          : SizedBox(),
                                    ),
                                  SizedBox(
                                      height: SizeConfig.pageHorizontalMargins),
                                ],
                              ),
                            ),
                            if (!model.isFirstTime)
                              Positioned(
                                right: SizeConfig.padding4,
                                top: SizeConfig.padding4,
                                child: IconButton(
                                  onPressed: () {
                                    AppState.delegate.appState.currentAction =
                                        PageAction(
                                            page: AutosaveDetailsViewPageConfig,
                                            state: PageState.addPage);
                                  },
                                  icon: Icon(
                                    Icons.info_outline_rounded,
                                    size: SizeConfig.padding20,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ));
  }
}
