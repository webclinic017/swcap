import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swcap/components/buttons/text_button.dart';
import 'package:swcap/components/inputs/custom_input.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/pages/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _loginProcess() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  CustomInput _username = CustomInput(showHint: false, isPassword: false, showLabel: true, labelText: "Username",);
  CustomInput _password = CustomInput(showHint: false, isPassword: true, showLabel: true, labelText: "Password",);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      vertical: 15
                    ),
                    child: Center(
                      child: Text("Login Here" , style: Theme.of(context).textTheme.bodyText2,),
                    )
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                    child: _username,
                  ),
                  _password,
                  SizedBox(height: 20,),
                  Container(
                    child: CustomTextButton(
                      onPressed: () {
                        print("Loggin in");
                        _loginProcess();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
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
    );
  }
}
