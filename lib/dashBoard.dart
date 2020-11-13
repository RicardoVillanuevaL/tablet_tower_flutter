import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/profileInfo.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width - 30.0;
    final screenHeight = screenSize.height - 30.0;
    return Scaffold(
      body: Center(
        child: tableDashBoard(screenWidth, screenHeight),
      ),
    );
  }

  tableDashBoard(double width, double height) {
    return Table(
      children: <TableRow>[
        TableRow(children: [
          itemTable(width / 2, height / 2, 'assets/ingreso.png',
              'Marcar ingresos', 0),
          itemTable(
              width / 2, height / 2, 'assets/logout.png', 'Marcar Salidas', 1)
        ]),
        TableRow(children: [
          itemTable(width / 2, height / 2, 'assets/rotura.png',
              'Marcar Refrigerios', 2),
          itemTable(width / 2, height / 2, 'assets/retorno edit.png',
              'Marcar fin de refrigerios', 3)
        ]),
      ],
    );
  }

  itemTable(double width, double height, String image, String texto, int fn) {
    return InkWell(
      onTap: () => action(fn),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: width,
        child: Column(
          children: [
            Image(
              height: height - 50,
              image: AssetImage(image),
            ),
            Text(
              texto,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  void action(int fn) {
    //0 INGRESO
    //1 SALIDA
    //2 REFIRGERIO
    //3 RETORNO
    switch (fn) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileInfo('INGRESO')));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileInfo('SALIDA')));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileInfo('REFRIGERIO')));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileInfo('RETORNO')));
        break;
      default:
    }
  }
}
