import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:i_health/Chercher/Cats.dart';
import 'package:i_health/Classes/Hospital.dart';
import 'package:i_health/Oelexis/Configuracoes.dart';
import 'package:i_health/Oelexis/ItemHospital.dart';

class ListaHospitais extends StatefulWidget {
  String kwery;
  ListaHospitais({this.kwery});
  @override
  _ListaHospitaisState createState() => _ListaHospitaisState();
}

class _ListaHospitaisState extends State<ListaHospitais> {
  List <DropdownMenuItem<String>> _listaItensDropCategorias;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Position _posicao;
  String _categoriaSelecionada;
  double _longitude;
  double _latitude;
  _recuperarUltimaPosicaoConhecida()async{
    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {

      _posicao = Position(latitude: 1 , longitude:1 );

    });

  }
  _carregarItensDropDown(){

    _listaItensDropCategorias = Configuracoes.getCategorias();
  }

  Future <Stream<QuerySnapshot>> _adicionarListenerHospitais() async{
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("hospitais")
        .snapshots();

    stream.listen((dados){_controller.add(dados);});

  }


 _returnLower(){
   setState(() {
     _latitude = _posicao.latitude;
   });
   setState(() {
     _latitude = _posicao.longitude;
   });
 double minLat = _latitude-3;
 double minLong = _longitude-3;
   var _lower =  Geohash.encode(minLat, minLong);
  return _lower;

}

 _returnUpper(){
 setState(() {
   _latitude = _posicao.latitude;
 });
 setState(() {
   _longitude = _posicao.longitude;
 });

 double maxLong = _longitude+3;
 double maxLat = _latitude + 3;
   var _upper =  Geohash.encode(maxLat, maxLong);
   return _upper;

 }
  Future <Stream<QuerySnapshot>> _filtrarAnuncios() async{
    Firestore db = Firestore.instance;
    Query query  = db.collection("hospitais");
   var _upper = _returnUpper();
   var _lower = _returnLower();
      query = query.where("geohash", isGreaterThanOrEqualTo: _lower);
    query = query.where("geohash", isLessThanOrEqualTo: _upper);

    if(this.widget.kwery!=null){
      query = query.where("categoria", isEqualTo: this.widget.kwery);
    }
    if(_categoriaSelecionada!= null){
      query = query.where("categoria", isEqualTo: _categoriaSelecionada);
    }


    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados){
      _controller.add(dados);
    });


  }
  @override
  void initState() {

    super.initState();

    _recuperarUltimaPosicaoConhecida();
    _adicionarListenerHospitais();
    _carregarItensDropDown();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("iHealth"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 18, top: 24),
            child: Text("Hospitais Próximos", style: TextStyle(
            fontSize: 24,
            color:  Colors.teal,
            fontWeight: FontWeight.bold
        ),),
        )
            ),
            Center(
              child: Image.asset("Imagens/thehospital.png", width: 320,height: 300),
            ),
            Row(children: <Widget>[
              Expanded(
                child:  DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: Colors.teal,
                      value: _categoriaSelecionada,
                      items: _listaItensDropCategorias,
                      onChanged: (estado){
                        setState(() {
                          _categoriaSelecionada = estado;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  ),
                ),
              )
            ],),
            StreamBuilder(
                stream: _controller.stream,
                builder:(context, snapshot)
                {
                  switch(snapshot.connectionState){
                    case ConnectionState.none :
                    case ConnectionState.waiting :
                    case ConnectionState.active :
                    case ConnectionState.done :
                      QuerySnapshot querySnapshot = snapshot.data;
                      if(querySnapshot.documents.length==0){
                        return Container(padding: EdgeInsets.all(25), child: Text("Não há nenhum hospital na sua região",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),);
                      }else{
                        return Expanded(
                          child: ListView.builder(
                              itemCount: querySnapshot.documents.length,

                              itemBuilder: (_,indice){
                                List<DocumentSnapshot> anuncios = querySnapshot.documents.toList();
                                DocumentSnapshot documentSnapshot = anuncios[indice];
                                Hospital hospital = Hospital.fromDocumentSnapshot(documentSnapshot);
                                return ItemHospital(
                                    hospital: hospital,
                                    onTapItem: (){}


                                );


                              }),
                        );
                      }
                  }
                  return Container();
                }
            ),
          ],
        ),
      ),

    );
  }
}
