import 'package:client_app/AllScreens/ServiceScreen.dart';
import 'package:client_app/AllScreens/requestService.dart';
import 'package:client_app/AllScreens/splashScreen.dart';
import 'package:client_app/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_app/AllScreens/userOption.dart';
import 'package:client_app/AllScreens/userSignup.dart';
import 'AllScreens/loginScreen.dart';
import 'package:client_app/AllScreens/mainscreen.dart';

import 'AllScreens/testpage.dart';


DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

class SelectUser extends StatelessWidget {
  const SelectUser({super.key});
  static const String idScreen ="Selectuser";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanix User App',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      routes: {
        TestScreen.idScreen: (context) => TestScreen(),
        RequestService.idScreen: (context) => RequestService(),
        ServiceScreen.idScreen: (context) => ServiceScreen(),
        UserSignup.idScreen: (context) => UserSignup(),
        OptionScreen.idScreen: (context) => OptionScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),


      },
      debugShowCheckedModeBanner: false,
      //home: AuthService().handleAuthState(),
      initialRoute: LoginScreen.idScreen,

    );
  }
}
