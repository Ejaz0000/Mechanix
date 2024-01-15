import 'package:client_app/AllWidgets/pickaddress.dart';
import 'package:flutter/material.dart';

class Dialogbox extends StatelessWidget {
  // Dialogbox({super.key});

  late String message;
  Dialogbox({required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
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
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){

                                return Pickaddress();
                              });
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 16,
                              fontFamily: "Brand Bold"
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        )


    );
  }
}
