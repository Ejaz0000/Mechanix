import 'package:client_app/AllWidgets/pickaddress.dart';
import 'package:flutter/material.dart';

class Detailsbox extends StatelessWidget {
  // Dialogbox({super.key});

  late String type;
  late String vDetails;
  late String problem;
  Detailsbox({required this.type,required this.vDetails,required this.problem});
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal:6 ,vertical:5 ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Vehicle Type :',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 14,
                            fontFamily: "Brand Bold",
                          )
                      ),
                      SizedBox(width: 6,),
                      Text(type,
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 12,
                            fontFamily: "Brand-Regular",
                          )
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Text('Vehicle details :',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 14,
                            fontFamily: "Brand Bold",
                          )
                      ),

                      Flexible(
                        child: Text(vDetails,
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                              fontFamily: "Brand-Regular",
                            )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text('Problem Details :',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 14,
                            fontFamily: "Brand Bold",
                          )
                      ),
                      SizedBox(width: 6,),
                      Flexible(
                        child: Text(problem,
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                              fontFamily: "Brand-Regular",
                            )
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);

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
