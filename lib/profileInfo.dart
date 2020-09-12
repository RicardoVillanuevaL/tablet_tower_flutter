import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';

class ProfileInfo extends StatefulWidget {
  final String data;
  ProfileInfo(this.data);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  String futureString;
  String data;
  MarcationModel marcationModel = MarcationModel();
  NotificationModel notificationModel = NotificationModel();
  //////////////
  int state = 0;
  @override
  void initState() {
    futureString = '';
    data = this.widget.data;
    super.initState();
  }

  marcationType() async {
    try {
      futureString = await BarcodeScanner.scan();
      if (futureString != null) {
        if (futureString.trim().length == 8) {
          setState(() {
            state = 1;
            futureString = futureString.trim();
          });
        } else {
          setState(() {
            state = 2;
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        state = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    contentWidget() {
      if (state == 0) {
        marcationType();
      } else if (state == 1) {
        return FutureBuilder(
            future: RepositoryServicesLocal.consultarEmpleado(futureString),
            builder:
                (BuildContext context, AsyncSnapshot<PerfilModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return infoCard(snapshot.data, context);
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            });
      } else if (state == 2) {
        return errorInfo();
      } else if (state == 3) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Se detuvó el scanner!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FloatingActionButton(
                child: Icon(
                  Icons.replay,
                  color: Colors.white,
                  size: 30,
                ),
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  setState(() {
                    state = 0;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Abrir Scanner',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: Center(child: contentWidget()),
    );
  }

  errorInfo() {
    return Card(
        color: Colors.red,
        child: Column(
          children: [
            Text(
              'ERROR EN EL QR, TRABAJOR NO REGISTRADO',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  geolocalizacion() async {
    notificationModel.latitud = 'latitud Tablet';
    notificationModel.longitud = 'longitud Tablet';
    marcationModel.marcadoLatitud = 'latitud Tablet';
    marcationModel.marcadoLongitud = 'longitud Tablet';
  }

  void services(BuildContext context, MarcationModel marcation,
      NotificationModel notification, PerfilModel perfil, String token) async {
    RepositoryServicesLocal.addMarcado(marcation);
    RepositoryServicesLocal.addEmpleado(perfil);
    RepositoryServicesLocal.addNotificacion(notification);
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        state = 0;
      });
    });
    print('REGISTRO');
  }

  imagen(String cadena) {
    if (cadena == null) {
      return Image.asset('assets/image_default.png');
    } else {
      return Image.network(cadena);
    }
  }

  infoCard(PerfilModel model, BuildContext context) {
    Color color = Color(0xFF76F011);
    String paseText = 'PASE CONCEDIDO';
    String tiempoText = '';
    String horaInicio = model.horaInicio;
    String horaFin = model.horaFin;
    int hInicio = int.parse(horaInicio.substring(0, 2));
    int mInicio = int.parse(horaInicio.substring(3, 5));
    int hFin = int.parse(horaFin.substring(0, 2));
    int mFin = int.parse(horaFin.substring(3, 5));
    DateFormat formatActual = DateFormat('yyyy-MM-dd HH:mm');
    DateTime tiempoActual = DateTime.parse(formatActual.format(DateTime.now()));
    int hActual = int.parse(tiempoActual.toString().substring(11, 13));
    int mActual = int.parse(tiempoActual.toString().substring(14, 16));
    int tTotalInicio = hInicio * 60 + mInicio;
    int tTotalFin = hFin * 60 + mFin;
    int tTotalActual = hActual * 60 + mActual;
    int tiempoRest = tTotalFin - tTotalActual;
    print(tiempoRest);
    ///////////--LLENADO DE MODELOS--/////////////
    model.empleadoDni = futureString;
    marcationModel.marcadoDni = futureString;
    marcationModel.marcadoFechaHora = tiempoActual.toString();
    marcationModel.marcadoDataQr = data;
    marcationModel.marcadoIdTelefono = model.empleadoTelefono;
    marcationModel.marcadoTiempo = tiempoActual.toString();
    marcationModel.marcadoTemperatura = 0.0;
    notificationModel.idTelefono = model.empleadoTelefono;
    notificationModel.fechahora = tiempoActual.toString();
    geolocalizacion();
    tiempoText = 'Bienvenido al comedor, que disfrute su refrigerio';
    if ((tTotalActual > tTotalInicio || tTotalActual == tTotalInicio) &&
        tTotalActual < tTotalFin) {
      marcationModel.marcadoMotivo = 'Hora de almuerzo';
      marcationModel.marcadoTipo = 'Refrigerio';
      notificationModel.titulo = 'Refrigerio';
      notificationModel.cuerpo =
          '${model.empleadoNombre} ${model.empleadoApellido} marcó su hora de almuerzo';
      // tiempoText = 'Su tiempo de estancia en el comedor es de $tiempoRest minutos';
      services(context, marcationModel, notificationModel, model,
          model.empleadoToken);
    } else {
      marcationModel.marcadoMotivo = 'Acceso denegado almuerzo';
      marcationModel.marcadoTipo = 'Refrigerio fuera de hora';
      notificationModel.titulo = 'Acceso denegado refrigerio';
      notificationModel.cuerpo =
          '${model.empleadoNombre} ${model.empleadoApellido} intento marcar su hora de almuerzo, se le denegó la entrada al comedor';

      int tiempoJ = tTotalActual - tTotalFin;
      color = Colors.red;
      paseText = 'PASE DENEGADO';
      tiempoJ = tiempoJ.abs();
      // tiempoText =
      //     'Ya han pasado $tiempoJ minutos, Para que ingrese al comedor';
      services(context, marcationModel, notificationModel, model,
          model.empleadoToken);
    }

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height / 1.2;
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: screenHeight,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: color,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50),
          child: Column(
            children: [
              Text(
                paseText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                height: screenHeight / 2,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: imagen(model.empleadoFoto),
                ),
              ),
              Text(
                '${model.empleadoNombre} ${model.empleadoApellido}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tiempoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
