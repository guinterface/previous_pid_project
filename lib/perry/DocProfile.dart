import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_health/Chercher/ChercherMain.dart';
import 'package:i_health/Classes/Doc.dart';
import 'package:i_health/Classes/FirebaseUser.dart';
import 'package:i_health/Classes/StatusRequisicao.dart';


class DocProfile extends StatefulWidget {
  String nomeDoc;
  String fotos;
  String _idDoc;
  String _idRequisicao;
  DocProfile(this.nomeDoc, this.fotos, this._idDoc, this._idRequisicao);

  @override
  _DetalhesDocProfileState createState() => _DetalhesDocProfileState();
}

class _DetalhesDocProfileState extends State<DocProfile> {




  String _idUsuarioLogado;

  _recuperaDadosUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

  }
  String _foto;
  String _nomeDoc;
  _finalizarConsulta() async {
    Firestore db = Firestore.instance;
    db.collection("requisicoes")
    .document(widget._idRequisicao)
    .updateData({
      "status" : StatusRequisicao.FINALIZADA
    });
    String _idDoutor =  widget._idDoc;
    FirebaseUser  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    db.collection("requisicao_ativa")
        .document(_idDoutor)
        .updateData({
    "status" : StatusRequisicao.FINALIZADA
    });
    String _idPaciente =  firebaseUser.uid;
    db.collection("requisicao_ativa_paciente")
        .document(_idPaciente)
        .updateData({
    "status" : StatusRequisicao.FINALIZADA
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChercherMain()
        )
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 _foto = widget.fotos;
  _nomeDoc = widget.nomeDoc;
    _recuperaDadosUsuario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anuncio"),),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
            CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey,
            backgroundImage:
            _foto != null
                ? NetworkImage(_foto)
                : null
        ),
                Container(padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Esse é o Dr. $_nomeDoc",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.greenAccent
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),

                      Text(
                        "Um ótimo médico!" ,
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.blueAccent
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      RaisedButton(
                        child: Text("Sair da Consulta", style: TextStyle(color: Colors.white , fontSize: 20),),
                        color: Colors.red,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: (){
                          _finalizarConsulta();
                        },
                      )


                    ],
                  ),
                )

              ],

            ),
          ],
        ),
      ),

    );
  }
}
