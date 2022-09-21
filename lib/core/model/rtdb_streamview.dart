

// import 'dart:convert';

// BrandsModel brandsFromJson(String str) =>
//     BrandsModel.fromJson(json.decode(str));

// // function to call for encoding the url used for post method
// String brandsToJson(List<BrandsModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // our main superclass for category model
// class BrandsModel {
//   // everything that first map contains from the json file that the api returns

//   String field;
//   List<BrandsResponse> resposne;
//   BrandsModel({
//     required this.errorStatus,
//     required this.errorMessage,
//     required this.resposne,
//   });

//   factory BrandsModel.fromJson(Map<String, dynamic> json) => BrandsModel(
//         errorStatus: json["errorStatus"],
//         errorMessage: json["errorMessage"],
//         resposne: List<BrandsResponse>.from(
//             json["response"].map((x) => BrandsResponse.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "errorStatus": errorStatus,
//         "errorMessage": errorMessage,
//         "response": List<dynamic>.from(resposne.map((x) => x.toJson())),
//       };
// }

// // super class for the [response] that contains list of categories.
// class BrandsResponse {
//   int brandId;
//   String brandName;
//   String brandIcon;
//   BrandsResponse({
//     required this.brandId,
//     required this.brandName,
//     required this.brandIcon,
//   });

//   factory BrandsResponse.fromJson(Map<String, dynamic> json) => BrandsResponse(
//         brandId: json["brandId"],
//         brandName: json["brandName"],
//         brandIcon: json["brandIcon"],
//       );

//   Map<String, dynamic> toJson() => {
//         "brandId": brandId,
//         "brandName": brandName,
//         "brandIcon": brandIcon,
//       };
// }
