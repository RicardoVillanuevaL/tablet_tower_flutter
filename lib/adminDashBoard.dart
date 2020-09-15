import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/listSpecialEmployee.dart';
import 'package:tablet_tower_flutter/listaEmpleados.dart';
import 'package:tablet_tower_flutter/reportePage.dart';
import 'package:tablet_tower_flutter/sincronizacionPage.dart';

class AdminDashBoard extends StatefulWidget {
  AdminDashBoard({Key key}) : super(key: key);

  @override
  _AdminDashBoardState createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
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
          itemTable(width / 2, height / 2, 'assets/list2.png',
              'Lista de Empleados', 0),
          itemTable(width / 2, height / 2, 'assets/attendance.png',
              'Lista de Trabajadores', 1),
        ]),
        TableRow(children: [
          itemTable(width / 2, height / 2, 'assets/uploadData.png',
              'Sincronización', 2),
          itemTable(width / 2, height / 2, 'assets/report.png',
              'Generar Reportes', 3),
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  void action(int fn) {
    switch (fn) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListadoEmpleados()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListSpecialEmployee()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SincronizacionPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ReportePage()));
        break;
      default:
    }
  }
}