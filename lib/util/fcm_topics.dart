enum FcmTopic {
  OLDCUSTOMER,
  NEVERINVESTEDBEFORE,
  GOLDINVESTOR,
  TAMBOLAPLAYER,
  DAILYPICKBROADCAST,
  PROMOTION,
  VERSION,
  REFERRER,
  MISSEDCONNECTION,
  FREQUENTFLYER,
  WINNERWINNER
}

extension ParseToString on FcmTopic {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}
