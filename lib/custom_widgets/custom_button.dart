import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String content;
  final double width, height;
  final double fontSize;
  final Color color;
  final Color fontColor;
  final VoidCallback onPressed;

  CustomButton({
    @required this.content,
    @required this.height,
    @required this.width,
    @required this.onPressed,
    this.fontSize,
    this.color,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return color ?? const Color.fromRGBO(74, 84, 143, 1);
          },
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              shadows: const <Shadow>[
                Shadow(color: Color.fromRGBO(0, 0, 0, 0.1))
              ],
              fontSize: fontSize ?? 31,
              color: fontColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ));
  }
}
