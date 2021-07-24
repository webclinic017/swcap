// To parse this JSON data, do
//
//     final orderBookModel = orderBookModelFromJson(jsonString);

import 'dart:convert';

OrderBookModel orderBookModelFromJson(String str) => OrderBookModel.fromJson(json.decode(str));

String orderBookModelToJson(OrderBookModel data) => json.encode(data.toJson());

class OrderBookModel {
  OrderBookModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory OrderBookModel.fromJson(Map<String, dynamic> json) => OrderBookModel(
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
    this.orderBookId,
    this.orderCategory,
    this.scriptName,
    this.orderDate,
    this.orderTime,
    this.buySell,
    this.quantity,
    this.price,
    this.adminId,
    this.orderCreatedAt,
  });

  String orderBookId;
  String orderCategory;
  String scriptName;
  String orderDate;
  String orderTime;
  String buySell;
  String quantity;
  String price;
  String adminId;
  DateTime orderCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    orderBookId: json["order_book_id"],
    orderCategory: json["order_category"],
    scriptName: json["script_name"],
    orderDate: json["order_date"],
    orderTime: json["order_time"],
    buySell: json["buy_sell"],
    quantity: json["quantity"],
    price: json["price"],
    adminId: json["admin_id"],
    orderCreatedAt: DateTime.parse(json["order_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "order_book_id": orderBookId,
    "order_category": orderCategory,
    "script_name": scriptName,
    "order_date": orderDate,
    "order_time": orderTime,
    "buy_sell": buySell,
    "quantity": quantity,
    "price": price,
    "admin_id": adminId,
    "order_created_at": orderCreatedAt.toIso8601String(),
  };
}
