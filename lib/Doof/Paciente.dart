import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_health/Chercher/ChercherMain.dart';
import 'package:i_health/Classes/FirebaseUser.dart';
import 'package:i_health/Classes/StatusRequisicao.dart';
class PacienteGeral extends StatefulWidget {
  String _nome;
  String _foto;
  String _doencas;
  String _idRequisicao;
  PacienteGeral(this._nome, this._foto, this._doencas, this._idRequisicao, );
  @override
  _PacienteGeralState createState() => _PacienteGeralState();

}
class _PacienteGeralState extends State<PacienteGeral> {


  Map<String, dynamic> _dadosRequisicao;

  _fimDaConsulta()async{
    String idRequisicao = widget._idRequisicao;
    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
        .document(idRequisicao)
        .get();
    _dadosRequisicao = documentSnapshot.data;

    String idDoutor = _dadosRequisicao["doutor"]["idUsuario"];
    db.collection("requisicao_ativa")
        .document(idDoutor)
    .delete();

  }
  Widget itemBotao(){

    RaisedButton(
      child: Text("Sair da Consulta", style: TextStyle(color: Colors.white , fontSize: 20),),
      color: Colors.red,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
      ),
      onPressed: (){
      _fimDaConsulta();

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChercherMain()
      ));
      },
    );
  }

  _adicionarListenerRequisicaoAtiva()async{
    FirebaseUser  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    Firestore db = Firestore.instance;
    await db.collection("requisicao_ativa")
        .document(firebaseUser.uid)
        .snapshots()
        .listen((snapshot){
      if(snapshot.data != null){
        Map<String, dynamic> dados = snapshot.data;
        String status = dados["status"];
        switch(status){
          case StatusRequisicao.AGUARDANDO :

            break;
          case StatusRequisicao.LER :

            break;
          case StatusRequisicao.VIDEO :
            break;
          case StatusRequisicao.FINALIZADA :

            break;


        }
      }else{

      }
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerRequisicaoAtiva();
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
                    widget._foto != null
                        ? NetworkImage(widget._foto)
                        : null
                ),
                Container(padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Seu paciente se chama ${widget._nome}",
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
                        "Tenham uma boa consulta!" ,
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.blueAccent
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Padding(child: itemBotao(),)



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
