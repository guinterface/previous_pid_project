import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geohash/geohash.dart';
class Hospital {


  String _nome;
  double _longitude;
  double _latitude;
  String _id;
  String _categoria;
  List<String> _fotos;
  var _geohash;


  Hospital();

  Hospital.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    this.id = anuncios
        .document()
        .documentID;

    this.fotos = [];
  }

  Hospital.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.nome = documentSnapshot["nome"];
    this.longitude = documentSnapshot["longitude"];
    this.latitude = documentSnapshot["latitude"];
    this.categoria = documentSnapshot["categoria"];
    this.geohash = documentSnapshot["geohash"];
    this.fotos = List<String>.from(documentSnapshot["fotos"]);
  }

  get geohash => _geohash;

  set geohash(value) {
    _geohash = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "categoria": this.categoria,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "fotos": this.fotos,
      "geohash": this.geohash
    };

    return map;
  }


  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }


  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }
}
