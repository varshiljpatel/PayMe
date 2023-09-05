import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pay_me/screens/qr_code.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/widgets/ui_list.dart';
import 'package:provider/provider.dart';

import '../utils/icon_const.dart';

class Details extends StatelessWidget {
  static route({required BuildContext context}) {
    return MaterialPageRoute(builder: (context) => const Details());
  }

  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    final payeeProvider = Provider.of<Payee>(context);
    NumberFormat formatter =
        NumberFormat.currency(locale: "hi_IN", decimalDigits: 0, symbol: "");
    String formattedAmmount =
        formatter.format(int.parse(payeeProvider.ammount.toString()));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left_sharp)),
        title: SvgPicture.asset(ic_logo_text,
            colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
            width: 96),
        centerTitle: true,
        backgroundColor: black100,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "Check Details",
            style: TextStyle(
                fontSize: 24.0, color: black100, fontWeight: FontWeight.w500),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // payee name
                  detailList("Payee Name", payeeProvider.payeeName.toString()),
                  // upi id
                  detailList("UPI Id", payeeProvider.upiId.toString()),
                  // ammount
                  detailList("Total Ammount", formattedAmmount),
                  // Payment note
                  detailList("Payment Note", "Pay to ${payeeProvider.payeeName.toString()} With PayMe QR Code"),
                  // mobile
                  detailList("Mobile Number", payeeProvider.mobile.toString()),
                ],
              ),
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: getMediaWidth(context),
                decoration: BoxDecoration(
                    color: black100, borderRadius: BorderRadius.circular(36)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 36, right: 24),
                  child: Column(
                    children: [
                      Text(
                        payeeProvider.upiId.toString(),
                        style: TextStyle(
                            color: white100,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        formattedAmmount,
                        style: TextStyle(
                            color: white100,
                            fontWeight: FontWeight.w500,
                            fontSize: (formattedAmmount.length < 9) ? 48 : 36),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () {
                            Navigator.of(context)
                                .push(QrCodeScreen.route(context: context));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: white100,
                            ),
                            height: 64,
                            width: 156,
                            child: Center(
                              child: Text(
                                "CREATE",
                                style: TextStyle(
                                  color: black100,
                                  fontSize: 16,
                                  letterSpacing: 4.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
