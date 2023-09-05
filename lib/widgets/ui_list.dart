import 'package:flutter/material.dart';
import 'package:pay_me/utils/colors_const.dart';

Widget detailList(String keyString, String valueString) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              keyString,
              style: TextStyle(
                  color: black100, fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
            Text(
              valueString,
              style: TextStyle(
                color: black100,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 24.0,
      )
    ],
  );
}
