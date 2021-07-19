import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {

  final void Function() onPressed;
  final String title;
  final bool isLoading;

  const CustomTextButton({Key? key, required this.onPressed, required this.title, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isLoading ? MaterialButton(
      onPressed: onPressed,
      child: Text(title),
      textColor: Colors.white,
      elevation: 5,
    ) : CircularProgressIndicator();
  }
}