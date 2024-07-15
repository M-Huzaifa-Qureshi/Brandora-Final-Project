import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final int? maxLines;
  final String?hinText;
  final InputBorder? border;
  final String?labelText;
  final TextEditingController?controller;final InputDecoration? decoration = const InputDecoration();
  final String? Function(String?)? validator;
  final bool obscureText = false;
  const CustomField({super.key,  this.maxLines, this.hinText, this.labelText, this.controller, this.validator, this.border,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      validator: validator,
      controller: controller,
      obscureText:obscureText ,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hinText,
        labelText: labelText,
      ),
    );
  }
}
