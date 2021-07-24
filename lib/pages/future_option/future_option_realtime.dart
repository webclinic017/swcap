import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:swcap/api/kite_api.dart';
import 'package:swcap/components/drawer/custom_drawer.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/model/kite/kite_script_model.dart';

class FutureOptionRealTime extends StatefulWidget {
  const FutureOptionRealTime({ Key
  key }) : super(key: key);

  @override
  _FutureOptionRealTimeState createState() => _FutureOptionRealTimeState();
}

class _FutureOptionRealTimeState extends State<FutureOptionRealTime> {

  List _scripts = [];
  StreamController<List> _streamController = StreamController();
  Timer _timer;
  double oldValue = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {

    final response = await KiteApi.getWatchLists("NFO");
    if(response.status){
      response.data.forEach((element) {
        _scripts.add({"script_name" : element.watchlistScriptName});
      });
      _streamController.add(_scripts);
    }

  }

  _startTimer(script ,StreamController stream) async {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      print(timer.tick);
      _getScriptData(script, stream);
    });
  }

  _getScriptData(script , StreamController stream) async {
    try{
      KiteApi.getScriptData(script , "NFO").then((value) {
        stream.add(value);
      });
    }catch(e){
      print(e);
    }
  }

  _storeOldValue(oldV){

    oldValue = oldV;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              if(_timer.isActive){
                _timer.cancel();
              };
              Navigator.push(context, MaterialPageRoute(builder: (context) => FutureOptionRealTime(),));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.sync),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(timer: _timer,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {

              TextEditingController _scriptTextController = TextEditingController();

              return AlertDialog(
                actions: [
                  Container(
                    height: 50,
                    child: TextField(
                      controller: _scriptTextController,
                      decoration: InputDecoration(
                          labelText: "Script",
                          labelStyle: GoogleFonts.poppins(
                              color: Colors.black
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  MaterialButton(
                    onPressed: () async {



                      final response = await KiteApi.addWatchList(_scriptTextController.text , "NFO");

                      if(response.status){
                        if(_scriptTextController.text.isNotEmpty){
                          _scripts.add({
                            "script_name" : "${_scriptTextController.text}",
                          });

                          _streamController.add(_scripts);

                          setState(() {

                          });

                        }else{
                          print("Script not added");
                        }

                        Navigator.pop(context);



                      }else{
                        print("script is empty");
                      }

                    },
                    child: Text("Add" , style: GoogleFonts.poppins(color: Colors.black),),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return HorizontalDataTable(
                        leftHandSideColBackgroundColor: AppConfig.kDarkColor,
                        rightHandSideColBackgroundColor: AppConfig.kDeepDarkColor,
                        itemCount: snapshot.data.length,
                        leftHandSideColumnWidth: 100,
                        enablePullToRefresh: true,
                        refreshIndicator: WaterDropHeader(),
                        refreshIndicatorHeight: 60,
                        htdRefreshController: HDTRefreshController(),
                        onRefresh: () async {
                          print("refreshed");
                        },
                        tableHeight: MediaQuery.of(context).size.height,
                        rightHandSideColumnWidth: MediaQuery.of(context).size.width * 2,
                        isFixedHeader: true,
                        headerWidgets: _getTitleWidget(),
                        leftSideItemBuilder: (context, index) {
                          var script = snapshot.data[index]['script_name'];
                          return Container(
                            child: Text(script , style: GoogleFonts.poppins(),),
                            width: 100,
                            height: 60,
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                          );
                        },
                        rightSideItemBuilder: (context, index) {
                          var script = snapshot.data[index]['script_name'];

                          StreamController<KiteScriptDataModel> _scriptStream = StreamController();

                          if(_timer == null || !_timer.isActive){
                            _startTimer(script , _scriptStream);
                          }

                          _getScriptData(script , _scriptStream);


                          return StreamBuilder<KiteScriptDataModel>(
                            stream: _scriptStream.stream,
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                if(snapshot.data.data != null){
                                  return _generateRightHandSideColumnRow(context , snapshot.data , index);
                                }else{
                                  return Text("Please refresh Now");
                                }
                              }else if(snapshot.hasError){
                                return Text("0");
                              }else{
                                return Text("0");
                              }
                            },
                          );
                        },
                      );
                      // return ListView.builder(
                      //   itemCount: snapshot.data.length,
                      //   itemBuilder: (context, index) {
                      //     var totalScript = snapshot.data.length;
                      //     var script = snapshot.data[index]['script_name'];
                      //
                      //     StreamController<KiteScriptDataModel> _scriptStream = StreamController();
                      //
                      //     _timer = Timer.periodic(Duration(seconds: 2), (timer) {
                      //       KiteApi.getScriptData(script).then((value) {
                      //         _scriptStream.add(value);
                      //       });
                      //     });
                      //
                      //     KiteApi.getScriptData(script).then((value) {
                      //       _scriptStream.add(value);
                      //     });
                      //
                      //     return StreamBuilder<KiteScriptDataModel>(
                      //         stream: _scriptStream.stream,
                      //         builder: (context, snapshot) {
                      //           if(snapshot.hasData){
                      //             return HorizontalDataTable(
                      //               itemCount: totalScript,
                      //               leftHandSideColumnWidth: 100,
                      //               rightHandSideColumnWidth: MediaQuery.of(context).size.width,
                      //               isFixedHeader: true,
                      //               leftSideItemBuilder: (context, index) {
                      //                 return Text(scripts);
                      //               },
                      //             );
                      //           }else{
                      //             return Text("${snapshot.error}");
                      //           }
                      //         },
                      //     );
                      //   },
                      // );
                    }else if(snapshot.hasError){
                      return Text("${snapshot.error}");
                    }else{
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Script', 100),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: _getTitleItemWidget('Last Price', 100),
      ),
      _getTitleItemWidget('L.Quantity', 100),
      _getTitleItemWidget('Volume', 100),
      _getTitleItemWidget('Open', 100),
      _getTitleItemWidget('High', 100),
      _getTitleItemWidget('Low', 100),
      _getTitleItemWidget('Close', 100),
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

  Widget _generateRightHandSideColumnRow(BuildContext context, KiteScriptDataModel script ,int index) {
    if(script != null){
      _storeOldValue(script.data.lastPrice);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text("${script.data.lastPrice}" , style: GoogleFonts.poppins(),)
              ],
            ),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.lastQuantity}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.volume}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.ohlc.open}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.ohlc.high}" ,style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.ohlc.low}" , style: GoogleFonts.poppins(),),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("${script.data.ohlc.close}" , style: GoogleFonts.poppins()),
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