import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swcap/config/api_urls.dart';
import 'package:swcap/model/global/global_model.dart';
import 'package:swcap/model/order_book/fetch_order_book.dart';

class OrderBookApi {

  static Future<OrderBookModel> fetchOrderBook(userID) async {

    final client = http.Client();

    OrderBookModel thisResponse = OrderBookModel();

    try{

      final response = await client.get(Uri.parse(ApiUrl.fetchOrderBookApiUrl+"?user_id="+userID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = orderBookModelFromJson(response.body);

        }else{
          thisResponse = OrderBookModel(
            status: false,
            data: []
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code : ${response.statusCode} ");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

  static Future<GlobalModel> createOrderBook(orderData) async {

    final client = http.Client();

    GlobalModel thisResponse = GlobalModel();

    try{

      final response = await client.post(Uri.parse(ApiUrl.createOrderBook) , body: {
        "orderbook_data" : orderData
      });

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = globalModelFromJson(response.body);

        }else{
          thisResponse = GlobalModel(
              status: false,
              data: null
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code : ${response.body} ");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

}