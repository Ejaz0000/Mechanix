import 'package:client_app/AllScreens/profileScreen.dart';
import 'package:client_app/AllScreens/requestAccept.dart';
import 'package:client_app/AllScreens/splashScreen.dart';
import 'package:client_app/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_app/AllScreens/userOption.dart';
import 'package:client_app/AllScreens/mechanicLogin.dart';
import 'package:client_app/AllScreens/mechanicSignup.dart';

import 'AllScreens/MechanicScreen.dart';


DatabaseReference MechanicRef = FirebaseDatabase.instance.ref().child("mechanics");


class SelectMechanic extends StatelessWidget {
  const SelectMechanic({super.key});
  static const String idScreen ="Selectmechanic";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanix Mechanic App',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      initialRoute: MechanicLogin.idScreen,
      routes: {
        MechanicLogin.idScreen: (context) => MechanicLogin(),
        MechanicSignup.idScreen: (context) => MechanicSignup(),
        OptionScreen.idScreen: (context) => OptionScreen(),
        MechanicScreen.idScreen: (context) => MechanicScreen(),
        ProfileScreen.idScreen: (context) => ProfileScreen(),
        //RequestAccept.idScreen: (context) => RequestAccept(),
      },
      debugShowCheckedModeBanner: false,

     // home: AuthService().handleAuthState(),
    );
  }
}
