import 'package:flutter/material.dart';
import 'package:i_health/Chercher/ListaHospitais.dart';

class Cats extends StatefulWidget {
  @override
  _CatsState createState() => _CatsState();
}

class _CatsState extends State<Cats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Categorias"),),
      body: Container(padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
               GestureDetector(
                child: Image.asset(
          "Imagens/pele.png",
          width: 180,
          height: 150,
        ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "pele",)),

                );
                },
              ),
              GestureDetector(
                child: Image.asset(
                  "Imagens/respiracao.png",
                  width: 180,
                  height: 150,
                ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "respiracao",)),

                );
                },
              ),
            ],),
            Row(children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  "Imagens/pediatria.png",
                  width: 180,
                  height: 150,
                ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "pediatria",)),

                );
                },
              ),
              GestureDetector(
                child: Image.asset(
                  "Imagens/rinsefigado.png",
                  width: 180,
                  height: 150,
                ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "rinsefigado",)),

                );
                },
              ),
            ],),
            Row(children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  "Imagens/olhos.png",
                  width: 180,
                  height: 150,
                ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "olhos",)),

                );
                },
              ),
              GestureDetector(
                child: Image.asset(
                  "Imagens/outro.png",
                  width: 180,
                  height: 150,
                ),
                onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHospitais(kwery: "outro",)),

                );
                },
              ),
            ],),
          ],
        ),
      ),


    );
  }
}
