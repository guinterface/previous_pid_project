import 'package:flutter/material.dart';

import 'package:i_health/Chercher/Vido.dart';
import 'package:i_health/Madlian/PainelPaciente.dart';

import 'package:i_health/Oelexis/Configuracoes.dart';
import 'package:i_health/Oelexis/PainelSecundario.dart';
class ChercherDino extends StatefulWidget {
  @override
  _ChercherDinoState createState() => _ChercherDinoState();
}

class _ChercherDinoState extends State<ChercherDino> {
  @override
  int _indiceatual = 0;
  String Resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      PainelPassageiro(),
      Vido(),

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
          fixedColor: Colors.teal,
          unselectedItemColor: Colors.greenAccent,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                title: Text("Criar Consulta"),
                icon: Icon(Icons.add_circle)
            ),
            BottomNavigationBarItem(title: Text("Configuracões"),
                icon: Icon(Icons.settings)),

          ]),


    );
  }

}

