
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_health/Classes/Usuario.dart';
class Doc{





  String _nome;
  String _id;
  String _categoria;
  int _estrelas;
  String _descricao;
  List<String> _fotos;
  Usuario _user;




  Doc();

  Doc.gerarId(){
  Firestore db = Firestore.instance;
  CollectionReference anuncios = db.collection("meus-doutores");
  this.id = anuncios
      .document()
      .documentID;

  this.fotos = [];
  }

    Doc.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
  this.id = documentSnapshot.documentID;
  this.nome = documentSnapshot["nome"];
  this.user = documentSnapshot["usuario"];
  this.categoria = documentSnapshot["categoria"];
  this.estrelas = documentSnapshot["estrelas"];
  this.descricao = documentSnapshot["descricao"];
  this.fotos = List<String>.from(documentSnapshot["fotos"]);
  }




  Map<String, dynamic> toMap() {
  Map<String, dynamic> map = {
  "id": this.id,
    "usuario": this.user,
  "nome": this.nome,
  "categoria": this.categoria,
  "fotos": this.fotos,
  "descricao": this.descricao,
  "estrelas": this.estrelas
  };

  return map;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  Usuario get user => _user;

  set user(Usuario value) {
    _user = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  int get estrelas => _estrelas;

  set estrelas(int value) {
    _estrelas = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}



