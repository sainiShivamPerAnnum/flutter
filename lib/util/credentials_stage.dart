enum AWSStage{
  DEV,
  PROD
}

extension ParseAwsToString on AWSStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum SignzyStage{
  DEV,
  PROD
}

extension ParseSignzyToString on SignzyStage {
  String value() {
    return this.toString().split('.').last.toLowerCase();
  }
}