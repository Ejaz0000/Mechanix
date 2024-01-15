import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AllWidgets/pickaddress.dart';
import '../selectMechanic.dart';
import 'MechanicScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String idScreen = "profile";


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    String uid = _firebaseAuth.currentUser!.uid.toString();
    return StreamBuilder(
        stream: MechanicRef.child(uid).onValue,
    builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
    return
      Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            SizedBox(height: 30,),
            Center(
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/usericon.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(70.0)),
                  border: Border.all(
                    color: Colors.pink,
                    width: 5.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(map["name"],
                style: TextStyle(
                color: Colors.black54,
                fontSize: 24,
                fontFamily: "Brand Bold"
            ),),
            SizedBox(height: 30,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Email :",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontFamily: "Brand Bold"
                  ),),
                SizedBox(width: 10,),
                Text(map["email"],
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontFamily: "Brand Bold"
                  ),),
              ],),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Phone :",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontFamily: "Brand Bold"
                  ),),
                SizedBox(width: 10,),
                Text(map["phone"],
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontFamily: "Brand Bold"
                  ),),
              ],),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Location :",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontFamily: "Brand Bold"
                  ),),
                SizedBox(width: 10,),
                Flexible(
                  child: Text(map["location"],
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontFamily: "Brand Bold"
                    ),),
                ),
                SizedBox(width: 10,),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.pink, size: 20),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){

                          return Pickaddress();
                        });
                  },
                ),
              ],),
            SizedBox(height: 30,),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))
                ),
                onPressed: (){

                },
                child: Text('Edit',
                    style: TextStyle( color:Colors.white, fontSize: 14))),

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
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, MechanicScreen.idScreen, (route) => false);

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
