import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignWithCustomButton extends StatelessWidget {
  final String content;
  final String icon;
  final double height;
  final VoidCallback onPressed;
  final MaterialStateProperty<Color> backColor;
  final Color fontColor;

  SignWithCustomButton({
    @required this.content,
    @required this.icon,
    @required this.height,
    @required this.onPressed,
    this.backColor,
    this.fontColor,

  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        height: this.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(icon, width: 30, height: 30,),
            Text(
              content,
              style:
              TextStyle(fontSize: 22, color: fontColor ?? Color.fromRGBO(40, 53, 85, 1)),
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        backgroundColor: backColor ?? MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.white;
          },
        ),
      ),
    );
  }
}