import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_health/Classes/FirebaseUser.dart';
import 'package:i_health/Classes/Requisicao.dart';
import 'package:i_health/Classes/StatusRequisicao.dart';
import 'dart:io';
import 'package:i_health/Classes/Usuario.dart';
import 'package:i_health/Doof/ChercherRoof.dart';
import 'package:uuid/uuid.dart';



class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  String _idRequisicao;
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

String _textoBotao = "Criar Consulta";
  String _imageni = "pictures/quatro.png";
  Color _corBotao = Colors.blueAccent;
  Function _funcaoBotao ;
  _alterarBotao(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });

  }
_statusSemConsulta() {
  _alterarBotao("Criar Consulta", Colors.blueAccent, () {
    _criarConsulta();


  });
}
_cancelarConsulta() async {
  FirebaseUser  firebaseUser = await UsuarioFirebase.getUsuarioAtual();
  Firestore db = Firestore.instance; 
  db.collection("requisicoes")
  .document(_idRequisicao).updateData({
    "status" : StatusRequisicao.CANCELADA
  }).then((_){
  db.collection("requisicao_ativa").document(firebaseUser.uid).delete();
  });
  setState(() {
    _imageni = "pictures/quatro.png";
  });
  }

    _statusAguardando(){
      _alterarBotao("Cancelar", Colors.red, (){_cancelarConsulta();
      });
}
  _criarConsulta() async {

        showDialog(
            context: context,
            builder: (contex){
              return AlertDialog(
                title: Text("Confirmar Consulta"),
                content: Text(" Deseja Confirmar a Consulta? "),
                contentPadding: EdgeInsets.all(16),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancelar", style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.pop(contex),
                  ),
                  FlatButton(
                    child: Text("Confirmar", style: TextStyle(color: Colors.green),),
                    onPressed: (){
                      setState(() {
                        _imageni = "pictures/umdois.png";
                      });
                      //salvar requisicao
                      _salvarRequisicao();
                      //salvar requisicao ativa
                      Navigator.pop(contex);

                    },
                  )
                ],
              );
            }
        );

  }
  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  Requisicao requisicao = Requisicao();
  _salvarRequisicao() async {

    /*

    + requisicao
      + ID_REQUISICAO
        + destino (rua, endereco, latitude...)
        + passageiro (nome, email...)
        + motorista (nome, email..)
        + status (aguardando, a_caminho...finalizada)

    * */

    Usuario doc = await UsuarioFirebase.getDadosUsuarioLogado();


    requisicao.paciente = doc;
    requisicao.code = Uuid().v1().substring(0, 6);
    requisicao.status = StatusRequisicao.AGUARDANDO;

    Firestore db = Firestore.instance;

    db.collection("requisicoes")
        .document(requisicao.id)
    .setData(requisicao.toMap())
    ;
    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = doc.idUsuario;
    dadosRequisicaoAtiva["code"] = requisicao.code;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;
   db.collection("requisicao_ativa")
    .document(doc.idUsuario)
    .setData(dadosRequisicaoAtiva);



  }
  _statusLeitura(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ChercherRoof(requisicao.code, requisicao.id)
    ));
  }
  _adicionarListenerRequisicaoAtiva()async{
    FirebaseUser  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    Firestore db = Firestore.instance;
    await db.collection("requisicao_ativa")
    .document(firebaseUser.uid)
    .snapshots()
    .listen((snapshot){
      if(snapshot.data != null){
        Map<String, dynamic> dados = snapshot.data;
        String status = dados["status"];
         _idRequisicao = dados["id_requisicao"];
        switch(status){
          case StatusRequisicao.AGUARDANDO :
            _statusAguardando();
            break;
          case StatusRequisicao.LER :
            _statusLeitura();
            break;
          case StatusRequisicao.VIDEO :
            break;
          case StatusRequisicao.FINALIZADA :
            break;


        }
      }else{
        _statusSemConsulta();
      }
    });

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    _adicionarListenerRequisicaoAtiva();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel de Consulta"),
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
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(_imageni),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : EdgeInsets.all(10),
                child: RaisedButton(
                    child: Text(
                      _textoBotao,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: _corBotao,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: (){
                      _funcaoBotao();
                    }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
