import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  // ProgressDialog({super.key});

  late String message;
  ProgressDialog({required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(width: 6,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),),
              SizedBox(width: 26,),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.grey, fontSize: 10,),
                  softWrap: true,

                ),
              )
            ],
          ),
        ),
      )


    );
  }
}
