import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    image: AssetImage("images/logo.png"),
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
                      child: const TextField(
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
                      child: const TextField(
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
                                  color: Colors.purpleAccent,
                                  fontSize: 16,
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
                        onPressed: (){},
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
                            child: Image(
                              image: AssetImage("images/google-logo.png"),
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
                            onPressed: (){},
                            child: const Text(
                              "Sign Up",
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
}

