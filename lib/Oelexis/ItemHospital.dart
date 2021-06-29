import 'package:flutter/material.dart';

import 'package:i_health/Classes/Hospital.dart';

class ItemHospital extends StatelessWidget {

  Hospital hospital;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemHospital({
    @required this.hospital,
    this.onTapItem,
    this.onPressedRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: <Widget>[

            SizedBox(
              width: 150,
              height: 150,
              child: Image.network(
                hospital.fotos[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hospital.nome,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                  ],),
              ),
            ),
            if( this.onPressedRemover != null ) Expanded(
              flex: 1,
              child: FlatButton(
                color: Colors.red,
                padding: EdgeInsets.all(10),
                onPressed: this.onPressedRemover,
                child: Icon(Icons.delete, color: Colors.white,),
              ),
            )
            //botao remover

          ],),
        ),
      ),
    );
  }
}
