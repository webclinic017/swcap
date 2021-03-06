import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/trade_book_api.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/model/trade_book/trade_book_model.dart';
import 'package:swcap/pages/trade_book/add_trade_book.dart';

class TradeBook extends StatefulWidget {
  const TradeBook({Key key}) : super(key: key);

  @override
  _TradeBookState createState() => _TradeBookState();
}

class _TradeBookState extends State<TradeBook> {

  Future<TradeBookModel> _tradeBookModel;
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

    final tradebook = TradeBookApi.fetchTradeBook(userID);

    setState(() {
      _tradeBookModel = tradebook;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("TradeBook", style: GoogleFonts.poppins(
           color: Colors.white,
           fontSize: 16
         ),),
         centerTitle: true,
         actions: [
           InkWell(
             onTap: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TradeBook(),));
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
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddTrade(userID: userID)));
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder<TradeBookModel>(
          future: _tradeBookModel,
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
                        child: Text("${trade.scriptName}" , style: GoogleFonts.poppins(),),
                        width: 100,
                        height: 52,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
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
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context,Datum script ,int index) {

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: <Widget>[
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
