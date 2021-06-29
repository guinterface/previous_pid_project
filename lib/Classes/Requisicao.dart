
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Usuario.dart';

class Requisicao {

  String _id;
  String _status;
  String _code;
  Usuario _paciente;
  Usuario _doutor;
  List<String> _foto;


  Requisicao(){

    Firestore db = Firestore.instance;
    DocumentReference ref = db.collection("requisicoes").document();
    this.id = ref.documentID;
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> dadosDoutor = {
      "nome" : this.paciente.nome,
      "foto"  : this.foto,
      "tipoUsuario" : this.paciente.tipoUsuario,
      "idUsuario" : this.paciente.idUsuario,
      "descricao" : this.paciente.descricao,
    };



    Map<String, dynamic> dadosRequisicao = {
      "status" : this.status,
      "id" : this.id,
      "doutor" : dadosDoutor,
      "code" : this.code,
      "paciente" : null,

    };

    return dadosRequisicao;

  }


  String get code => _code;

  set code(String value) {
    _code = value;
  }

  List<String> get foto => _foto;

  set foto(List<String> value) {
    _foto = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Usuario get paciente => _paciente;

  set paciente(Usuario value) {
    _paciente = value;
  }

  Usuario get doutor => _doutor;

  set doutor(Usuario value) {
    _doutor = value;
  }
}