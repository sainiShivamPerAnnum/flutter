import 'package:upi_pay/src/applications.dart';

class TransactionDetails {
  final UpiApplication upiApplication;
  final String deepLinkUrl;

  TransactionDetails({
    required this.upiApplication,
    required this.deepLinkUrl,
  });

  Map<String, dynamic> toJson() {
    return {'app': upiApplication.toString(), 'deepLinkUrl': deepLinkUrl};
  }
}
