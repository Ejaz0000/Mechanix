import 'package:client_app/AllScreens/userOption.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const String idScreen ="splash";
  void startapp (context){
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushNamedAndRemoveUntil(context, OptionScreen.idScreen, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    startapp(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 220,),
            Text(
              "Welcome To",
              style: TextStyle(fontSize: 26,fontFamily: "Brand Bold"),
            ),
            SizedBox(height: 20,),
            Image.asset("images/MECHANIX.png")],
        ),
      ),
    );
  }
}

