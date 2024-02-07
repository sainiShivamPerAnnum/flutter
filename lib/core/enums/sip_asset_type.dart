enum SIPAssetTypes {
  UNI_FLEXI,
  UNI_FIXED_3,
  UNI_FIXED_6,
  AUGGOLD99,
  BOTH,
  UNKNOWN;

  bool get isLendBox =>
      this == SIPAssetTypes.UNI_FLEXI ||
      this == SIPAssetTypes.UNI_FIXED_3 ||
      this == SIPAssetTypes.UNI_FIXED_6;
  bool get isAugGold => this == SIPAssetTypes.AUGGOLD99;
}
