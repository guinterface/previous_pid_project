import 'package:flutter/material.dart';
import 'package:i_health/BancoDeDados.dart';
import 'package:i_health/Cadastro.dart';
import 'package:i_health/Chercher/Cats.dart';
import 'package:i_health/Chercher/ListaHospitais.dart';
import 'package:i_health/Chercher/Vido.dart';

import 'package:i_health/Oelexis/Configuracoes.dart';
import 'package:i_health/Oelexis/PainelSecundario.dart';
import 'package:i_health/Vicino.dart';
import 'package:i_health/Login.dart';
import 'package:i_health/Oelexis/MeusAnuncios.dart';
import 'package:i_health/Oelexis/Novo%20Anuncio.dart';
import 'package:i_health/VideoConference/CreateMeeting.dart';
import 'package:i_health/VideoConference/joinmeeting.dart';
class ChercherMain extends StatefulWidget {
  @override
  _ChercherMainState createState() => _ChercherMainState();
}

class _ChercherMainState extends State<ChercherMain> {
  @override
  int _indiceatual = 0;
  String Resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      PainelSecundario(),
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
                title: Text("Consultas"),
                icon: Icon(Icons.search)
            ),
            BottomNavigationBarItem(title: Text("Configuracões"),
                icon: Icon(Icons.settings)),

          ]),


    );
  }

  }

