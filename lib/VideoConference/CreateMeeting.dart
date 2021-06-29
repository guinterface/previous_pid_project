import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:uuid/uuid.dart';
class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String code = '';
  _createCode(){
    setState(() {
      code  = Uuid().v1().substring(0, 6);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text("Create a Code", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Text("Code", style: TextStyle(color: Colors.black, fontSize: 20),),
              Text( code, style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: ()=>_createCode(),
             child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: GradientColors.teal)
                ),
                child: Center(
                  child: Text("Create Code", style: TextStyle(color: Colors.white),),
                ),
              )
          )

        ],
      ),

    );
  }
}
