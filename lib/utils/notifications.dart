import 'package:flutter/material.dart';

mostraralerta(BuildContext context,String header, String mensaje){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(header),
          content: Text(mensaje),       
          actions: <Widget>[
            FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Ok'))
          ], 
        );
      }
  );
}