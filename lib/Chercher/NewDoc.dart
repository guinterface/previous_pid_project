import 'dart:io';
import 'package:geohash/geohash.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_health/Classes/Doc.dart';
import 'package:i_health/Classes/Hospital.dart';
import 'package:i_health/Oelexis/BotaoCustomizado.dart';
import 'package:i_health/Oelexis/Configuracoes.dart';
import 'package:i_health/Oelexis/InputCustomizado.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:validadores/Validador.dart';


class NewDoc extends StatefulWidget {
  @override
  _NewDocState createState() => _NewDocState();
}

class _NewDocState extends State<NewDoc> {

  List<File> _listaImagens = List();
  final _formKey = GlobalKey<FormState>();
  Doc _anuncio;
  BuildContext _dialogContext;
  String _itemSelecionadoCategoria;



  _selecionarImagemGaleria() async {

    File imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);

    if( imagemSelecionada != null ){
      setState(() {
        _listaImagens.add( imagemSelecionada );
      });
    }

  }

  _abrirDialog(BuildContext context){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio...")
              ],),
          );
        }
    );

  }

  _salvarAnuncio() async {

    _abrirDialog( _dialogContext );

    //Upload imagens no Storage
    await _uploadImagens();
    //Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    db.collection("meus_doutores")
        .document( idUsuarioLogado )
        .collection("doctors")
        .document( _anuncio.id )
        .setData( _anuncio.toMap() ).then((_){

      //salvar anúncio público
      db.collection("doctors")
          .document( _anuncio.id )
          .setData( _anuncio.toMap() ).then((_){

        Navigator.pop(_dialogContext);
        Navigator.pop(context);

      });

    });


  }

  Future _uploadImagens() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for( var imagem in _listaImagens ){

      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child("meus_hospitais")
          .child( _anuncio.id )
          .child( nomeImagem );

      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);

    }

  }

  @override
  void initState() {
    super.initState();

    _anuncio = Doc.gerarId();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: ( imagens ){
                    if( imagens.length == 0 ){
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state){
                    return Column(children: <Widget>[
                      Container(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1, //3
                            itemBuilder: (context, indice){
                              if( indice == _listaImagens.length ){
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color: Colors.grey[100]
                                            ),
                                          )
                                        ],),
                                    ),
                                  ),
                                );
                              }

                              if( _listaImagens.length > 0 ){
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Image.file( _listaImagens[indice] ),
                                                FlatButton(
                                                  child: Text("Excluir"),
                                                  textColor: Colors.red,
                                                  onPressed: (){
                                                    setState(() {
                                                      _listaImagens.removeAt(indice);
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                )
                                              ],),
                                          )
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage( _listaImagens[indice] ),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, color: Colors.red,),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();

                            }
                        ),
                      ),
                      if( state.hasError )
                        Container(
                          child: Text(
                            "[${state.errorText}]",
                            style: TextStyle(
                                color: Colors.red, fontSize: 14
                            ),
                          ),
                        )
                    ],);
                  },
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Categoria",
                    onSaved: (titulo){
                      _anuncio.categoria = titulo;
                    },
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Descricao",
                    onSaved: (titulo){
                      _anuncio.descricao = titulo;
                    },
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "estrelas",
                    onSaved: (longitude){
                      _anuncio.estrelas = int.parse(longitude);
                    },
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),




                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Nome (200 caracteres)",
                    onSaved: (descricao){
                      _anuncio.nome = descricao;
                    },
                    maxLines: null,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),

                BotaoCustomizado(
                  texto: "Manda aí",
                  onPressed: (){

                    if( _formKey.currentState.validate() ){

                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar anuncio
                      _salvarAnuncio();

                    }
                  },
                ),
              ],),
          ),
        ),
      ),
    );
  }
}
