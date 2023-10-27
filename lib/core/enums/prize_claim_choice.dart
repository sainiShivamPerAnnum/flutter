enum PrizeClaimChoice { NA, AMZ_VOUCHER, GOLD_CREDIT, FELLO_PRIZE }

extension ParseToString on PrizeClaimChoice {
  String value() {
    return toString().split('.').last;
  }
}
