import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/kite_api.dart';
import 'package:swcap/api/order_book_api.dart';
import 'package:swcap/api/trade_book_api.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/model/kite/kite_script_model.dart';
import 'package:swcap/model/order_book/fetch_order_book.dart';

class OrderBook extends StatefulWidget {
  const OrderBook({Key key}) : super(key: key);

  @override
  _OrderBookState createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> {

  Future<OrderBookModel> _orderBookModel;
  String userID;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  _getUserData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

    _fetchTradeBooks();

  }

  _fetchTradeBooks() async {

    final orderbook = OrderBookApi.fetchOrderBook(userID);

    setState(() {
      _orderBookModel = orderbook;
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrderBook", style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16
        ),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderBook(),));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.sync , color: Colors.white,),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrder(userID: userID)));
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder<OrderBookModel>(
          future: _orderBookModel,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.status){
                return HorizontalDataTable(
                    leftHandSideColBackgroundColor: AppConfig.kDeepDarkColor,
                    rightHandSideColBackgroundColor: AppConfig.kDeepDarkColor,
                    itemCount: snapshot.data.data.length,
                    leftHandSideColumnWidth: 100,
                    enablePullToRefresh: true,
                    refreshIndicator: WaterDropHeader(),
                    refreshIndicatorHeight: 60,
                    rowSeparatorWidget: Divider(color: Colors.white,),
                    htdRefreshController: HDTRefreshController(),
                    onRefresh: () async {
                      print("refreshed");
                      HDTRefreshController().refreshCompleted();
                    },
                    tableHeight: MediaQuery.of(context).size.height,
                    rightHandSideColumnWidth: MediaQuery.of(context).size.width * 2,
                    isFixedHeader: true,
                    headerWidgets: _getTitleWidget(),
                    leftSideItemBuilder: (context, index) {
                      var trade = snapshot.data.data[index];
                      return Container(
                        child: Text(trade.scriptName , style: GoogleFonts.poppins(),),
                        width: 100,
                        height: 52,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                      );
                    },
                    rightSideItemBuilder: (context, index) {
                      var script = snapshot.data.data[index];

                      return _generateRightHandSideColumnRow(context, script, index);
                    }
                );
              }else{
                return Container(
                  child: Center(
                    child: Text("No Data Found"),
                  ),
                );
              }
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }else{
              return Container(child: Center(child: CircularProgressIndicator(),),);
            }
          },
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Script', 100),
      _getTitleItemWidget('Last Price', 100),
      _getTitleItemWidget('Price', 100),
      _getTitleItemWidget('Quantity', 100),
      _getTitleItemWidget('Type', 100),
      _getTitleItemWidget('Category', 100),
      _getTitleItemWidget('Date', 100),
      _getTitleItemWidget('Time', 100),
      _getTitleItemWidget('Created', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey
      ),
      child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Timer _timer;

  _realTimeTimer(script , _orderStream) async {

    if(_timer != null && !_timer.isActive){
      _timer = Timer.periodic(Duration(
        seconds: 2
      ), (timer) {
        print(timer);
        _getScriptData(script, _orderStream);
      });
    }

  }

  _getScriptData(script , StreamController stream) async {
    try{
      KiteApi.getScriptData(script , "NSE").then((value) {
        stream.add(value);
      });

    }catch(e){
      print(e);
    }
  }

  _updateTrade(tradeID , tradeData) async {

    final response = await TradeBookApi.updateTradeBook(tradeID, tradeData);

    if(response.status){
      print("Trade Updated");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderBook(),));

    }else{
      print("Something went wrong");
    }

  }

  Widget _generateRightHandSideColumnRow(BuildContext context,Datum script ,int index) {

    StreamController<KiteScriptDataModel> _orderStream = StreamController();
    if(_timer != null){
      print(_timer.tick);
      _realTimeTimer(script, _orderStream);
    }
    _getScriptData(script.scriptName, _orderStream);

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          StreamBuilder<KiteScriptDataModel>(
              stream: _orderStream.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  if(snapshot.data.data != null){
                    if(snapshot.data.status){

                      if(script.buySell == "Buy"){

                        if(double.parse(script.price) >= snapshot.data.data.lastPrice){
                          var tradeData = jsonEncode({
                            "trade_in" : "1"
                          });
                          _updateTrade(script.tradeBookId , tradeData);
                        }else{
                          print("Not Buyed");
                        }

                      }else{

                        if(double.parse(script.price) >= snapshot.data.data.lastPrice){
                          print("Not Buyed");
                        }else{
                          var tradeData = jsonEncode({
                            "trade_in" : "1"
                          });
                          _updateTrade(script.tradeBookId , tradeData);

                        }

                      }

                      return Container(
                        child: Text("${snapshot.data.data.lastPrice}" , style: GoogleFonts.poppins(),),
                        width: 100,
                        height: 52,
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        alignment: Alignment.center,
                      );
                    }else{
                      return Container(
                        child: Text("0" , style: GoogleFonts.poppins(),),
                        width: 80,
                        height: 52,
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        alignment: Alignment.center,
                      );
                    }
                  }else{
                    return Container(
                      child: Text("0" , style: GoogleFonts.poppins(),),
                      width: 80,
                      height: 52,
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      alignment: Alignment.center,
                    );
                  }
                }else if(snapshot.hasError){
                 return Container(
                   child: Row(
                     children: [
                       Text("0" , style: GoogleFonts.poppins(),)
                     ],
                   ),
                   width: 100,
                   height: 52,
                   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                   alignment: Alignment.center,
                 );
                }else{
                  _getScriptData(script, _orderStream);
                  return Text("Please Refresh Now");
                }
              },
          ),
          Container(
            child: Text("${script.price}" , style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.quantity}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.buySell}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.tradeCategory}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.tradeDate}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.tradeTime}" , style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("${script.tradeCreatedAt}" , style: GoogleFonts.poppins()),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

}
