import 'package:flutter/material.dart';
import 'DocProfile.dart';
import 'IniciarChamada.dart';
import 'Mensagens.dart';
import 'PassarItens.dart';
class ChercherPerry extends StatefulWidget {
  String _nomeDoc;
  String _foto;
  String _idDoutor;
  String _code;
  String _idRequisicao;
  ChercherPerry(this._code, this._foto, this._idDoutor, this._nomeDoc, this._idRequisicao);
  @override
  _ChercherPerryState createState() => _ChercherPerryState();
}

class _ChercherPerryState extends State<ChercherPerry> {
  @override
  int _indiceatual = 0;
  String Resultado = "";
  String _minhaId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> telas = [
      DocProfile(widget._nomeDoc, widget._foto, widget._idDoutor, widget._idRequisicao),
      Mensagens(widget._idDoutor, widget._foto, widget._nomeDoc),
      PassarItens(),
      IniciarChamada(widget._code)
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
          backgroundColor: Colors.tealAccent,
          items: [
            BottomNavigationBarItem(
                title: Text("Doutor"),
                icon: Icon(Icons.person_add)
            ),
            BottomNavigationBarItem(title: Text("Mensagens"),
                icon: Icon(Icons.view_agenda)),
            BottomNavigationBarItem(title: Text("Passar Itens"),
                icon: Icon(Icons.video_call)),
            BottomNavigationBarItem(title: Text("Chamada"),
                icon: Icon(Icons.person)),
          ]),


    );
  }

}

