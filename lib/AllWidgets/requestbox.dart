import 'dart:async';

import 'package:client_app/AllScreens/requestService.dart';
import 'package:client_app/AllWidgets/pickaddress.dart';
import 'package:flutter/material.dart';

class Requestbox extends StatefulWidget {
  //const Requestbox({super.key});

  late String RId;
  Requestbox({required this.RId});
  String  v= "asdasdsad";
  @override
  State<Requestbox> createState() => _RequestboxState(rid: RId);
}

class _RequestboxState extends State<Requestbox> {
  String message = "The request has been sent. Please wait for 90 sec for request to be accepted.";
  var seconds = 90;
  late String rid;
  _RequestboxState({required this.rid});
  Timer? timer;

  @override
  void initState() {
    startTimer();

    super.initState();
  }


  @override

  void startTimer(){
    timer = Timer.periodic(Duration (seconds: 1), (timer) {
      if(seconds>0){
        setState(() {
          seconds-- ;
        });
      }else{
        stopTimer();
      }


    });
  }
  void stopTimer(){
    timer?.cancel();
    seconds = 90;
    deleteReq();
    Navigator.pop(context);

  }

  void deleteReq(){
    RequestsRef.child(rid).remove();
  }


  @override
  Widget build(BuildContext context) {
    print(rid);
    return Dialog(
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: 10,),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: [
                      Center(child: CircularProgressIndicator(value: seconds/90,strokeWidth: 3,valueColor: AlwaysStoppedAnimation(Colors.blue),)),
                      Center(
                        child: Text(
                          '$seconds',
                          style: TextStyle(color: Colors.purple, fontSize: 16,),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 6,),

                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.grey, fontSize: 14,),
                        softWrap: true,

                      ),
                    ),

                    SizedBox(width: 2,),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          deleteReq();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 16,
                              fontFamily: "Brand Bold"
                          ),
                        )),
                    TextButton(
                        onPressed: (){

                         Navigator.pop(context);
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 16,
                              fontFamily: "Brand Bold"
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        )


    );
  }
}



