import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
class IniciarChamada extends StatefulWidget {
  String _code;
  IniciarChamada(this._code);
  @override
  _IniciarChamadaState createState() => _IniciarChamadaState();
}

class _IniciarChamadaState extends State<IniciarChamada> {

  TextEditingController _nameController = TextEditingController();
  bool _isVideoMuted = false;
  bool _isAudioMuted = false;
  String _idUsuarioLogado;
  String _nome;
  TextEditingController _roomController = TextEditingController();
  _joinMeeting()async{
    try{
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      if (Platform.isAndroid) {
        featureFlag.callIntegrationEnabled = false;
      } else if (Platform.isIOS) {
        featureFlag.pipEnabled = false;
      }
      var options = JitsiMeetingOptions()
        ..room = widget._code
        ..userDisplayName = _nameController.text  == '' ?  _nome : _nameController.text
        ..audioMuted = _isAudioMuted
        ..videoMuted = _isVideoMuted
        ..featureFlag = featureFlag;
      await JitsiMeet.joinMeeting(options);
    } catch (e){
      print("ERRO: $e");
    }
  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document( _idUsuarioLogado )
        .get();
    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      _nome = dados["nome"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Chamada"),),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 16
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [


              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome: Deixe em branco se quiser seu nome comum",
                  labelStyle: TextStyle( color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CheckboxListTile(value: _isVideoMuted,
                checkColor: Colors.yellowAccent,
                onChanged: (value){
                  setState(() {
                    _isVideoMuted = value;
                  });
                },
                title: Text("Desativar Vídeo? ", style:  TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CheckboxListTile(value: _isAudioMuted,
                checkColor: Colors.blueAccent,
                onChanged: (value){
                  setState(() {
                    _isAudioMuted = value;
                  });
                },
                title: Text("Audio mudo?", style:  TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                height: 36,
                thickness: 2.0,
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                  onTap: ()=> _joinMeeting(),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 64,
                    decoration: BoxDecoration(
                        color: Colors.green
                    ),
                    child: Center(
                      child: Text("Entre na VideoChamada", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
