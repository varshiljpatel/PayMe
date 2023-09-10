import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/services/qr_save.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/request.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/utils/snake_bar.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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
          return imagePath;
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 24.0),
                                  insetPadding: const EdgeInsets.all(24),
                                  iconPadding: const EdgeInsets.only(top: 36),
                                  actionsPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 24.0),
                                  backgroundColor: black75,
                                  icon: Icon(
                                    Icons.image_outlined,
                                    color: white100,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  title: Text(
                                    "Download or Share image file directly.",
                                    style: TextStyle(
                                        color: white100, fontSize: 20),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            "Share",
                                            style: TextStyle(color: white100),
                                          ),
                                          onPressed: () async {
                                            if ((await Permission
                                                        .storage.isGranted ||
                                                    await Permission
                                                        .photos.isGranted) &&
                                                context.mounted) {
                                              XFile shareString = XFile(
                                                  await _captureImages(
                                                      context, pn, pa));
                                              await Share.shareXFiles(
                                                  [shareString],
                                                  text: "Share QR Code");
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              var req = requestPermission([
                                                Permission.storage,
                                                Permission
                                                    .manageExternalStorage,
                                                Permission.photos
                                              ]);
                                              if (context.mounted && !req) {
                                                showSnakeBar(
                                                    context: context,
                                                    content:
                                                        "Permission required");
                                              }
                                            }
                                          },
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              child: Text(
                                                "Cancel",
                                                style:
                                                    TextStyle(color: white50),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Download",
                                                style:
                                                    TextStyle(color: white100),
                                              ),
                                              onPressed: () async {
                                                Timer(
                                                    const Duration(seconds: 1),
                                                    () async {
                                                  if ((await Permission.storage
                                                              .isGranted ||
                                                          await Permission
                                                              .photos
                                                              .isGranted) &&
                                                      context.mounted) {
                                                    Future<String>
                                                        downloadStringPathFuture =
                                                        _captureImages(
                                                            context, pn, pa);
                                                    downloadStringPathFuture
                                                        .then((value) {
                                                      String
                                                          downloadStringPath =
                                                          value;
                                                      if (context.mounted &&
                                                          downloadStringPath
                                                              .isNotEmpty) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showSnakeBar(
                                                            context: context,
                                                            content:
                                                                "Downloaded successfully!");
                                                      } else {
                                                        var req =
                                                            requestPermission([
                                                          Permission.storage,
                                                          Permission
                                                              .manageExternalStorage,
                                                          Permission.photos
                                                        ]);
                                                        if (!req &&
                                                            context.mounted) {
                                                          showSnakeBar(
                                                              context: context,
                                                              content:
                                                                  "Permission required");
                                                        }
                                                      }
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
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
