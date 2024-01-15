import 'package:client_app/AllScreens/MechanicScreen.dart';
import 'package:client_app/AllScreens/mainscreen.dart';
import 'package:client_app/AllScreens/mechanicSignup.dart';
import 'package:client_app/AllScreens/userOption.dart';
import 'package:client_app/AllScreens/userSignup.dart';
import 'package:client_app/auth_service.dart';
import 'package:client_app/selectMechanic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AllWidgets/progressDialog.dart';

class MechanicLogin extends StatelessWidget {
  MechanicLogin({super.key});

  static const String idScreen ="mechaniclogin";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight*0.1,),
              const Center(
                child: Image(
                  image: AssetImage("images/MECHANIX.png"),
                  width: 250,
                  height: 100,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 28,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 10),
                child: const Text(
                  "Hi welcome back",
                  style: TextStyle(fontSize: 14,fontFamily: "Brand-Regular"),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50,top: 0,right: 50,bottom: 0),
                child:  Column(
                  children: [
                    const SizedBox(height: 5,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(color: Colors.grey,fontSize: 16,fontFamily: "Brand Bold"),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 3)
                      ),
                      child: TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          border: InputBorder.none,
                          hintText: "Enter Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        style: TextStyle(fontSize: 14,),
                      ),
                    ),

                    const SizedBox(height: 5,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: "Brand Bold"
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 3)
                      ),
                      child: TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          border: InputBorder.none,
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        style: TextStyle(fontSize: 14,),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){},
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontFamily: "Brand Bold"
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 5,),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        onPressed: (){
                          //Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                          if(!emailTextEditingController.text.contains("@")){
                            displayToastMessage("Email address is not valid", context);
                          }
                          else if(passwordTextEditingController.text.isEmpty){
                            displayToastMessage("Password is mandatory.", context);
                          }
                          else{
                            loginAndAuthenticateMechanic(context);

                          }
                        },
                        child: Text('Sign In',
                            style: TextStyle( color:Colors.white, fontSize: 16))),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: 70,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5,top: 0,right: 5,bottom: 2),
                          child: Text(
                            "Or sign in with",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontFamily: "Brand-Regular"
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          width: 70,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black54,width:2),
                            ),
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage("images/apple-logo.png"),
                              width: 10,
                              height: 10,
                              alignment: Alignment.center,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black54,width:2),
                            ),
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              onTap: (){
                                //AuthService().signInWithGoogle();
                              },
                              child: Image(
                                image: AssetImage("images/google-logo.png"),
                                width: 10,
                                height: 10,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black54,width:2),
                            ),
                            width: 50,
                            height: 50,
                            child: Image(
                              image: AssetImage("images/facebook-logo.png"),
                              width: 10,
                              height: 10,
                              alignment: Alignment.center,
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: "Brand-Regular"
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pushNamedAndRemoveUntil(context,  MechanicSignup.idScreen, (route) => false);

                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 12,
                                  fontFamily: "Brand Bold"
                              ),
                            ))
                      ],
                    ),
                    TextButton(
                        onPressed: (){
                          //Navigator.pushNamedAndRemoveUntil(context, OptionScreen.idScreen, (route) => false);

                        },
                        child: const Text(
                          "Go back to selection page",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 10,
                              fontFamily: "Brand Bold"
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late BuildContext dialogContext;
  void loginAndAuthenticateMechanic(BuildContext context) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          dialogContext = context;
          return ProgressDialog(message: "Authenticating, Please wait...",);
        });

    final User? firebaseMechanic = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errmsg){

      Navigator.pop(dialogContext);
      displayToastMessage("Some thing went wrong", context);
    })).user;
    if(firebaseMechanic != null){


      MechanicRef.child(firebaseMechanic.uid).once().then((event){
        final snap = event.snapshot;
        if(snap.value != null){
          Navigator.pop(dialogContext);
          Navigator.pushNamedAndRemoveUntil(context, MechanicScreen.idScreen, (route) => false);
        }
        else{
          Navigator.pop(dialogContext);
          _firebaseAuth.signOut();
          displayToastMessage("Now record exists for this user. Please create new account", context);

        }
      });
      // Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else{
      Navigator.pop(dialogContext);
      displayToastMessage("Error occured can not be signed in.", context);
    }
  }
}

