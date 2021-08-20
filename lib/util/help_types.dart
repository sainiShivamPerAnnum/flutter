enum HelpType {
  TxnTimeTooLongHelp,
  TxnRequestNotReceivedHelp,
  TxnHowToHelp,
  TxnCompletedButNotAcceptedHelp,
  TxnFailedOnUpiAppHelp,
  TxnOtherQueryHelp
}

extension ParseToString on HelpType {
  String value() {
    return this.toString().split('.').last;
  }
}
