import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_health/Classes/Usuario.dart';
import 'package:i_health/Doof/ChercherDino.dart';
import 'package:i_health/Oelexis/MeusAnuncios.dart';



class TesteDoutor extends StatefulWidget {
  @override
  _TesteDoutorState createState() => _TesteDoutorState();
}

class _TesteDoutorState extends State<TesteDoutor> {

  //Controladores
  TextEditingController _controllerNome = TextEditingController(text: "Guilherme Simioni");
  TextEditingController _controllerEmail = TextEditingController(text: "guilhermesimioni@gmail.com");
  TextEditingController _controllerSenha = TextEditingController(text: "1234567");
  TextEditingController _codeDoutor = TextEditingController(text: "1234567");
  String _mensagemErro = "";


  _validarCampos(){

    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( nome.isNotEmpty ){

      if( email.isNotEmpty && email.contains("@") ){

        if( senha.isNotEmpty && senha.length > 6 ){

          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          usuario.tipoUsuario = "doutor";



          _cadastrarUsuario( usuario );


        }else{
          setState(() {
            _mensagemErro = "Preencha a senha! digite mais de 6 caracteres";
          });
        }

      }else{
        setState(() {
          _mensagemErro = "Preencha o E-mail utilizando @";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }

  }

  _cadastrarUsuario( Usuario usuario ){
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      usuario.idUsuario = firebaseUser.user.uid;
      db.collection("usuarios")
          .document( firebaseUser.user.uid )
          .setData( usuario.toMap() );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChercherDino()
          )
      );

    }).catchError((error){
      print("erro app: " + error.toString() );
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Cadastro Médico"),
        ),


      body: Container(
        decoration: BoxDecoration(color: Colors.white, ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 32, left: 32, bottom: 12),
                    child: Text("Cadastre-se aqui", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 32),)
                ),
                Padding(

                  padding: EdgeInsets.only(top: 12, bottom: 24),
                  child: Image.asset(
                    "pictures/undraw_doctors_hwty.png",
                    width: 300,
                    height: 300,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                      ),
                      color: Colors.yellowAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      }
                  ),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
