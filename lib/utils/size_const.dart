import 'package:flutter/material.dart';

getMediaWidth(BuildContext context) {
  if (context.mounted) {
    return MediaQuery.of(context).size.width;
  }
  return null;
}

getMediaHeight(BuildContext context) {
  if (context.mounted) {
    return MediaQuery.of(context).size.height;
  }
  return null;
}
