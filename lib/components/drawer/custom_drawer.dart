import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/user_api.dart';
import 'package:swcap/auth/login.dart';
import 'package:swcap/config/user_config.dart';
import 'package:swcap/pages/account/account.dart';
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
  String showAccount;

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
      showAccount = pref.getString("userShowAccount");
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
            title: Text("Cash" , style: GoogleFonts.poppins(),),
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
          showAccount == "on" ? ListTile(
            onTap: () {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Account(),));
            },
            title: Text("Account" , style: GoogleFonts.poppins(),),
          ) : SizedBox(),
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
            onTap: () async {
              if(widget.timer != null){
                if(widget.timer.isActive){
                  widget.timer.cancel();
                }
              }

              SharedPreferences pref = await SharedPreferences.getInstance();

              String userID;

              userID = pref.getString("userID");

              final res = await UserApi.updateUser(userID, jsonEncode({
                "is_loggedin" : 0
              }));
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
