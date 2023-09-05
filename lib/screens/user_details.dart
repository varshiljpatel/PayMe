import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pay_me/screens/key_pad.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/shared_prefs_keys.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/utils/snake_bar.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:pay_me/widgets/ui_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => const UserDetails());
  }

  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  static final TextEditingController _payeeNameController =
      TextEditingController();
  static final TextEditingController _payeeUpiIdController =
      TextEditingController();
  static String inputNameText = _payeeNameController.text.toString();
  static String inputUpiIdText = _payeeUpiIdController.text.toString();

  @override
  void dispose() {
    _payeeNameController.dispose();
    _payeeUpiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payeeProvider = Provider.of<Payee>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SvgPicture.asset(ic_logo_text,
            colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
            width: 96),
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
                        const SizedBox(height: 24.0),
                        Text(
                          "Enter Payee Details",
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
                                inputNameText = value;
                              });
                            },
                            label: "Enter Payee Name",
                            controller: _payeeNameController),
                        const SizedBox(
                          height: 24.0,
                        ),
                        inputField(
                            onChanged: (value) {
                              setState(() {
                                inputUpiIdText = value;
                              });
                            },
                            label: "Enter Payee UPI Id",
                            controller: _payeeUpiIdController),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "Enter Payee name that appears while scanning QR code and UPI id in which payment will withdraw by scanning QR code in above visible input boxes.",
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
                      if (inputNameText.length > 50) {
                        return showSnakeBar(
                            context: context,
                            content:
                                "Payee name's characters must be less than or equal to 50!");
                      }

                      if (inputNameText.isNotEmpty &&
                          inputUpiIdText.isNotEmpty) {
                        payeeProvider.setPayeeName(inputNameText.toString());
                        payeeProvider.setUpiId(inputUpiIdText.toString());
                        // Save in Prefs
                        setSharedPrefs(sp_payee_name_key(context).toString(),
                            inputNameText.toString());
                        setSharedPrefs(sp_upiid_key(context).toString(),
                            inputUpiIdText.toString());
                        Navigator.of(context)
                            .pushReplacement(KeyPad.route(context: context));
                        return;
                      }
                    },
                    activeColor: black100,
                    width: getMediaWidth(context),
                    title: "Submit",
                    textColor: white100,
                    isActive:
                        (inputNameText.isNotEmpty && inputUpiIdText.isNotEmpty)
                            ? true
                            : false,
                    disabledColor: black50),
              )
            ],
          ),
        ),
      ),
    );
  }

  setSharedPrefs(String keyString, String valueString) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(keyString, valueString);
  }
}
