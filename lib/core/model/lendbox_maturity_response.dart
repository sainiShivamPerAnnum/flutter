class LendboxMaturityResponse {
  final String? message;
  final LendboxMaturityData? data;

  LendboxMaturityResponse({
    this.message,
    this.data,
  });

  factory LendboxMaturityResponse.fromJson(Map<String, dynamic> json) =>
      LendboxMaturityResponse(
        message: json["message"],
        data: json["data"] == null
            ? null
            : LendboxMaturityData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class LendboxMaturityData {
  final List<Deposit>? deposits;

  LendboxMaturityData({
    this.deposits,
  });

  factory LendboxMaturityData.fromJson(Map<String, dynamic> json) =>
      LendboxMaturityData(
        deposits: json["deposits"] == null
            ? []
            : List<Deposit>.from(
                json["deposits"]!.map((x) => Deposit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "deposits": deposits == null
            ? []
            : List<dynamic>.from(deposits!.map((x) => x.toJson())),
      };
}

class Deposit {
  final String? txnId;
  final String? fundType;
  final String? fdDuration;
  final String? decisionMade;
  final bool? hasConfirmed;
  final int? investedAmt;
  final DateTime? investedOn;
  final int? maturesInDays;
  final int? maturityAmt;
  final DateTime? maturityOn;
  final String? roiPerc;
  final List<DecisionsAvailable>? decisionsAvailable;
  final String? sliderText;

  Deposit({
    this.txnId,
    this.fundType,
    this.fdDuration,
    this.decisionMade,
    this.hasConfirmed,
    this.investedAmt,
    this.investedOn,
    this.maturesInDays,
    this.maturityAmt,
    this.maturityOn,
    this.roiPerc,
    this.decisionsAvailable,
    this.sliderText,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
        txnId: json["txnId"],
        fundType: json["fundType"],
        fdDuration: json["fdDuration"],
        decisionMade: json["decisionMade"],
        hasConfirmed: json["hasConfirmed"],
        investedAmt: json["investedAmt"],
        investedOn: json["investedOn"] == null
            ? null
            : DateTime.parse(json["investedOn"]),
        maturesInDays: json["maturesInDays"],
        maturityAmt: json["maturityAmt"],
        maturityOn: json["maturityOn"] == null
            ? null
            : DateTime.parse(json["maturityOn"]),
        roiPerc: json["roiPerc"],
        decisionsAvailable: json["decisionsAvailable"] == null
            ? []
            : List<DecisionsAvailable>.from(json["decisionsAvailable"]!
                .map((x) => DecisionsAvailable.fromJson(x))),
        sliderText: json["sliderText"],
      );

  Map<String, dynamic> toJson() => {
        "txnId": txnId,
        "fundType": fundType,
        "fdDuration": fdDuration,
        "decisionMade": decisionMade,
        "hasConfirmed": hasConfirmed,
        "investedAmt": investedAmt,
        "investedOn": investedOn?.toIso8601String(),
        "maturesInDays": maturesInDays,
        "maturityAmt": maturityAmt,
        "maturityOn": maturityOn?.toIso8601String(),
        "roiPerc": roiPerc,
        "decisionsAvailable": decisionsAvailable == null
            ? []
            : List<dynamic>.from(decisionsAvailable!.map((x) => x.toJson())),
        "sliderText": sliderText,
      };
}

class DecisionsAvailable {
  final String? pref;
  final String? title;
  final String? subtitle;
  final Footer? footer;
  final String? topChip;
  final OnDecisionMade? onDecisionMade;

  DecisionsAvailable({
    this.pref,
    this.title,
    this.subtitle,
    this.footer,
    this.topChip,
    this.onDecisionMade,
  });

  factory DecisionsAvailable.fromJson(Map<String, dynamic> json) =>
      DecisionsAvailable(
        pref: json["pref"],
        title: json["title"],
        subtitle: json["subtitle"],
        footer: json["footer"] == null ? null : Footer.fromJson(json["footer"]),
        topChip: json["topChip"],
        onDecisionMade: json["onDecisionMade"] == null
            ? null
            : OnDecisionMade.fromJson(json["onDecisionMade"]),
      );

  Map<String, dynamic> toJson() => {
        "pref": pref,
        "title": title,
        "subtitle": subtitle,
        "footer": footer?.toJson(),
        "topChip": topChip,
        "onDecisionMade": onDecisionMade?.toJson(),
      };
}

class Footer {
  final String? text;
  final String? icon;

  Footer({
    this.text,
    this.icon,
  });

  factory Footer.fromJson(Map<String, dynamic> json) => Footer(
        text: json["text"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "icon": icon,
      };
}

class OnDecisionMade {
  final String? fdDuration;
  final String? footer;
  final String? fundType;
  final int? investedAmt;
  final DateTime? investedOn;
  final int? maturityAmt;
  final DateTime? maturityOn;
  final String? roiPerc;
  final String? title;
  final String? topChipText;

  OnDecisionMade({
    this.fdDuration,
    this.footer,
    this.fundType,
    this.investedAmt,
    this.investedOn,
    this.maturityAmt,
    this.maturityOn,
    this.roiPerc,
    this.title,
    this.topChipText,
  });

  factory OnDecisionMade.fromJson(Map<String, dynamic> json) => OnDecisionMade(
        fdDuration: json["fdDuration"],
        footer: json["footer"],
        fundType: json["fundType"],
        investedAmt: json["investedAmt"],
        investedOn: json["investedOn"] == null
            ? null
            : DateTime.parse(json["investedOn"]),
        maturityAmt: json["maturityAmt"],
        maturityOn: json["maturityOn"] == null
            ? null
            : DateTime.parse(json["maturityOn"]),
        roiPerc: json["roiPerc"],
        title: json["title"],
        topChipText: json["topChipText"],
      );

  Map<String, dynamic> toJson() => {
        "fdDuration": fdDuration,
        "footer": footer,
        "fundType": fundType,
        "investedAmt": investedAmt,
        "investedOn": investedOn?.toIso8601String(),
        "maturityAmt": maturityAmt,
        "maturityOn": maturityOn?.toIso8601String(),
        "roiPerc": roiPerc,
        "title": title,
        "topChipText": topChipText,
      };
}
