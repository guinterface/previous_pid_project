import 'package:flutter/material.dart';
class BancoDeDados extends StatefulWidget {
  @override
  _BancoDeDadosState createState() => _BancoDeDadosState();
}

class _BancoDeDadosState extends State<BancoDeDados> {

  _exibirTelaCadastro(){
    showDialog(context: context,
    builder: (context){

      return AlertDialog(
        title: Text("Ola", style: TextStyle(fontSize: 24),),
        content: Column(
          children: <Widget>[
            TextField(
            controller: _titulo,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "O que aconteceu? ",
                hintText: "Ex: Dor de cabeça"

              ),
            ),
            TextField(
              controller: _descricao,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Descreva: ",
                  hintText: "Descreva o ocorrido com sua saúde...",

              ),
            ),
          ],
        ),

        actions: <Widget>[
          FlatButton(
            onPressed: ()=> Navigator.pop(context),
            child:Text("Cancelar"),

          ),
          FlatButton(
            onPressed: (){},
            child:Text("Salvar"),

          ),
        ],

      );

    }
    );
    
  }
TextEditingController _titulo = TextEditingController();
  TextEditingController _descricao = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(


      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.white,
        onPressed: (){
          _exibirTelaCadastro();

        },
        child: Icon(Icons.add),
      ),

    );
  }
}
