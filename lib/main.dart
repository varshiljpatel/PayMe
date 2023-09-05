import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_me/screens/splash.dart';
import 'package:pay_me/services/payee_provider.dart';
import 'package:pay_me/utils/colors_const.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: black100));
  runApp(ChangeNotifierProvider(
    create: (context) => Payee(),
    child: const PayMeApp(),
  ));
}

class PayMeApp extends StatelessWidget {
  const PayMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PayMe",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        fontFamily: "Poppins",
        primaryColor: white100,
      ),
      home: const Splash(),
    );
  }
}
