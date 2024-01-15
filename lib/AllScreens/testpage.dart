import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mainscreen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  static const String idScreen = "test";

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {


  Position? currentPosition;
  var geoLocator = Geolocator();




  final _controller = DraggableScrollableController();
  double _top = 465.3;
  double changeTop = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mechanic Service"),),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("images/home_bg.png"),
          Positioned(
              top: _top,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,

            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 245.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ]
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: (details){

                        changeTop = _top + details.delta.dy;
                        if(changeTop <= 465.3){
                          _top = max(0, changeTop);
                        }




                        setState(() {

                        });

                    },
                    child: Container(
                      color: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 1,),
                          Container(
                            height: 4,
                            width: 120,
                            color: Colors.white,
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Where are you?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: "Brand Bold",
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.my_location,color: Colors.white),
                                  style: IconButton.styleFrom(
                                      backgroundColor: Colors.cyan,
                                      padding: EdgeInsets.symmetric(vertical: 1,horizontal: 9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                  ),
                                  onPressed: () {
                                    //locatePosition();
                                  },
                                ),

                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 250,
                                  height: 40,
                                  padding: EdgeInsets.only(left: 3),
                                  decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                           border: Border.all(color: Colors.white, width: 3)
                                       ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    SizedBox(
                                      width: 150,
                                      child: TextField(
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(bottom: 12),
                                                border: InputBorder.none,
                                                hintText: "Enter Your Location",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              style: TextStyle(fontSize: 14,),
                                            ),
                                    ),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.cyan,
                                              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)))

                                    ),
                                          onPressed: (){},
                                          child: Text('Search',
                                              style: TextStyle( color:Colors.white, fontSize: 14))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),

                    ),
                  ),


                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 10),
                          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 50),
                          child:
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    "Mechanics which are available and close to you will be listed here.",
                                    style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )

                        ),
                      ),

                ],
              ),
            ),
          )
        ],

      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

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
  }
}
