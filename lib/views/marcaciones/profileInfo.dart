import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:majascan/majascan.dart';
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
  // SPEAK ASSITENT

  //////////////
  int state = 0;
  @override
  void initState() {
    futureString = '';
    data = this.widget.data;
    super.initState();
    geolocalizacion();
  }

  ////////////////////////////////---todo para los comando de voz---//////////////////////////////////////////////////////////
 

  //////////////////////////////////////////////////////////////////////////////////////////////////////

  scanQR() async {
    String qrResult = '';
    try {
      qrResult = await MajaScan.startScan(
          title: "Tower & Tower S.A.",
          titleColor: Colors.greenAccent[700],
          qRCornerColor: Colors.green,
          qRScannerColor: Colors.green);
      print(qrResult);
      if (qrResult.isNotEmpty) {
        setState(() {
          state = 1;
          futureString = qrResult;
        });
      } else {
        setState(() {
          state = 2;
          futureString =
              "Presionó el botón Atrás antes de escanear cualquier cosa";
        });
      }
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          futureString = "Se denegó el permiso de la cámara";
          state = 2;
        });
      } else {
        setState(() {
          state = 2;
          futureString = "Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        state = 2;
        print(state);
        futureString =
            "Presionó el botón Atrás antes de escanear cualquier cosa";
      });
    } catch (ex) {
      setState(() {
        state = 2;
        futureString = "Error $ex";
      });
    }
  }

  marcationType() async {
    try {
      var resultBarCode = await BarcodeScanner.scan();
      if (resultBarCode != null) {
        setState(() {
          state = 1;
          futureString = resultBarCode;
        });
      } else {
        setState(() {
          state = 2;
        });
      }
    } catch (e) {
      setState(() {
        state = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    contentWidget() {
      if (state == 0) {
        scanQR();
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
                return Center(
                  child: CircularProgressIndicator(),
                );
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

    Future<bool> _backPress() {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      return null;
    }

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SE DETUVO EL LECTOR',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.replay,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        state = 0;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '¿Desea abrirlo?',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Center(child: contentWidget())
          ],
        ),
        onWillPop: () => _backPress(),
      ),
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
              SizedBox(height: 20),
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
    // Future.delayed(const Duration(seconds: 5), () {
    //   setState(() {
    //     state = 0;
    //   });
    // });
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
    String temp = DateFormat.Hms().format(DateTime.now()).trim();
    ///////////--LLENADO DE MODELOS--/////////////
    model.empleadoDni = futureString;
    model.idEmpresa = 0;
    marcationModel.marcadoDni = futureString;
    marcationModel.marcadoFechaHora = tiempoActual.toString();
    marcationModel.marcadoDataQr = data;
    marcationModel.marcadoIdTelefono = model.empleadoTelefono;
    marcationModel.marcadoTiempo = temp;
    marcationModel.marcadoTemperatura = 0.0;
    notificationModel.idTelefono = model.empleadoTelefono;
    notificationModel.fechahora = tiempoActual.toString();
    tiempoText = tipoMensaje(data, model);
    marcationModel.marcadoMotivo = data;
    //'${model.empleadoNombre} ${model.empleadoApellido}
    // services(
    //     context, marcationModel, notificationModel, model, model.empleadoToken);

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
                  child: Image.asset('assets/image_default.png'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
