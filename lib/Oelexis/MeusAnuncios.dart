import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_health/Classes/Hospital.dart';
import 'package:i_health/Oelexis/Novo%20Anuncio.dart';
import 'ItemHospital.dart';


class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {

    await _recuperaDadosUsuarioLogado();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_hospitais")
        .document( _idUsuarioLogado )
        .collection("hospitais")
        .snapshots();

    stream.listen((dados){
      _controller.add( dados );
    });

  }

  _removerAnuncio(String idAnuncio){

    Firestore db = Firestore.instance;
    db.collection("meus_hospitais")
        .document( _idUsuarioLogado )
        .collection("hospitais")
        .document( idAnuncio )
        .delete().then((_){

      db.collection("hospitais")
          .document(idAnuncio)
          .delete();

    });

  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Text("Carregando anúncios"),
        CircularProgressIndicator()
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NovoAnuncio()),

          );
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){

          switch( snapshot.connectionState ){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

            //Exibe mensagem de erro
              if(snapshot.hasError)
                return Text("Erro ao carregar os dados!");

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (_, indice){

                    List<DocumentSnapshot> anuncios = querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Hospital anuncio = Hospital.fromDocumentSnapshot(documentSnapshot);

                    return ItemHospital(
                      hospital: anuncio,
                      onPressedRemover: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja realmente excluir o anúncio?"),
                                actions: <Widget>[

                                  FlatButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                  FlatButton(
                                    color: Colors.red,
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),
                                    ),
                                    onPressed: (){
                                      _removerAnuncio( anuncio.id );
                                      Navigator.of(context).pop();
                                    },
                                  ),


                                ],
                              );
                            }
                        );
                      },
                    );
                  }
              );

          }

          return Container();

        },
      ),
    );
  }
}
