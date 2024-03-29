import 'package:client_app/AllScreens/reached_dis_user.dart';
import 'package:client_app/AllScreens/requestService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../selectMechanic.dart';
import 'MechanicScreen.dart';


class Reached_dis extends StatefulWidget {
  Reached_dis({super.key,required this.reqid,required this.upreqid});
  late String reqid;
  late String upreqid;
  @override
  State<Reached_dis> createState() => _reached_disState(reqid: reqid,upreqid: upreqid);
}

class _reached_disState extends State<Reached_dis> {
  _reached_disState({required this.reqid,required this.upreqid});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String uid;
  late String reqid;
  late String upreqid;

  @override
  void initState() {
    // TODO: implement initState
    loadMore();
    super.initState();
  }

  late Map<dynamic,dynamic> reqmap;

  void loadMore() async{
    RequestsRef.child(reqid).once().then((event){
      final snap = event.snapshot;
      if(snap.value != null){
        reqmap= snap.value as Map<dynamic,dynamic>;

        print(reqmap['charge']);
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
    uid = _firebaseAuth.currentUser!.uid.toString();
    if (reqmap != null){
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
                  Text("You have reached your client!",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontFamily: "Brand Bold"
                    ),),
                  SizedBox(height: 20,),
                  Text("Now you can provide your service to your client.",
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
                      child: Lottie.asset("images/working.json"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(reqmap['charge'] +
                      "Tk will be added with your service charge.",
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
                        border: Border.all(color: Colors.pink, width: 3)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Text(
                          "After service is done you can request for rating your service.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: "Brand-Regular"
                          ),),
                        SizedBox(height: 10,),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))
                            ),
                            onPressed: () {
                              print('oressed');
                            },
                            child: Text('Request for Rating',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                        Text("Or",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: "Brand-Regular"
                          ),),
                        SizedBox(height: 10,),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 26),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))
                            ),
                            onPressed: () {
                              updateRequest();
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Reached_dis_user()));
                              Navigator.pushNamedAndRemoveUntil(
                                  context, MechanicScreen.idScreen, (
                                  route) => false);
                            },
                            child: Text('Go back to home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),

                ],
              ),
            )
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
  }
    else {
      loadMore();

      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
  updateRequest() async{

    RequestsRef.child(reqid).remove();
    UpdateReqRef.child(upreqid).remove();
    MechanicRef.child(uid).update({
      "status": "unoccupied",
    });
  }
}
