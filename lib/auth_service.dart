

import 'package:client_app/AllScreens/loginScreen.dart';
import 'package:client_app/AllScreens/mainscreen.dart';
import 'package:client_app/AllScreens/userSignup.dart';
import 'package:client_app/selectUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
           return MainScreen();
           // Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

          } else {
            return LoginScreen();
          }
        });
  }

  signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential


    final firebaseUser = await FirebaseAuth.instance.signInWithCredential(credential);

    if(firebaseUser != null){


      userRef.child(FirebaseAuth.instance.currentUser!.uid).once().then((event){
        final snap = event.snapshot;
        if(snap.value != null){

          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
        }
        else{

          Map userDataMap = {
            "name": FirebaseAuth.instance.currentUser!.displayName,
            "email": FirebaseAuth.instance.currentUser!.email,
            "phone": "N/A",
            "id": FirebaseAuth.instance.currentUser!.uid
          };

          userRef.child(FirebaseAuth.instance.currentUser!.uid).set(userDataMap);
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

        }
      });
      // Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else{

      displayToastMessage("Error occured can not be signed in.", context);
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(){
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   // final ref = FirebaseDatabase.instance.ref('users');
    String uid = _firebaseAuth.currentUser!.uid.toString();
    return StreamBuilder(
        stream: userRef.child(uid).onValue,
        builder: (context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {
            Map <dynamic, dynamic> map = snapshot.data.snapshot.value;
            return MainScreen();
            // Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

          } else {
            return LoginScreen();
          }
        }
    );
  }

}