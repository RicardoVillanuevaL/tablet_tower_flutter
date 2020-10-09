import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostraralerta(BuildContext context, String header, String mensaje) {
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(header),
          content: Text(mensaje),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        );
      });
}

alertaEspecialEnviarEmail(BuildContext context, String titulo, String mensaje,
    String imagen, File file) {
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(titulo),
          content: Column(
            children: [
              Container(
                child: Image.asset(imagen),
                height: 50,
                margin: EdgeInsets.only(top: 20, bottom: 20),
              ),
              Text(mensaje),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        );
      });
}

dialogConfirmacionToken(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 2,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          width: 500,
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            child: Container(
              child: Image.asset('assets/password.png'),
            ),
          ),
        ),
      ],
    ),
  );
}

alertaConImagen(
    BuildContext context, String titulo, String mensaje, String imagen) {
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(titulo),
          content: Column(
            children: [
              Container(
                child: Image.asset(imagen),
                height: 50,
                margin: EdgeInsets.only(top: 20, bottom: 20),
              ),
              Text(mensaje),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        );
      });
}

alertaRegistroMarcacion(BuildContext context, String title, String mensaje) {
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Container(
                child: Image.asset('assets/connectionError.png'),
                height: 50,
                margin: EdgeInsets.only(top: 20, bottom: 20),
              ),
              Text(mensaje),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        );
      });
}

alertWaitDialog(
    BuildContext context, String title, String mensaje, String image) {
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Container(
                child: Image.asset(image),
                height: 50,
                margin: EdgeInsets.only(top: 20, bottom: 20),
              ),
              Text(mensaje),
            ],
          ),
        );
      });
  // en el codigo donde lo llamas le agregas 
  // await Future.delayed(Duration(seconds: 3));
  // Navigator.pop(context);
}
