import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/order_book_api.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/model/order_book/fetch_order_book.dart';
import 'package:swcap/pages/order_book/add_order_book.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrder(userID: userID)));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder<OrderBookModel>(
          future: _orderBookModel,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.status){
                return HorizontalDataTable(
                    itemCount: snapshot.data.data.length,
                    rightHandSideColBackgroundColor: AppConfig.kDeepDarkColor,
                    leftHandSideColBackgroundColor: AppConfig.kDeepDarkColor,
                    leftHandSideColumnWidth: 100,
                    headerWidgets: _getTitleWidget(),
                    scrollPhysics: AlwaysScrollableScrollPhysics(),
                    tableHeight: MediaQuery.of(context).size.height,
                    rightHandSideColumnWidth: MediaQuery.of(context).size.width * 2,
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
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: _getTitleItemWidget('Price', 100),
      ),
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
      child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context,Datum script ,int index) {

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text("${script.price}" , style: GoogleFonts.poppins(),)
              ],
            ),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.quantity}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.buySell}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.orderCategory}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.orderDate}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.orderTime}" , style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.orderCreatedAt}" , style: GoogleFonts.poppins()),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

}
