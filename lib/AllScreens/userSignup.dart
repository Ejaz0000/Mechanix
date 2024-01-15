import 'package:client_app/AllScreens/loginScreen.dart';
import 'package:client_app/AllWidgets/progressDialog.dart';
import 'package:client_app/selectUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mainscreen.dart';


class UserSignup extends StatelessWidget {
   UserSignup({super.key});
  static const String idScreen ="usersignup";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
   TextEditingController phoneTextEditingController = TextEditingController();
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
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 50),
                child: const Text(
                  "Fill your information before or rgister with your social account",
                  style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 40,top: 0,right: 40,bottom: 0),
                child:  Column(
                  children: [
                    const SizedBox(height: 5,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
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
                      child:  TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          border: InputBorder.none,
                          hintText: "Enter Full Name",
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
                          "Phone",
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
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          border: InputBorder.none,
                          hintText: "Enter Phone number",
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
                      child:  TextField(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AgreetoTerms(),
                        const Text(
                          "Agree With",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: "Brand-Regular"
                          ),
                        ),
                        TextButton(
                            onPressed: (){},
                            child: const Text(
                              "Terms & Condition",
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 12,
                                  fontFamily: "Brand Bold"
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 5,),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        onPressed: (){
                         // Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                          if(nameTextEditingController.text.length < 3){
                            displayToastMessage("name must be atleast 3 Characters.", context);
                          }
                          else if(!emailTextEditingController.text.contains("@")){
                            displayToastMessage("Email address is not valid", context);
                          }
                          else if(phoneTextEditingController.text.isEmpty){
                            displayToastMessage("Phone number is mandatory", context);
                          }
                          else if(passwordTextEditingController.text.length < 6){
                            displayToastMessage("Password must be atleast 6 Characters.", context);
                          }
                          else{
                            registerNewUser(context);
                          }

                        },
                        child: Text('Sign Up',
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
                          "Already have an account?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: "Brand-Regular"
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pushNamedAndRemoveUntil(context,  LoginScreen.idScreen, (route) => false);

                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 12,
                                  fontFamily: "Brand Bold"
                              ),
                            ))
                      ],
                    )
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
  registerNewUser(BuildContext context) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          dialogContext = context;
          return ProgressDialog(message: "Creating new account...",);
        });

     final User? firebaseUser = (await _firebaseAuth
     .createUserWithEmailAndPassword(
         email: emailTextEditingController.text,
         password: passwordTextEditingController.text
     ).catchError((errmsg){
       Navigator.pop(dialogContext);

       displayToastMessage("Error:" + errmsg.toString(), context);
     })).user;
     if(firebaseUser != null){

       Map userDataMap = {
         "name": nameTextEditingController.text.trim(),
         "email": emailTextEditingController.text.trim(),
         "phone": phoneTextEditingController.text.trim(),
       };

       userRef.child(firebaseUser.uid).set(userDataMap);
        Navigator.pop(dialogContext);
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

     }
     else{
       Navigator.pop(dialogContext);
       displayToastMessage("New user account has not been Created.", context);
     }
  }
}

displayToastMessage(String msg, BuildContext context){
  Fluttertoast.showToast(msg: msg);
}

class AgreetoTerms extends StatefulWidget {
  const AgreetoTerms({super.key});

  @override
  State<AgreetoTerms> createState() => _AgreetoTermsState();
}

class _AgreetoTermsState extends State<AgreetoTerms> {
  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(value: agree, onChanged:(bool? value){
      setState(() {
        agree = value!;
      });

    });
  }
}

