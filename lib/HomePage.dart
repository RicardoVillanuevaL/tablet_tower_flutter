import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/adminEmployee.dart';
import 'package:tablet_tower_flutter/profileInfo.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as util;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width - 30.0;
    final screenHeight = screenSize.height - 30.0;
    return Scaffold(
      body: Center(child: tableDashBoard(screenWidth, screenHeight)),
    );
  }

  tableDashBoard(double width, double height) {
    return Table(
      children: <TableRow>[
        TableRow(children: [
          itemTable(
              width / 2, height / 2, 'assets/search.png', 'Hora almuerzo', 0),
          itemTable(width / 2, height / 2, 'assets/admin.png',
              'Administrar Personal', 1)
        ])
      ],
    );
  }

  itemTable(double width, double height, String image, String texto, int fn) {
    return InkWell(
      onTap: () => action(fn),
      child: Container(
        width: width,
        child: Column(
          children: [
            Image(
              height: height - 50,
              image: AssetImage(image),
            ),
            Text(texto)
          ],
        ),
      ),
    );
  }

  void action(int fn) {
    //0 search
    //1 admin
    switch (fn) {
      case 0:
        marcationType();
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminEmpoyee()));
        break;
      default:
    }
  }

  marcationType() async {
    String futureString = '';
    try {
      futureString = await BarcodeScanner.scan();
      if (futureString != null) {
        if (futureString.trim().length == 8) {
          String contenido = futureString;
          print(contenido);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfileInfo(contenido)));
        } else {
          util.mostraralerta(context, 'Alerta!', 'Ese QR no es valido');
        }
      }
    } catch (e) {
      futureString = e.toString();
    }
  }
}
