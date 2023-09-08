import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pay_me/screens/login.dart';
import 'package:pay_me/screens/qr_code.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/shared_prefs_keys.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/utils/snake_bar.dart';
import 'package:pay_me/widgets/ui_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        actions: [
          IconButton(
            onPressed: () {
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
                        Icons.logout_outlined,
                        color: white100,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      title: Text(
                        "Are you want to Log out?",
                        style: TextStyle(color: white100, fontSize: 20),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text(
                                "Log out",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Future<SharedPreferences> prefs =
                                    SharedPreferences.getInstance();
                                prefs.then((value) {
                                  value.setString(sp_mobile_key(context), "");
                                  value.setString(sp_upiid_key(context), "");
                                  value.setString(
                                      sp_payee_name_key(context), "");
                                  value.setBool("isFirstRun", true);
                                });
                                Navigator.of(context)
                                    .pushReplacement(LoginScreen.route());
                              },
                            ),
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: white100),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  showSnakeBar(context: context, content: "Something is wrong");
                }
              }
            },
            icon: const Icon(Icons.logout_sharp),
            color: white100,
          ),
        ],
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
