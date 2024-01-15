import 'dart:ffi';
import 'dart:ui';

import 'package:client_app/AllScreens/ServiceScreen.dart';
import 'package:client_app/AllScreens/loginScreen.dart';
import 'package:client_app/auth_service.dart';
import 'package:client_app/selectUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String idScreen = "mainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final ref = FirebaseDatabase.instance.ref('users');

  @override
  Widget build(BuildContext context) {
    String uid = _firebaseAuth.currentUser!.uid.toString();
    return StreamBuilder(
        stream: userRef.child(uid).onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("Home")),
              ),
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage("images/home_bg.png"),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hi, " + map['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold"),
                            ),
                            PopupMenuButton(
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/usericon.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text("My Account"),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Text("Logout"),
                                  ),
                                ];
                              },
                                onSelected:(value){
                                  if(value == 0){
                                    print("My account menu is selected.");
                                  }
                                  else if(value == 2){
                                    AuthService().signOut();
                                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                                  }
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome to",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontFamily: "Brand Bold"),
                    ),
                    Text(
                      "Mechanix",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 34,
                          fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Services",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30,
                          fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ElevatedButton(
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage("images/fuel.png"),
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.center,
                                ),
                                Text(
                                  "Out of Fuel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Brand Bold"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20)),
                            onPressed: () {
                           //   Navigator.pushNamedAndRemoveUntil(context, SelectUser.idScreen, (route) => false);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ElevatedButton(
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage("images/car_repair.png"),
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.center,
                                ),
                                Text(
                                  " Mechanic ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Brand Bold"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20)),
                            onPressed: () {
                               Navigator.pushNamedAndRemoveUntil(context, ServiceScreen.idScreen, (route) => false);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: Colors.deepPurple,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white, size: 30),
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white, size: 30),
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.white, size: 30),
                      onPressed: () => {},
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("Home")),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
