import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String text;
  const CustomText(
      {super.key,
      this.color,
      this.fontWeight,
      this.fontSize,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color, fontWeight: fontWeight, fontSize: fontSize));
  }
}
