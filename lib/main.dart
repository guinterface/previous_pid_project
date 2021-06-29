import 'package:flutter/material.dart';
import 'package:i_health/BancoDeDados.dart';
import 'package:i_health/Cadastro.dart';
import 'package:i_health/Chercher/Cats.dart';
import 'package:i_health/Chercher/ChercherMain.dart';
import 'package:i_health/Chercher/ListaHospitais.dart';
import 'package:i_health/Chercher/NewDoc.dart';
import 'package:i_health/Chercher/Vido.dart';

import 'package:i_health/Madlian/PainelPaciente.dart';
import 'package:i_health/Oelexis/PainelSecundario.dart';
import 'package:i_health/Vicino.dart';
import 'package:i_health/Login.dart';
import 'package:i_health/Oelexis/MeusAnuncios.dart';
import 'package:i_health/Oelexis/Novo%20Anuncio.dart';
import 'package:i_health/VideoConference/CreateMeeting.dart';
import 'package:i_health/VideoConference/joinmeeting.dart';
import 'package:i_health/perry/ChercherQuery.dart';
void main() => runApp(MaterialApp(
  theme: ThemeData(
      primaryColor: Colors.blueAccent,
      accentColor: Colors.yellow
  ),
  debugShowCheckedModeBanner: false,
  home: Inicio(),


));
