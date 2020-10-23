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
  String tiempoText = '';

  //////////////
  int state = 0;
  @override
  void initState() {
    futureString = '';
    data = this.widget.data;
    super.initState();
    geolocalizacion();
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
                  return errorInfo('EL QR TIENE UN VALOR NULO');
                }
              } else {
                return errorInfo('EL QR NO CONTIENE DATA');
              }
            });
      } else if (state == 2) {
        return errorInfo('EL QR LEIDO TIENE MENOS O MAS DE 8 DIGITOS');
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

  errorInfo(String error) {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        state = 0;
      });
    });
    return Card(
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                  Text(
                    'ERROR EN EL QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                '*Nota el QR contiene esta data $futureString',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
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
  }

  imagen(String cadena) {
    if (cadena == null) {
      return Image.asset('assets/image_default.png');
    } else {
      return Image.network(cadena);
    }
  }

  String tipoMensaje(String fn, PerfilModel model) {
    String result;
    switch (fn) {
      case 'INGRESO':
        marcationModel.marcadoTipo = 'Ingreso';
        notificationModel.titulo = 'Ingreso a labor';
        notificationModel.cuerpo =
            '${model.empleadoNombre} ${model.empleadoApellido} marcó su ingreso desde la tablet';
        result = 'Bienvenido, acabá de registrar su ingreso';
        break;
      case 'SALIDA':
        marcationModel.marcadoTipo = 'Salida del trabajo';
        notificationModel.titulo = 'Salida del trabajo';
        notificationModel.cuerpo =
            '${model.empleadoNombre} ${model.empleadoApellido} marcó su salida del trabajo desde la tablet';
        result = 'Acabá de marcar su salida del trabajo, hasta luego';
        break;
      case 'REFRIGERIO':
        marcationModel.marcadoTipo = 'Hora de almuerzo';
        notificationModel.titulo = 'Hora de almuerzo';
        notificationModel.cuerpo =
            '${model.empleadoNombre} ${model.empleadoApellido} marcó su hora de almuerzo desde la tablet';
        result = 'Bienvenido al comedor, tiene 40 min de estancia';
        break;
      case 'RETORNO':
        marcationModel.marcadoTipo = 'Fin de refrigerio';
        notificationModel.titulo = 'Fin de refrigerio';
        notificationModel.cuerpo =
            '${model.empleadoNombre} ${model.empleadoApellido} marcó su fin de refrigerio desde la tablet';
        result = 'Acaba de marcar su fin de refrigerio, de regreso al trabajo';
        break;
      default:
    }
    return result;
  }

  infoCard(PerfilModel model, BuildContext context) {
    Color color = Color(0xFF76F011);
    DateFormat formatActual = DateFormat('yyyy-MM-dd HH:mm');
    DateTime tiempoActual = DateTime.parse(formatActual.format(DateTime.now()));
    ///////////--LLENADO DE MODELOS--/////////////
    model.empleadoDni = futureString;
    model.idEmpresa = 0;
    marcationModel.marcadoDni = futureString;
    marcationModel.marcadoFechaHora = tiempoActual.toString();
    marcationModel.marcadoDataQr = data;
    marcationModel.marcadoIdTelefono = model.empleadoTelefono;
    marcationModel.marcadoTiempo = tiempoActual.toString();
    marcationModel.marcadoTemperatura = 0.0;
    notificationModel.idTelefono = model.empleadoTelefono;
    notificationModel.fechahora = tiempoActual.toString();
    tiempoText = tipoMensaje(data, model);
    marcationModel.marcadoMotivo = data;
    services(
        context, marcationModel, notificationModel, model, model.empleadoToken);

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
                'PASE CONCEDIDO',
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
