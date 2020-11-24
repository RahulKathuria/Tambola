import 'package:flutter/material.dart';

class Mynumber extends StatelessWidget {
  final buttonText;
  final buttonColor;

  Mynumber({this.buttonText, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding : EdgeInsets.all(8),
      child:Text(buttonText,style: TextStyle(
      color: buttonColor,
      fontSize: 16,
      fontWeight: FontWeight.bold
      ),),
    );
  }
}
