import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/screens/key_pad.dart';
import 'package:pay_me/screens/login.dart';
import 'package:pay_me/screens/user_details.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/shared_prefs_keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      checkAndNavigate();
    });
  }

  checkAndNavigate() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      bool isFirstRun = value.getBool("isFirstRun") ?? true;
      String payeeName = value.getString(sp_payee_name_key(context)) ?? "";
      String upiId = value.getString(sp_upiid_key(context)) ?? "";
      String mobile = value.getString(sp_mobile_key(context)) ?? "";

      if (payeeName.isNotEmpty &&
          upiId.isNotEmpty &&
          mobile.isNotEmpty &&
          isFirstRun == false &&
          context.mounted) {
        var payeeProvider = Provider.of<Payee>(context, listen: false);
        payeeProvider.mobile = value.getString(sp_mobile_key(context)) ?? "";
        payeeProvider.upiId = upiId;
        payeeProvider.payeeName = payeeName;

        Navigator.pushReplacement(
            context, KeyPad.route(context: context)); // Navigate to home
      } else if (mobile.isNotEmpty &&
          (payeeName.isEmpty || upiId.isEmpty) &&
          isFirstRun == false) {
        Navigator.pushReplacement(
            context, UserDetails.route()); // Navigate to home
      } else {
        Navigator.pushReplacement(
            context, LoginScreen.route()); // Navigate to home
      }
    });
  }

  @override
  void dispose() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      value.setBool("isFirstRun", false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SvgPicture.asset(ic_pay_me_icon,
                    width: 84,
                    colorFilter: ColorFilter.mode(white100, BlendMode.srcIn)),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    ic_logo_text,
                    width: 120,
                    colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
