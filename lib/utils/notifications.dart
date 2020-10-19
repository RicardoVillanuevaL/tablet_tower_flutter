import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/adminDashBoard.dart';

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

alertaToken(BuildContext context) {
  TextEditingController controller = TextEditingController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Seguridad'),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image(
                  image: AssetImage('assets/password.png'),
                  height: 50,
                ),
              ),
              TextFormField(controller: controller,)
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () =>  Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminDashBoard())),
              child: Text('Ok'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      });
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
      barrierDismissible: true,
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
