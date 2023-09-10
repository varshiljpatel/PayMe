import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_me/screens/user_details.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/shared_prefs_keys.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:pay_me/widgets/ui_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoiInScreeState();
}

class _LoiInScreeState extends State<LoginScreen> {
  static final TextEditingController _mobileController =
      TextEditingController();
  static String inputText = _mobileController.text.toString();

  setSharedPrefs(String keyString, String valueString) async {
    return await SharedPreferences.getInstance()
      ..setString(keyString, valueString);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: SvgPicture.asset(ic_logo_text,
              colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
              width: 96),
        ),
        centerTitle: true,
        backgroundColor: black100,
      ),
      backgroundColor: white100,
      body: SafeArea(
        child: SizedBox(
          height: getMediaHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(ic_pay_me_icon,
                        //     width: getMediaWidth(context) / 9),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          "Enter Mobile Number",
                          style: TextStyle(
                              fontSize: 24.0,
                              color: black100,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        inputField(
                            onChanged: (value) {
                              setState(() {
                                inputText = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            label: "Enter Your Mobile Number",
                            controller: _mobileController),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "Enter your mobile number in above visible input box for verification.",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: black75,
                              fontWeight: FontWeight.w400),
                        ),
                        // const SizedBox(
                        //   height: 24.0,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: uiButton(
                    onTap: () {
                      try {
                        if (inputText.length == 10) {
                          Provider.of<Payee>(context, listen: false)
                              .setMobile(inputText.toString());

                          setSharedPrefs(
                              sp_mobile_key(context).toString(), inputText.toString());

                          Navigator.of(context).pushReplacement(
                              UserDetails.route());
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    activeColor: black100,
                    width: getMediaWidth(context),
                    title: "Log In",
                    textColor: white100,
                    isActive: (inputText.length == 10) ? true : false,
                    disabledColor: black50),
              )
            ],
          ),
        ),
      ),
    );
  }
}
