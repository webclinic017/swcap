import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/user_api.dart';
import 'package:swcap/components/buttons/text_button.dart';
import 'package:swcap/components/inputs/custom_input.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/model/user/user_model.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  String userID = "";
  UserModel user = UserModel(status: false);

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
       userID = pref.getString("userID");
    });

    await UserApi.fetchUser(userID).then((value) {
      if(value.status){
        user = value;
        setState(() {

        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: UserApi.fetchUser(userID),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.status){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Center(child: Text("Account Details" , style: GoogleFonts.poppins(
                        fontSize: 15
                      ),)),
                      SizedBox(height: 20,),
                      Text("Name" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.name}"),
                      SizedBox(height: 20,),
                      Text("Opening Balance" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.openingBalance}"),
                      SizedBox(height: 20,),
                      Text("Delivery Margin" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.deliveryMargin}"),
                      SizedBox(height: 20,),
                      Text("Span" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.span}"),
                      SizedBox(height: 20,),
                      Text("Exposure" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.exposure}"),
                      SizedBox(height: 20,),
                      Text("Option Premium" , style: GoogleFonts.poppins(),),
                      Text("${snapshot.data.data.openingBalance}"),

                      SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            CustomTextButton(
                              onPressed: () => Navigator.pop(context) ,
                              title: "Back",
                              isLoading: false,
                            ),
                            MaterialButton(
                              color: Colors.green,
                              elevation: 8,
                              onPressed: () {
                                TextEditingController _payOut = TextEditingController();

                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder: (context, setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppConfig.kDeepDarkColor
                                          ),
                                          height: MediaQuery.of(context).size.height * 0.6,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                CustomInput(
                                                  textEditingController: _payOut,
                                                  showLabel: true,
                                                  showHint: false,
                                                  labelText: "Money",
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextButton(
                                                  isLoading: false,
                                                  onPressed: () async {
                                                    var data = jsonEncode({
                                                      "client_id" : userID,
                                                      "status" : "0"
                                                    });

                                                    final res = await UserApi.sendPayoutRequest(data);

                                                    Navigator.pop(context);
                                                  },
                                                  title: "Send Request",
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },);
                                    },
                                );
                              },
                              child: Text("Request Pay Out" , style: GoogleFonts.poppins(
                                color: Colors.white
                              ),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }else{
                return Text("Something went wrong : ${userID}");
              }
            }else if(snapshot.hasError){
              return Text("Something went wrong");
            }else{
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ),
    );
  }
}
