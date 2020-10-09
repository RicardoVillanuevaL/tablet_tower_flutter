import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/InnerJoinModel.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as alerta;

class ReportePage extends StatefulWidget {
  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  String imageState;
  String messageState;
  bool state, send;
  List<ReporteModel> listaData;
  String diaActual;
  File file;
  String pathG;

  @override
  void initState() {
    listaData = List();
    state = false;
    send = false;
    imageState = 'assets/xlsLoad.png';
    messageState = 'Generando reporte . . .';
    final df = new DateFormat('dd-MM-yyyy');
    diaActual = df.format(DateTime.now());
    loadData();
    super.initState();
  }

  Future<void> exportarData(context) async {
    try {
      List<List<String>> csvData = [
        <String>[
          'DNI',
          'Nombre',
          'Apellido',
          'Fecha',
          'Hora',
          'Coord. Latitud',
          'Coord. Longitud',
          'Tipo de Marcado',
          'Temperatura'
        ],
        ...listaData.map((item) => [
              item.marcadoDni,
              item.empleadoNombre,
              item.empleadoApellido,
              item.marcadoFechaHora,
              item.marcadoTiempo,
              item.marcadoLatitud,
              item.marcadoLongitud,
              item.marcadoTipo,
              item.marcadoTemperatura.toString()
            ]),
      ];

      String csv = const ListToCsvConverter().convert(csvData);
      final String dir = (await getExternalStorageDirectory()).path;
      final String path = '$dir/reporteTablet $diaActual.csv';
      file = File(path);
      await file.writeAsString(csv);
      alerta.alertaConImagen(
          context, 'Exito!', 'Ya se creó el reporte', 'assets/xls.png');
      setState(() {
        pathG = path;
        send = true;
      });
    } catch (e) {
      alerta.mostraralerta(
          context, 'Alerta!', 'Error al generar o descargar el reporte');
      print(e);
    }
  }

  widgetImageState(double height) {
    return Center(
        child: Container(
      child: Image(image: AssetImage(imageState)),
      height: height / 2,
    ));
  }

  loadData() async {
    try {
      listaData = await RepositoryServicesLocal.selectReporte();
      if (listaData.length > 0) {
        setState(() {
          imageState = 'assets/xlsSucces.png';
          messageState = 'Esta listo para generarsé y descargarsé';
          state = true;
        });
        //'Descargar Reporte'
      } else {
        setState(() {
          imageState = 'assets/xlsLoad.png';
          messageState = 'Generando reporte . . . ';
        });
      }
    } catch (e) {
      setState(() {
        imageState = 'assets/xlsError.png';
        messageState = 'Error al generar el reporte';
      });
      print(e);
    }
  }

  widgetStates() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              messageState,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black26),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (state)
            OutlineButton.icon(
              color: Colors.green,
              onPressed: () {
                exportarData(context);
              },
              icon: Icon(Icons.file_download),
              label: Text(
                'Descargar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          if (send)
            RaisedButton.icon(
              color: Colors.blue,
              onPressed: () {
                _shareCSV();
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: Text(
                'Enviar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _shareCSV() async {
    try {
      Uint8List listByte = file.readAsBytesSync();
      final ByteData bytes = ByteData.view(listByte.buffer);
      await Share.file(
          'Reporte', 'Reporte.csv', bytes.buffer.asUint8List(), 'text/csv');
    } catch (e) {
      print('error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generar Reportes',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Table(
          children: <TableRow>[
            TableRow(children: [
              widgetImageState(screenHeight),
              widgetStates(),
            ])
          ],
        ),
      ),
    );
  }
}
