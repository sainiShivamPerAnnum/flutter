import 'package:json_annotation/json_annotation.dart';

part 'advisor_upcoming_call.g.dart';

@JsonSerializable()
class AdvisorCall {
  final String? userName;
  final DateTime scheduledOn;
  final String duration;
  final String? callLink;
  final List<Map<String, String>> detailsQA;

  AdvisorCall({
    required this.scheduledOn,
    required this.duration,
    this.userName,
    this.callLink,
    this.detailsQA = const [],
  });

  factory AdvisorCall.fromJson(Map<String, dynamic> json) =>
      _$AdvisorCallFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorCallToJson(this);
}
