import 'package:flutter/material.dart';
import 'package:pay_me/utils/colors_const.dart';

  void showSnakeBar({required BuildContext context,required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          content,
          style: const TextStyle(height: 1.2),
        ),
        showCloseIcon: true,
        closeIconColor: white100,
        behavior: SnackBarBehavior.floating));
  }
