import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/auth/login.dart';
import 'package:swcap/config/user_config.dart';
import 'package:swcap/pages/future_option/future_option_realtime.dart';
import 'package:swcap/pages/homepage.dart';
import 'package:swcap/pages/order_book/order_book.dart';
import 'package:swcap/pages/trade_book/trade_book.dart';

class CustomDrawer extends StatefulWidget {
  final Timer timer;
  const CustomDrawer({Key key, this.timer}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  String userName;
  String userUserName;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  _getUserData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userName = pref.getString("userName");
      userUserName = pref.getString("userUserName");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text("${userName}"), accountEmail: Text("${userUserName}")),
          ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
            },
            title: Text("Home" , style: GoogleFonts.poppins(),),
          ),
          ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => FutureOptionRealTime(),));
            },
            title: Text("Future Option" , style: GoogleFonts.poppins(),),
          ),
          ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => TradeBook(),));
            },
            title: Text("Trade Book" , style: GoogleFonts.poppins(),),
          ),
          ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderBook(),));
            },
            title: Text("Order Book" , style: GoogleFonts.poppins(),),
          ),
          ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              UserConfig.unsetUserSession();
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
            },
            title: Text("Logout" , style: GoogleFonts.poppins(),),
          )
        ],
      ),
    );
  }
}
