import 'dart:developer';

class UtilitiesPrice {
  late double waterFee;
  late double internetFee;
  late double electricityUnitPrice;
  late String uuid;

  UtilitiesPrice({
    required this.waterFee,
    required this.internetFee,
    required this.electricityUnitPrice,
    required this.uuid,
  });

  UtilitiesPrice.fromJson(Map<String, dynamic> obj) {
    waterFee = obj["water"];
    internetFee = obj["internet"];
    electricityUnitPrice = obj["electricity"];
    uuid = obj["uuid"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["water"] = waterFee;
    map["internet"] = internetFee;
    map["electricity"] = electricityUnitPrice;
    map["uuid"] = uuid;
    return map;
  }
}
