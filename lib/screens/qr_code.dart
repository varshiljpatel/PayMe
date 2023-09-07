import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/services/qr_save.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/utils/snake_bar.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<String?> dirPath() async {
    try {
      // final directory = await getExternalStorageDirectory();
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');

      // Create the 'Downloads' directory if it doesn't exist
      if (!await downloadsDirectory.exists()) {
        downloadsDirectory = Directory('/storage/emulated/0/Downloads');
        if (!await downloadsDirectory.exists()) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
          await downloadsDirectory.create(recursive: true);
        }
      }

      final imagePath =
          "${downloadsDirectory.path}/PayMe-${DateTime.now().microsecondsSinceEpoch}.png";
      return imagePath;
    } catch (e) {
      if (kDebugMode) {
        print("Error in dirPath: $e");
      }
    }
    return null;
  }

  _captureImages(BuildContext context, String pn, String pa) async {
    try {
      Uint8List? image = await _screenshotController
          .captureFromWidget(qrSaveWidget(context, pn, pa, upiUri));
      String? imagePath = await dirPath();
      if (await Permission.storage.isGranted) {
        // Permission.photos.request();
        if (imagePath != null) {
          File(imagePath).create(recursive: false);
          File(imagePath).writeAsBytesSync(image);
        } else {
          if (context.mounted) {
            showSnakeBar(context: context, content: "Something is wrong!");
          }
        }
      } else {
        Permission.storage.request();
      }
    } catch (e) {
      if (context.mounted) {
        showSnakeBar(context: context, content: "Something is wrong");
      }
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
            (Platform.isAndroid)
                ? Positioned(
                    bottom: 0,
                    child: uiButton(
                        onTap: () async {
                          try {
                            await _captureImages(context, pn, pa);
                            if (context.mounted) {
                              showSnakeBar(
                                  context: context,
                                  content: "Downloaded successfully!");
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showSnakeBar(
                                  context: context,
                                  content: "Something is wrong");
                            }
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                        activeColor: black100,
                        width: getMediaWidth(context),
                        title: "Download",
                        textColor: white100))
                : const SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }
}
