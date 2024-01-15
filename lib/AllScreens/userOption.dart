import 'package:client_app/selectMechanic.dart';
import 'package:flutter/material.dart';
import 'package:client_app/selectUser.dart';
import 'package:client_app/auth_service.dart';


class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});
  static const String idScreen ="option";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Image.asset("images/MECHANIX.png"),
            SizedBox(height: 50,),
            const Text(
              "Please Select User Type",
              style: TextStyle(fontSize: 16,fontFamily: "Brand-Regular"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        child: Image(
                          image: AssetImage("images/usericon.png"),
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20)
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, SelectUser.idScreen, (route) => false);

                        },
                      ),
                    ),
                    const Text(
                      "User",
                      style: TextStyle(fontSize: 16,fontFamily: "Brand Bold"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        child: Image(
                          image: AssetImage("images/mechanic.png"),
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20)
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, SelectMechanic.idScreen, (route) => false);
                        },
                      ),
                    ),
                    const Text(
                      "Mechanic",
                      style: TextStyle(fontSize: 16,fontFamily: "Brand Bold"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

