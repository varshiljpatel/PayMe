import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget qrSaveWidget(BuildContext context, String pn, String pa, String upiUri) {
  return Container(
    color: white100,
    width: 400,
    height: 450,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ic_logo_light_banner,
              colorFilter: ColorFilter.mode(black100, BlendMode.srcIn),
              width: 400 / 3,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Pay to ${pn.toUpperCase()}",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: black100,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 36,
            ),
            QrImageView(
                data: upiUri,
                padding: const EdgeInsets.all(0),
                size: 400 / 2,
                errorCorrectionLevel: QrErrorCorrectLevel.L,
                version: QrVersions.auto),
            const SizedBox(
              height: 20,
            ),
            Text(
              pa,
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: black75,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
          ],
        ),
      ),
    ),
  );
}
