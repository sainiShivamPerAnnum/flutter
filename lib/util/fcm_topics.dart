enum FcmTopic{
  OLDCUSTOMER,
  NEVERINVESTEDBEFORE,
  GOLDINVESTOR,
  TAMBOLAPLAYER,
  DAILYPICKBROADCAST
}

extension ParseToString on FcmTopic {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}