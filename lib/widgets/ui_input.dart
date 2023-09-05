import 'package:flutter/material.dart';
import 'package:pay_me/utils/colors_const.dart';

TextField inputField(
    {required void Function(String) onChanged, required String label, required TextEditingController controller, TextInputType? keyboardType}) {
  return TextField(
    onChanged: onChanged,
    keyboardType: (null != keyboardType) ? keyboardType : TextInputType.text,
    decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: black75),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              width: 2.0,
              color: black75,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              width: 2.0,
              color: black100,
            ))),
  );
}
