import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pay_me/screens/final_details.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:pay_me/utils/icon_const.dart';
import 'package:pay_me/utils/size_const.dart';
import 'package:pay_me/utils/snake_bar.dart';
import 'package:pay_me/widgets/ui_button.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class KeyPad extends StatefulWidget {
  // static route() {
  //   return MaterialPageRoute(builder: (context) => const KeyPad());
  // }
  static route({required BuildContext context}) {
    return MaterialPageRoute(builder: (context) => const KeyPad());
  }

  const KeyPad({
    super.key,
  });

  @override
  State<KeyPad> createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  String inputAmmount = "";
  String indRupeeAmount = "";
  NumberFormat formatter =
      NumberFormat.currency(decimalDigits: 0, locale: "hi_IN", symbol: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black100,
      body: SafeArea(
        child: SizedBox(
          height: getMediaHeight(context),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 60.0, horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SvgPicture.asset(ic_pay_me_icon,
                          width: getMediaWidth(context) / 9,
                          colorFilter:
                              ColorFilter.mode(white100, BlendMode.srcIn)),
                      const SizedBox(height: 32.0),
                      Center(
                        child: (inputAmmount.isNotEmpty)
                            ? Column(
                                children: [
                                  Text(indRupeeAmount,
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: white100,
                                          height: 1.2,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 2.0)),
                                  // const SizedBox(height: 12.0),
                                ],
                              )
                            : const SizedBox(
                                height: 0.0,
                              ),
                      ),
                      Text(
                        "Enter an ammount.",
                        style: TextStyle(
                          color: white75,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        inputFeild("1"),
                        inputFeild("2"),
                        inputFeild("3"),
                      ],
                    ),
                    Row(
                      children: [
                        inputFeild("4"),
                        inputFeild("5"),
                        inputFeild("6"),
                      ],
                    ),
                    Row(
                      children: [
                        inputFeild("7"),
                        inputFeild("8"),
                        inputFeild("9"),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        inputFeild("0"),
                        inputFeild("",
                            callback: backSpace,
                            icon: Icon(Icons.backspace_sharp, color: white100)),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 24,
                    // ),
                    uiButton(
                      onTap: () {
                        if (inputAmmount.isNotEmpty) {
                          if (int.parse(inputAmmount) > 10000000) {
                            showSnakeBar(
                                context: context,
                                content:
                                    "Ammount must not be more than 1,00,00,000 rupees.");
                            return;
                          }
                          Provider.of<Payee>(context, listen: false)
                              .setAmmount(inputAmmount.toString());
                          Navigator.of(context)
                              .push(Details.route(context: context));
                        }
                      },
                      activeColor: white100,
                      width: getMediaWidth(context),
                      title: "cotinue",
                      disabledColor: white50,
                      textColor: black100,
                      isActive: (inputAmmount.isNotEmpty) ? true : false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  inputFeild(String value, {VoidCallback? callback, Icon? icon}) {
    return Expanded(
        flex: 1,
        child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 12))),
          onPressed: callback ??
              () async {
                if (value.isNotEmpty && inputAmmount.length < 8) {
                  inputAmmount = "$inputAmmount$value";
                  try {
                    if (await Vibration.hasVibrator() == true) {
                      Vibration.vibrate(duration: 60);
                    } else if (await Vibration.hasAmplitudeControl() == true) {
                      Vibration.vibrate(amplitude: 128);
                    } else if (await Vibration.hasCustomVibrationsSupport() ==
                        true) {
                      Vibration.vibrate(duration: 250);
                    } else {
                      Vibration.vibrate();
                      await Future.delayed(const Duration(milliseconds: 5000));
                      Vibration.vibrate();
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    // HapticFeedback.vibrate();
                    indRupeeAmount = formatter.format(int.parse(inputAmmount));
                    return;
                  });
                }
                return;
              },
          child: icon ??
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  color: white100,
                ),
              ),
        ));
  }

  backSpace() {
    if (inputAmmount.isNotEmpty) {
      inputAmmount = inputAmmount.substring(0, inputAmmount.length - 1);
      setState(() {
        if (inputAmmount.isEmpty) {
          indRupeeAmount = "";
          return;
        }
        indRupeeAmount = formatter.format(int.parse(inputAmmount));
      });
    }
  }
}
