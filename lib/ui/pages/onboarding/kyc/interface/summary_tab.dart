// import 'package:felloapp/ui/elements/buttons/contact_us_button.dart';
// import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboard_data.dart';
// import 'package:flutter/material.dart';

// class SummaryTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     return Container(
//       width: _width,
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           ListTile(
//             title: Text(
//               "ONE TIME PROCESS REQUIRED BY RBI UNLOCKS ALL FUNDS",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: KycOnboardData.titleColor,
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             title: Text(
//               "KYC, 'Know Your Customer':",
//               style: KycOnboardData.getTitleStyle(),
//             ),
//             subtitle: Text(
//               "The Reserve Bank of India has made it mandatory for banks, financial institutions and other organisations to verify the identity of all customers who carry out financial transactions with them.\nThis is a ONE TIME process. We make it rather simple for you to enter the world of fun financial assets. You will never have to repeat this process on any other platform either!",
//               style: KycOnboardData.getSubtitleStyle(),
//             ),
//           ),
//           ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: 20),
//             title: Text(
//               "We do not store your data. Your data is processed and sent for verification. We only store your PAN number as your unique ID.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: KycOnboardData.titleColor,
//                 fontSize: 14,
//                 letterSpacing: 1.5,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text("Documents Required:",
//                 style: KycOnboardData.getTitleStyle()),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "- Pan card",
//                   style: KycOnboardData.getSubtitleStyle(),
//                 ),
//                 Text(
//                   "- Aadhar card",
//                   style: KycOnboardData.getSubtitleStyle(),
//                 ),
//                 Text(
//                   "- Cancelled Cheque",
//                   style: KycOnboardData.getSubtitleStyle(),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             title: Text(
//               "Please Note:",
//               style: KycOnboardData.getTitleStyle(),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 KycOnboardData.getNotes(
//                     "All uploaded images should be clear and readable, and preferably on a white background."),
//                 KycOnboardData.getNotes(
//                     "Each step in the process is mandatory for the successful completion of your KYC Your mobile number should be linked to your Aadhaar number for the final verification."),
//                 KycOnboardData.getNotes(
//                     "Your KYC will get verified in 2-3 working days post completion."),
//                 KycOnboardData.getNotes(
//                     "Feel free to contact us for any issues. We are always available!"),
//               ],
//             ),
//           ),
//           SizedBox(height: 50),
//           ContactUsBtn(),
//         ],
//       ),
//     );
//   }
// }
