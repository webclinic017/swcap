import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swcap/api/auth_api.dart';
import 'package:swcap/components/buttons/text_button.dart';
import 'package:swcap/components/inputs/custom_input.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/config/user_config.dart';
import 'package:swcap/pages/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isLoading = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String userType = "1";

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  _getUserData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.get("isLogged") != null ){

      if(pref.getBool("isLogged")){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }

    }

  }

  _loginProcess() async {

    if(_usernameController.text.isEmpty || _passwordController.text.isEmpty){

    }else{
      setState(() {
        _isLoading = !_isLoading;
      });

      final response = await AuthApi.userLogin(_usernameController.text, _passwordController.text);
      print(response.status);
      if(response.status){
        UserConfig.setUserSession(response);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }else{
        setState(() {
          _isLoading = !_isLoading;
        });
      }


    }


  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        await exit(0);
      },
      child: Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            color: AppConfig.kDarkColor,
            child: Center(
              child: Container(
                width: AppConfig.kIsWebs || AppConfig.kIsWindows ? size.width * 0.4 : size.width * 0.8,
                height: AppConfig.kIsWebs || AppConfig.kIsWindows ? size.height * 0.45 : size.height * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConfig.kDarkColor,
                      AppConfig.kDarkColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(2,4),
                      spreadRadius: 6
                    )
                  ]
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10
                      ),
                      child: Center(
                        child: Text("Login Here" , style: Theme.of(context).textTheme.bodyText2,),
                      )
                    ),
                    Divider(color: AppConfig.kLightColor,),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10
                      ),
                      child: CustomInput(showHint: false, isPassword: false, showLabel: true, labelText: "Username",textEditingController: _usernameController,),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10
                      ),
                      child: CustomInput(showHint: false, isPassword: true, showLabel: true, labelText: "Password", textEditingController: _passwordController,),
                    ),
                    SizedBox(height: 10,),

                    Container(
                      child: CustomTextButton(
                        onPressed: () {
                          print("Loggin in");
                          _loginProcess();
                        },
                        isLoading: _isLoading,
                        title: "Login",
                      )
                    )
                  ],
                ),
              ),
            ),
            ),
      ),
    );
  }
}
