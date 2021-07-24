import 'package:flutter/material.dart';
import 'package:swcap/config/app_config.dart';

class CustomTextButton extends StatelessWidget {

  final void Function() onPressed;
  final String title;
  final bool isLoading;

  const CustomTextButton({Key key, this.onPressed, this.title, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isLoading ? MaterialButton(
      color: AppConfig.kMediumDarkColor,
      onPressed: onPressed,
      child: Text(title),
      textColor: Colors.white,
      elevation: 5,
    ) : Container(
      child: Center(child: CircularProgressIndicator(),),
    );
  }
}