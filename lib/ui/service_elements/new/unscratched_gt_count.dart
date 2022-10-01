// import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
// import 'package:felloapp/core/enums/user_coin_service_enum.dart';
// import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
// import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:flutter/material.dart';
// import 'package:property_change_notifier/property_change_notifier.dart';

// class UnscratchedGTCountChip extends StatelessWidget {
//   final TextStyle style;
//   UnscratchedGTCountChip({this.style});
//   @override
//   Widget build(BuildContext context) {
//     return PropertyChangeConsumer<GoldenTicketService,
//             GoldenTicketServiceProperties>(
//         properties: [GoldenTicketServiceProperties.UnscratchedCount],
//         builder: (context, model, property) =>
//             model.unscratchedTicketsCount != null &&
//                     model.unscratchedTicketsCount != 0
//                 ? Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 0.5),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.padding12,
//                       vertical: SizeConfig.padding10,
//                     ),
//                     child: Text("${model.unscratchedTicketsCount} New"),
//                   )
//                 : Text(
//                     'See All',
//                     style: TextStyles.sourceSans.body3.colour(Colors.white),
//                   ));
//   }
// }
