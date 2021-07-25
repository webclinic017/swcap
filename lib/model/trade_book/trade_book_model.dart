// To parse this JSON data, do
//
//     final tradeBookModel = tradeBookModelFromJson(jsonString);

import 'dart:convert';

TradeBookModel tradeBookModelFromJson(String str) => TradeBookModel.fromJson(json.decode(str));

String tradeBookModelToJson(TradeBookModel data) => json.encode(data.toJson());

class TradeBookModel {
  TradeBookModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory TradeBookModel.fromJson(Map<String, dynamic> json) => TradeBookModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.tradeBookId,
    this.tradeCategory,
    this.tradeIn,
    this.scriptName,
    this.tradeDate,
    this.tradeTime,
    this.buySell,
    this.quantity,
    this.price,
    this.tradeProduct,
    this.tradeOrder,
    this.tradeStoploss,
    this.tradeTarget,
    this.tradeStoplossPrice,
    this.tradeStoplossQuantity,
    this.tradeTargetPrice,
    this.tradeTargetQuantity,
    this.tradeVariety,
    this.tradeValidity,
    this.clientId,
    this.tradeCreatedAt,
  });

  String tradeBookId;
  String tradeCategory;
  String tradeIn;
  String scriptName;
  String tradeDate;
  String tradeTime;
  String buySell;
  String quantity;
  String price;
  String tradeProduct;
  String tradeOrder;
  String tradeStoploss;
  String tradeTarget;
  String tradeStoplossPrice;
  String tradeStoplossQuantity;
  String tradeTargetPrice;
  String tradeTargetQuantity;
  String tradeVariety;
  String tradeValidity;
  String clientId;
  DateTime tradeCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tradeBookId: json["trade_book_id"],
    tradeCategory: json["trade_category"],
    tradeIn: json["trade_in"],
    scriptName: json["script_name"],
    tradeDate: json["trade_date"],
    tradeTime: json["trade_time"],
    buySell: json["buy_sell"],
    quantity: json["quantity"],
    price: json["price"],
    tradeProduct: json["trade_product"],
    tradeOrder: json["trade_order"],
    tradeStoploss: json["trade_stoploss"],
    tradeTarget: json["trade_target"],
    tradeStoplossPrice: json["trade_stoploss_price"],
    tradeStoplossQuantity: json["trade_stoploss_quantity"],
    tradeTargetPrice: json["trade_target_price"],
    tradeTargetQuantity: json["trade_target_quantity"],
    tradeVariety: json["trade_variety"],
    tradeValidity: json["trade_validity"],
    clientId: json["client_id"],
    tradeCreatedAt: DateTime.parse(json["trade_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "trade_book_id": tradeBookId,
    "trade_category": tradeCategory,
    "trade_in": tradeIn,
    "script_name": scriptName,
    "trade_date": tradeDate,
    "trade_time": tradeTime,
    "buy_sell": buySell,
    "quantity": quantity,
    "price": price,
    "trade_product": tradeProduct,
    "trade_order": tradeOrder,
    "trade_stoploss": tradeStoploss,
    "trade_target": tradeTarget,
    "trade_stoploss_price": tradeStoplossPrice,
    "trade_stoploss_quantity": tradeStoplossQuantity,
    "trade_target_price": tradeTargetPrice,
    "trade_target_quantity": tradeTargetQuantity,
    "trade_variety": tradeVariety,
    "trade_validity": tradeValidity,
    "client_id": clientId,
    "trade_created_at": tradeCreatedAt.toIso8601String(),
  };
}
