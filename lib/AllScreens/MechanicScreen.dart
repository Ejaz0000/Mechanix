

import 'package:client_app/AllScreens/mechanicLogin.dart';
import 'package:client_app/AllScreens/profileScreen.dart';
import 'package:client_app/AllScreens/requestAccept.dart';
import 'package:client_app/AllScreens/requestService.dart';
import 'package:client_app/AllWidgets/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_service.dart';
import '../selectMechanic.dart';

class MechanicScreen extends StatefulWidget {
  const MechanicScreen({super.key});

  static const String idScreen ="mechanicScreen";

  @override
  State<MechanicScreen> createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {

    String uid = _firebaseAuth.currentUser!.uid.toString();
    String currentEmail = _firebaseAuth.currentUser!.email.toString();
    return StreamBuilder(
        stream: MechanicRef.child(uid).onValue,
    builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

    if(map['location']=="N/A"){
      locationMechanic(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Mechanic"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage("images/home_bg.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
              EdgeInsets.symmetric(vertical: 14, horizontal: 5),
              color: Colors.pink,
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
                           // print("My account menu is selected.");
                            Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.idScreen, (route) => false);

                          }
                          else if(value == 2){
                            AuthService().signOut();
                            Navigator.pushNamedAndRemoveUntil(context, MechanicLogin.idScreen, (route) => false);

                          }
                        }
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  //height: 440,

                  margin: EdgeInsets.symmetric(vertical: 18,horizontal: 5),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius
                        .circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            margin: EdgeInsets.only(top: 10,left: 10),
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.pink,
                                //border: Border.all(color: Colors.pink, width: 3)
                            ),
                            child: Text(
                              "Requests",
                              style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "Brand Bold"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            //height: 35,
                            margin: EdgeInsets.only(top: 10,left: 10),
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius
                                    .circular(8),
                                border: Border.all(
                                    color: Colors
                                        .black54,
                                    width: 1)
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Requests will be refreshed",
                                  style: TextStyle(color: Colors.black54,fontSize: 10,fontFamily: "Brand Bold"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: SingleChildScrollView(
                            child:
                            StreamBuilder(
                            stream: RequestsRef.orderByChild('mechanic').equalTo(currentEmail).onValue,
                            builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && snapshot.data != null && snapshot.data.snapshot.value != null) {
                            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                            List<dynamic> list = [];
                            list.clear();
                            list= map.values.toList();

                            return

                            Column(
                              children: [
                            for(final li in list)...[
                                Container(
                                  width: double.infinity,
                                  //height: 40,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5,horizontal: 2),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 6),
                                  decoration: BoxDecoration(
                                     color: Colors.white,
                                      boxShadow: [BoxShadow(
                                          color: Colors.grey,
                                        blurRadius: 5
                                      )],
                                      borderRadius: BorderRadius
                                          .circular(8),

                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "images/man.png"),
                                                    fit: BoxFit
                                                        .cover,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius
                                                      .all(
                                                      Radius
                                                          .circular(
                                                          70.0)),
                                                  border: Border
                                                      .all(
                                                    color: Colors
                                                        .pink,
                                                    width: 3.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 8),
                                                width: 180,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 3, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(8),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black54,
                                                              width: 1)
                                                      ),
                                                      child: Text(
                                                          li["timestamp"],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily: "Brand-Regular",
                                                              fontSize: 10)),
                                                    ),
                                                    Text(li["userName"],
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 14)),
                                                    Text(
                                                        "Contact: "+li["userContact"],
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey,
                                                            fontSize: 10)),
                                                    Text(
                                                        "Distance: "+li['distance'],
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey,
                                                            fontSize: 10)),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: const Text(
                                                              "Location: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 10)),
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(top: 0),
                                                            child: Text(
                                                                li["userLocation"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: 10)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Container(
                                            height: 35,
                                            child: TextButton(
                                                style: TextButton
                                                    .styleFrom(
                                                    backgroundColor: Colors
                                                        .pink,
                                                    //padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius
                                                                .circular(
                                                                8)))
                                                ),
                                                onPressed: () {
                                                  //Navigator.pushNamedAndRemoveUntil(context, RequestAccept.idScreen, (route) => false,arguments: {'rid': li['uid']});
                                                    updateRequest(li['uid']);
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestAccept(rid: li['uid'])));
                                                },
                                                child: Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize: 12))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                ],
                              ],
                            );
                            }  else {
                            return
                            const Text(
                            "No request has been found",
                            style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                            textAlign: TextAlign.center,
                            );
                            }
                            })
                          ),
                        ),
                      )
                    ],
                  )

              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.pink,
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
  late BuildContext dialogContext;
  void locationMechanic(BuildContext context) async{




    Future.delayed(Duration(milliseconds: 2000), () {

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            dialogContext = context;
            return Dialogbox(message: "You have to locate yourself on the map. So users be able to know your location and send you request.",);
          });
    });
  }
  updateRequest(uid) async{


    RequestsRef.child(uid).update({
      "status": "accepted",
    });
  }
}
