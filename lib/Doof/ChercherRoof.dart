import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i_health/Classes/FirebaseUser.dart';
import 'package:i_health/Classes/StatusRequisicao.dart';
import 'package:i_health/Classes/Usuario.dart';
import 'package:i_health/Doof/Paciente.dart';

import 'IniciarChamdaDoc.dart';
import 'MensagensDoc.dart';
import 'ReceberItens.dart';

class ChercherRoof extends StatefulWidget {
  String _idRequisicao;
  String _code;
  ChercherRoof(this._code, this._idRequisicao);
  @override
  _ChercherRoofState createState() => _ChercherRoofState();
}

class _ChercherRoofState extends State<ChercherRoof> {
  @override
  int _indiceatual = 0;
  String Resultado = "";
  Map<String, dynamic> _dadosRequisicao;
  String nomePaciente ;
  String fotoPaciente ;
  String _doencasCronicas;
  String idPaciente;




  _recuperarDadosPaciente()async{
    String idRequisicao = widget._idRequisicao;
    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
        .document(idRequisicao)
        .get();
    _dadosRequisicao = documentSnapshot.data;
     nomePaciente = _dadosRequisicao["paciente"]["nome"];
     fotoPaciente = _dadosRequisicao["paciente"]["foto"];
    idPaciente = _dadosRequisicao["paciente"]["id"];
     _doencasCronicas = _dadosRequisicao["paciente"]["descricao"];
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosPaciente();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      PacienteGeral (nomePaciente, fotoPaciente, _doencasCronicas,widget._idRequisicao ),
      MensagensDoc(nomePaciente, fotoPaciente,idPaciente ),
      ReceberItens(),
      IniciarChamadaDoc(widget._code)
    ];
    return Scaffold(

      body: telas[_indiceatual],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceatual,
          onTap: (indice) {
            setState(() {
              _indiceatual = indice;
            });
          },
          fixedColor: Colors.green,
          unselectedItemColor: Colors.greenAccent,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                title: Text("Meu Paciente"),
                icon: Icon(Icons.local_hospital)
            ),
            BottomNavigationBarItem(title: Text("Chat"),
                icon: Icon(Icons.chat)),
            BottomNavigationBarItem(title: Text("Passar Dados"),
                icon: Icon(Icons.video_call)),
            BottomNavigationBarItem(title: Text("Chamada"),
                icon: Icon(Icons.video_call)),
          ]),


    );
  }

}

