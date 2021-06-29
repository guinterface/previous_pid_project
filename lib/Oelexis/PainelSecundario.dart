import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_health/Classes/StatusRequisicao.dart';
import 'package:i_health/Oelexis/GeralDoc.dart';
import 'package:i_health/perry/ChercherQuery.dart';
class PainelSecundario extends StatefulWidget {
  @override
  _PainelSecundarioState createState() => _PainelSecundarioState();
}



class _PainelSecundarioState extends State<PainelSecundario> {
  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");

  }


  _escolhaMenuItem( String escolha ){

    switch( escolha ){
      case "Deslogar" :
        _deslogarUsuario();
        break;
      case "Configurações" :

        break;
    }

  }
  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance; 

  StreamController<QuerySnapshot> _adicionarListenerRequisicoes(){
    final stream = db.collection("requisicoes")
      .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
        .snapshots();
    stream.listen((dados){_controler.add(dados);});
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerRequisicoes();
  }
  @override
  Widget build(BuildContext context) {
    var mensagemCarregando = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando..."),
          CircularProgressIndicator()
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel"),
    actions: <Widget>[
    PopupMenuButton<String>(
    onSelected: _escolhaMenuItem,
    itemBuilder: (context){

    return itensMenu.map((String item){

    return PopupMenuItem<String>(
    value: item,
    child: Text(item),
    );

    }).toList();

    },
    )
    ],
    ),
      body:


      StreamBuilder<QuerySnapshot>

        (stream: _controler.stream, builder:(context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return mensagemCarregando;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError){
                return Text("Erro ao Carregar os Dados");
              }else{
                QuerySnapshot querySnapshot = snapshot.data;
                if(querySnapshot.documents.length ==0){
                  return Padding(
                    padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                    child:
                    Column(
                      children: <Widget>[
                        Text("Nenhum médico disponível na região",
                          style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),


                        ) ,
                        Image.asset("pictures/tres.png")
                      ],
                    )

                  );
                }else {

                return ListView.separated(
                    itemCount: querySnapshot.documents.length,
                  separatorBuilder: (context, indice) => Divider(height: 2, color:  Colors.lightBlueAccent,),
                  itemBuilder: (context, indice){
                      List<DocumentSnapshot> requisicoes = querySnapshot.documents.toList();
                      DocumentSnapshot item = requisicoes[indice];
                      String idRequisicao = item["id"];
                      String code = item["code"];
                      String nomeDoutor = item["doutor"]["nome"];
                      String fotoDoutor = item["doutor"]["foto"];
                      String idDoutor = item["doutor"]["idUsuario"];
                      return ListTile(
                        title: Text(nomeDoutor),
                        subtitle: Text("O Doutor $nomeDoutor está disponível"),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => GeralDoc(code, fotoDoutor, idDoutor, nomeDoutor, idRequisicao )
                          ));
                        },
                      );

                  },


                );
                }
              }
              break;


          }

      } ,)
      ,

    );
  }
}
