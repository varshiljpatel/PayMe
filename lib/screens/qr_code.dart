import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    String pa = Provider.of<Payee>(context).upiId.toString();
    String pn = Provider.of<Payee>(context).payeeName.toString();
    String am = Provider.of<Payee>(context).ammount.toString();
    String tn = "Pay to ${Provider.of<Payee>(context).payeeName.toString()} With PayMe QR Code";
    upiUri = "upi://pay?pa=$pa&pn=${Uri.encodeComponent(pn)}&am=$am&tn=${Uri.encodeComponent(tn)}";

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
            // Positioned(
            //     bottom: 0,
            //     child: uiButton(
            //         onTap: () {},
            //         activeColor: black100,
            //         width: getMediaWidth(context),
            //         title: "Download",
            //         textColor: white100)),
          ],
        ),
      ),
    );
  }
}
