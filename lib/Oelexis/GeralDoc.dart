import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i_health/Classes/FirebaseUser.dart';

import 'package:i_health/Classes/StatusRequisicao.dart';
import 'package:i_health/Classes/Usuario.dart';
import 'package:i_health/perry/ChercherQuery.dart';


class GeralDoc extends StatefulWidget {
  String _nomeDoc;
  String _foto;
  String _idDoutor;
  String _code;
  String _idRequisicao;

  GeralDoc(this._code, this._foto,this._idDoutor, this._nomeDoc, this._idRequisicao);

  @override
  _GeralDocState createState() => _GeralDocState();
}

class _GeralDocState extends State<GeralDoc> {








  String _nomeDoc;





  _aceitarConsulta()async{
    Usuario paciente = await UsuarioFirebase.getDadosUsuarioLogado();

    Firestore db = Firestore.instance;
    String _idRequisicao = widget._idRequisicao;
    db.collection("requisicoes")
    .document(_idRequisicao).updateData({
      "paciente" : paciente.toMap(),
      "status" : StatusRequisicao.LER
    }).then((_){

      String idDoc = widget._idDoutor; 
      db.collection("requisicao_ativa").document(idDoc).updateData({
        "status" : StatusRequisicao.LER
      });
      String idPaciente = paciente.idUsuario;
      db.collection("requisicao_ativa_paciente").document(idPaciente).setData({
        "id_requisicao" : _idRequisicao,
        "idUsuario" : idPaciente,
        "status" : StatusRequisicao.LER
      }

      );


    });
  }
_statusLeitura(){
  Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ChercherPerry(widget._code, widget._foto, widget._idDoutor, widget._nomeDoc, widget._idRequisicao)
  ));


}
_statusAguardando(){}
  _adicionarListenerRequisicao()async{
    Firestore db = Firestore.instance;
    String idRequisicao = widget._idRequisicao;
    await db.collection("requisicoes")
    .document(idRequisicao)
    .snapshots().listen((snapshot){
      if(snapshot.data!=null){
        Map<String, dynamic> dados = snapshot.data;
        String status = dados["status"];
        switch(status){
          case StatusRequisicao.AGUARDANDO :
            _statusAguardando();
            break;
          case StatusRequisicao.LER :
            _statusLeitura();
            break;
          case StatusRequisicao.VIDEO :
            break;
          case StatusRequisicao.FINALIZADA :
            break;


        }

      }

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nomeDoc = widget._nomeDoc;

    _adicionarListenerRequisicao();
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
                 Column(

                   children: <Widget>[
                     CircleAvatar(
                         radius: 100,
                         backgroundColor: Colors.grey,
                         backgroundImage:
                         widget._foto != null
                             ? NetworkImage(widget._foto)
                             : null
                     ),

                     Padding(
                       padding: EdgeInsets.only(top: 16),
                       child: Text(
                         "Esse é o Dr. $_nomeDoc",
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 20,
                             color: Colors.greenAccent
                         ),
                       ),
                     )
                     ,

                     Padding(padding: EdgeInsets.only(top: 16),
                     child:  Text(
                       "Um ótimo médico!" ,
                       style: TextStyle(
                           fontSize: 32,
                           color: Colors.blueAccent
                       ),
                     ),

                       ),
                     Padding(
                       padding: EdgeInsets.only(top: 16),
                       child: RaisedButton(
                           child: Text(
                             "Iniciar Consulta",
                             style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                           ),
                           color: Colors.yellowAccent,
                           padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                           onPressed: (){
                             _aceitarConsulta();
                           }
                       ),
                     )





                   ],
                 ),

                Container(padding: EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[




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
