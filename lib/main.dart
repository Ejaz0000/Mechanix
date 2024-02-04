import 'package:client_app/AllScreens/mainscreen.dart';
import 'package:client_app/AllScreens/mechanicLogin.dart';
import 'package:client_app/AllScreens/mechanicSignup.dart';
import 'package:client_app/AllScreens/splashScreen.dart';
import 'package:client_app/AllScreens/userOption.dart';
import 'package:client_app/AllScreens/userSignup.dart';
import 'package:client_app/auth_service.dart';
import 'package:client_app/selectMechanic.dart';
import 'package:client_app/selectUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AllScreens/loginScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanix',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.idScreen,
     // home: AuthService().handleAuthState(),

      routes: {
        SelectUser.idScreen: (context) => SelectUser(),
        SelectMechanic.idScreen: (context) => SelectMechanic(),
        OptionScreen.idScreen: (context) => OptionScreen(),
        SplashScreen.idScreen: (context) => SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
