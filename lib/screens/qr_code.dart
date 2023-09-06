import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/services/qr_save.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeScreen extends StatefulWidget {
  static route({
    required BuildContext context,
  }) {
    return MaterialPageRoute(builder: (context) => const QrCodeScreen());
  }

  const QrCodeScreen({
    super.key,
  });

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  late String upiUri;
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<String> dirPath() async {
    String? filePath;
    Directory? dir = await getExternalStorageDirectory();
    filePath =
        "${dir?.path}/PayMe-${DateTime.now().microsecondsSinceEpoch}.png";
    return filePath;
  }

  _captureImages(BuildContext context, String pn, String pa) async {
    try {
      Uint8List? image = await _screenshotController
          .captureFromWidget(qrSaveWidget(context, pn, pa, upiUri));
      String imagePath = await dirPath();
      File(imagePath).create(recursive: false);
      File(imagePath).writeAsBytesSync(image);
    } catch (e) {
      if (kDebugMode) {
        print("Error in sync = $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String pa = Provider.of<Payee>(context).upiId.toString();
    String pn = Provider.of<Payee>(context).payeeName.toString();
    String am = Provider.of<Payee>(context).ammount.toString();
    String tn =
        "Pay to ${Provider.of<Payee>(context).payeeName.toString()} With PayMe QR Code";
    upiUri =
        "upi://pay?pa=$pa&pn=${Uri.encodeComponent(pn)}&am=$am&tn=${Uri.encodeComponent(tn)}";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(ic_logo_text,
            colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
            width: 96),
        centerTitle: true,
        backgroundColor: black100,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pay to ${pn.toUpperCase()}",
                      style: TextStyle(
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
                        size: getMediaWidth(context) / 1.75,
                        errorCorrectionLevel: QrErrorCorrectLevel.L,
                        version: QrVersions.auto),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      pa,
                      style: TextStyle(
                          color: black75,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(upi_logo,
                              width: getMediaWidth(context) / 4),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Pay using any upi \npayment gateway!",
                            style: TextStyle(
                              color: black75,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: uiButton(
                    onTap: () async {
                      try {
                        _captureImages(context, pn, pa);
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    activeColor: black100,
                    width: getMediaWidth(context),
                    title: "Download",
                    textColor: white100)),
          ],
        ),
      ),
    );
  }
}
