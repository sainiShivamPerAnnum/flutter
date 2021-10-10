enum AWSIciciStage { DEV, PROD }

extension ParseAwsIciciToString on AWSIciciStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum AWSAugmontStage { DEV, PROD }

extension ParseAugmontIciciToString on AWSAugmontStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum SignzyStage { DEV, PROD }

extension ParseSignzyToString on SignzyStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum RazorpayStage { DEV, PROD }

extension ParseRazorpayToString on RazorpayStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum FreshchatStage { DEV, PROD }

extension ParseFreshchatToString on FreshchatStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum SignzyPanStage { DEV, PROD }

extension ParsePanSignzyToString on SignzyPanStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}
