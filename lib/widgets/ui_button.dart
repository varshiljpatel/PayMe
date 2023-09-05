import 'package:flutter/material.dart';

Widget uiButton({
  bool isActive = true,
  required VoidCallback onTap,
  required activeColor,
  Color? disabledColor,
  required double width,
  required String title,
  required Color textColor,
}) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: InkWell(
      enableFeedback: (isActive) ? true : false,
      borderRadius: BorderRadius.circular(1000),
      onTap: (isActive) ? onTap : null,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: (!isActive) ? disabledColor : activeColor,
        ),
        height: 64,
        width: width - 48,
        child: Center(
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
