import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {

  static List<DropdownMenuItem<String>> getCategorias(){

    List<DropdownMenuItem<String>> itensDropCategorias = [];

    //Categorias
    itensDropCategorias.add(
        DropdownMenuItem(child: Text(
          "Categoria", style: TextStyle(
            color: Colors.deepOrangeAccent
        ),
        ), value: null,)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Olhos"), value: "olhos",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Cardio Vascular"), value: "cardiovascular",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Respiratório"), value: "respiracao",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Pele"), value: "pele",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Pediatria"), value: "pediatria",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Rins e fígado"), value: "rinsefigado",)
    );

    itensDropCategorias.add(
        DropdownMenuItem(child: Text("Outro"), value: "outro",)
    );
    return itensDropCategorias;

  }

}