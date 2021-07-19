import 'package:flutter/material.dart';
import 'package:swcap/auth/login.dart';
import 'package:swcap/config/app_config.dart';
import 'package:swcap/notifier/theme_notifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  CustomTheme currentTheme = CustomTheme();

  @override
  void initState() {
    currentTheme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SWCAP',
      theme: AppConfig.darkTheme,
      home: Login(),
      darkTheme: AppConfig.darkTheme,
      themeMode: currentTheme.currentTheme,
    );
  }
}
