import 'dart:async';

import 'package:client_app/AllScreens/requestService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../selectMechanic.dart';
import 'MechanicScreen.dart';
import 'mainscreen.dart';


class Reached_dis_user extends StatefulWidget {
  Reached_dis_user({super.key});

  static const String idScreen = "reached";

  @override
  State<Reached_dis_user> createState() => _reached_dis_userState();
}

class _reached_dis_userState extends State<Reached_dis_user> {

  String charge = "0.00";


 // late Map<dynamic,dynamic> reqmap;

  void loadMore(reqid) async{
    RequestsRef.child(reqid).once().then((event){
      final snap = event.snapshot;
      if(snap.value != null){
        Map<dynamic,dynamic> reqmap= snap.value as Map<dynamic,dynamic>;

       charge =reqmap['charge'];
        setState(() {

        });
      }
      else{
        print("error");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? reqData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    loadMore(reqData?['reqid']);
    if(charge != "0.00") {
      return Scaffold(
        appBar: AppBar(
          title: Text("Request Complete"),
        ),
        body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Mechanic have reached you!",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontFamily: "Brand Bold"
                    ),),
                  SizedBox(height: 20,),
                  Text("Now you can receive your service",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: "Brand-Regular"
                    ),),
                  SizedBox(height: 20,),
                  Center(
                    child: Container(
                      width: 80,
                      child: Lottie.asset("images/done.json"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(charge + "Tk will be added with service charge.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: "Brand Bold"
                    ),),
                  SizedBox(height: 60,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple, width: 3)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Text("You can go back to home while receiving service.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: "Brand-Regular"
                          ),),
                        SizedBox(height: 10,),

                        SizedBox(height: 10,),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 26),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))
                            ),
                            onPressed: () {
                              print('oressed');

                              Navigator.pushNamedAndRemoveUntil(
                                  context, MainScreen.idScreen, (
                                  route) => false);
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));

                            },
                            child: Text('Go back to home',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16))),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),

                ],
              ),
            )
        ),
        bottomNavigationBar: Container(
          color: Colors.deepPurple,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }else {
      loadMore(reqData?['reqid']);

      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

}
