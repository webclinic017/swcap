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
    this.scriptName,
    this.tradeDate,
    this.tradeTime,
    this.buySell,
    this.quantity,
    this.price,
    this.adminId,
    this.tradeCreatedAt,
  });

  String tradeBookId;
  String tradeCategory;
  String scriptName;
  String tradeDate;
  String tradeTime;
  String buySell;
  String quantity;
  String price;
  String adminId;
  DateTime tradeCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tradeBookId: json["trade_book_id"],
    tradeCategory: json["trade_category"],
    scriptName: json["script_name"],
    tradeDate: json["trade_date"],
    tradeTime: json["trade_time"],
    buySell: json["buy_sell"],
    quantity: json["quantity"],
    price: json["price"],
    adminId: json["admin_id"],
    tradeCreatedAt: DateTime.parse(json["trade_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "trade_book_id": tradeBookId,
    "trade_category": tradeCategory,
    "script_name": scriptName,
    "trade_date": tradeDate,
    "trade_time": tradeTime,
    "buy_sell": buySell,
    "quantity": quantity,
    "price": price,
    "admin_id": adminId,
    "trade_created_at": tradeCreatedAt.toIso8601String(),
  };
}
