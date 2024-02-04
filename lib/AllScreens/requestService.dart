import 'dart:async';

import 'package:client_app/AllWidgets/requestbox.dart';
import 'package:client_app/selectUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import  'package:intl/intl.dart';


import '../selectMechanic.dart';
import 'AfterAccept.dart';

DatabaseReference RequestsRef = FirebaseDatabase.instance.ref().child("requests");


class RequestService extends StatefulWidget {
  const RequestService({super.key});

  static const String idScreen = "request";



  @override
  State<RequestService> createState() => _RequestServiceState();
}

class _RequestServiceState extends State<RequestService> {

  String dropdownvalue = 'Car';
  double fare = 0.0;
  String mechanicEmail = "";
  String userLocation = "";
  String? distance = "";

  var items = [
    'Car',
    'Bike',
  ];

  String uuid = Uuid().v4();
  Timer? timer;

  //@override
  // void initState() async{
  //   // TODO: implement initState
  //   super.initState();
  //
  //
  //
  //     MechanicRef.child("sadasds").once().then((event){
  //       final snap = event.snapshot;
  //       if(snap.value != null){
  //         print(snap.value);
  //       }
  //       else{
  //         print("error");
  //       }
  //     });
  //
  // }

  TextEditingController vehicalEditingController = TextEditingController();
  TextEditingController problemTextEditingController = TextEditingController();

  var userlat;
  var userlng;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? mechanicData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    fare=(double.parse(mechanicData?['distance']))*10;
    mechanicEmail = mechanicData?['email'];
    userLocation = mechanicData?['location'];
    distance = mechanicData?['distance'];
    userlat = (mechanicData?['userlat']).toString();
    userlng = (mechanicData?['userlng']).toString();
    return Scaffold(
      appBar: AppBar(title: Text("Request Service"),),
      body: Container(
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child:
                  StreamBuilder(
                  stream: MechanicRef.orderByChild('email').equalTo(mechanicData?['email']).onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data.snapshot.value != null) {
                  Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                  return
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "images/mechanic1.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      70.0)),
                              border: Border.all(
                                color: Colors
                                    .deepPurple,
                                width: 4.0,
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
                                Text(map.values.first?["name"],
                                    style: TextStyle(
                                        color: Colors
                                            .black54,
                                        fontSize: 16)),
                                Text(
                                    "Contact: "+map.values.first?["phone"],
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
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                            map.values.first?["location"],
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
                        margin: EdgeInsets.only(right: 10),
                        child: Column(

                          children: [
                            Text(
                                "Rating: ",
                                style: TextStyle(
                                    color: Colors
                                        .black54,
                                    fontSize: 12)),
                            Row(
                              children: [
                                Icon(Icons.star_rate_rounded,color: Colors.yellow),
                                Text(
                                    "4.5/5",
                                    style: TextStyle(
                                        color: Colors
                                            .grey,
                                        fontSize: 12)),
                              ],
                            )
                          ],
                        )
                      ),
                    ],
                  );
                  } else {
                  return Center(child: CircularProgressIndicator());
                  }
                  })
                ),

                Container(
                  width: double.infinity,
                  //height: 40,

                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Request Details",
                              style: TextStyle(
                                  color: Colors
                                      .purple,
                                  fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text(
                              "Vehicle Type        :",
                              style: TextStyle(
                                  color: Colors
                                      .grey,
                                  fontSize: 12)),
                          SizedBox(width: 10,),
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue, width: 3)
                            ),
                            child: DropdownButton(
                              value: dropdownvalue,
                              underline: SizedBox(),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              //hint: Text("Select vehicle"),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "Brand-Regular",
                                  fontSize: 12),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text(
                              "Vehicle Details   :",
                              style: TextStyle(
                                  color: Colors
                                      .grey,
                                  fontSize: 12)),
                          SizedBox(width: 10,),
                          Container(
                            width: 190,
                            height: 30,
                            padding: EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue, width: 3)
                            ),
                            child:
                            TextField(
                              controller: vehicalEditingController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 50),
                                border: InputBorder.none,
                                hintText: "Enter Details...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              style: TextStyle(fontSize: 12,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: Text(
                                "Problem Details :",
                                style: TextStyle(
                                    color: Colors
                                        .grey,
                                    fontSize: 12)),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: 190,
                            height: 100,
                            padding: EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue, width: 3)
                            ),
                            child:
                            TextField(
                              controller: problemTextEditingController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 0),
                                border: InputBorder.none,
                                hintText: "Enter Details...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              style: TextStyle(fontSize: 12,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  //height: 40,

                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
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
                          Text(
                              "Distance",
                              style: TextStyle(
                                  color: Colors
                                      .purple,
                                  fontSize: 18)),
                          Text(
                              mechanicData?['distance'],
                              style: TextStyle(
                                  color: Colors
                                      .black54,
                                  fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                      "Distance",
                                      style: TextStyle(
                                          color: Colors
                                              .purple,
                                          fontSize: 12)),
                                  Text(
                                      "Charge",
                                      style: TextStyle(
                                          color: Colors
                                              .purple,
                                          fontSize: 12)),

                                ],

                              ),
                              SizedBox(width: 4,),
                              Text(
                                  "(per km 10tk)",
                                  style: TextStyle(
                                      color: Colors
                                          .grey,
                                      fontSize: 10)),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                  "("+mechanicData?['distance']+"X 10) =",
                                  style: TextStyle(
                                      color: Colors
                                          .grey,
                                      fontSize: 12)),
                              SizedBox(width: 10,),
                              Text(
                                  fare.toStringAsFixed(2)+" Tk",
                                  style: TextStyle(
                                      color: Colors
                                          .black54,
                                      fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  //height: 40,

                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius
                        .circular(8),
                    color: Colors.white,
                  ),
                  child: Center(child: Text(
                    "Please note: The service charge will add separately with Distance charge later.",
                    style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: "Brand-Regular"),
                    textAlign: TextAlign.center,
                  ),)

                ),

                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 110),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                    ),
                    onPressed: (){
                         print('oressed');
                         requestSend(context) ;
                    },
                    child: Text('Send Request',
                        style: TextStyle( color:Colors.white, fontSize: 16))),
              ],
            ),
          )),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late BuildContext dialogContext;
  requestSend(BuildContext context) async{
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
    String dateandtime= cdate+" "+tdata;
    String useruid = _firebaseAuth.currentUser!.uid.toString();

    userRef.child(useruid).once().then((event){
            final snap = event.snapshot;
            Map<dynamic,dynamic> usermap= snap.value as Map<dynamic,dynamic>;
            if(snap.value != null){
              uuid = Uuid().v4();
              Map reqDataMap = {
                "mechanic": mechanicEmail,
                "userName": usermap?['name'].toString(),
                "userContact": usermap?['phone'].toString(),
                "userLocation": userLocation,
                "timestamp": dateandtime,
                "vehicleType": dropdownvalue.toString(),
                "vehicleDetails": vehicalEditingController.text.trim(),
                "problem": problemTextEditingController.text.trim(),
                "distance": distance,
                "uid": uuid,
                "status": "unaccepted",
                "lat": userlat,
                "lng": userlng,
                "charge": fare.toString(),
              };


              RequestsRef.child(uuid).set(reqDataMap);

              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context){
                    dialogContext = context;
                    return Requestbox(RId: uuid,);
                  });

             startTimer();

            }
            else{
              print("error");
            }
          });




  }
  void startTimer(){
    timer = Timer.periodic(Duration (seconds: 1), (timer) {
        RequestsRef.child(uuid).once().then((event){
          final snap = event.snapshot;
          if(snap.value != null){
            Map<dynamic,dynamic> checkmap= snap.value as Map<dynamic,dynamic>;
            if(checkmap['status']=="accepted"){
              stopTimer();
              // Navigator.pushNamedAndRemoveUntil(context, MechanicScreen.idScreen, (route) => false);
            }
          }
        });

    });
  }

  void stopTimer(){
    timer?.cancel();
    Navigator.pop(dialogContext);
    Navigator.pushNamedAndRemoveUntil(context, AfterAccept.idScreen, (route) => true, arguments: {'reqid': uuid,});

  }
}
