import 'package:flutter/material.dart';
import 'package:i_health/VideoConference/CreateMeeting.dart';
import 'package:i_health/VideoConference/joinmeeting.dart';
class VideoConferenceScreen extends StatefulWidget {
  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen> with SingleTickerProviderStateMixin {
  builTab(String _name){
    return Container(
      width: 150,
      height: 50,
      child: Card(child: Center(
        child: Text(_name, style: TextStyle(color: Colors.teal, fontSize: 14),),
      ),)
    );
  }
  TabController tabcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabcontroller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Conferences"),
      bottom: TabBar(
        controller: tabcontroller,
        tabs: [
          builTab("Join Meeting"),
          builTab("Create Meeting")
        ],
      ),
      ),
      body: TabBarView(
          controller: tabcontroller,
          children: [
      CreateMeeting(),
        JoinMeeting()
      ]),


    );
  }
}
