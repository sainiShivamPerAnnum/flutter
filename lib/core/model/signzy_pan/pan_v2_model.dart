class PanV2Model {
  String id;
  String patronId;
  Result result;

  PanV2Model({this.id, this.patronId, this.result});

  PanV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patronId = json['patronId'];

    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['patronId'] = this.patronId;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String name;
  String number;
  bool isValid;
  String firstName;
  String middleName;
  String lastName;
  String panStatus;

  Result({
    this.name,
    this.number,
    this.isValid,
    this.firstName,
    this.middleName,
    this.lastName,
    this.panStatus,
  });

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];

    isValid = json['isValid'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];

    panStatus = json['panStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;

    data['isValid'] = this.isValid;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;

    data['panStatus'] = this.panStatus;

    return data;
  }
}
