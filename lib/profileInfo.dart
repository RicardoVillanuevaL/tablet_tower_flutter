import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/services/all_services.dart';

class ProfileInfo extends StatefulWidget {
  final String data;
  ProfileInfo(this.data);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  String statusConnection;
  bool _connectionStatus;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  String data;
  IconData iconData;
  Color color;
  MarcationModel marcationModel = MarcationModel();
  NotificationModel notificationModel = NotificationModel();
  @override
  void initState() {
    data = this.widget.data;
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        setStatus(result);
      });
    });
    if (iconData == null || color == null) {
      statusConnection = 'Error de conexión';
      iconData = Icons.find_replace;
      color = Colors.orange;
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      iconData = Icons.check_circle;
      color = Colors.green;
      _connectionStatus = true;
      statusConnection = 'Conexión Exitosa';
    } else {
      iconData = Icons.error;
      color = Colors.red;
      _connectionStatus = false;
      statusConnection = 'No existe conexión';
    }
  }

  geolocalizacion() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus.toString());
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    notificationModel.latitud = position.latitude.toString();
    notificationModel.longitud = position.longitude.toString();
    marcationModel.marcadoLatitud = position.latitude.toString();
    marcationModel.marcadoLongitud = position.longitude.toString();
  }

  void services(MarcationModel marcation, NotificationModel notification,
      PerfilModel perfil, String token) async {
    if (_connectionStatus) {
      await allservices.registrarMarcacion(marcation, token);
      await allservices.registrarNotification(notification, token);
      RepositoryServicesLocal.addMarcado(marcation);
      RepositoryServicesLocal.addEmpleado(perfil);
      RepositoryServicesLocal.addNotificacion(notification);
    } else {
      RepositoryServicesLocal.addMarcado(marcation);
      RepositoryServicesLocal.addEmpleado(perfil);
      RepositoryServicesLocal.addNotificacion(notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus) {
      return Scaffold(
        body: Center(
          child: FutureBuilder(
            future: allservices.encuentraTrabajador(data),
            builder:
                (BuildContext context, AsyncSnapshot<PerfilModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return infoCard(snapshot.data);
                } else {
                  return errorInfo();
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: FloatStatus(color, iconData, statusConnection),
      );
    } else {
      return Scaffold(
        body: Center(
          child: FutureBuilder(
            future: RepositoryServicesLocal.consultarEmpleadoJson(data),
            builder:
                (BuildContext context, AsyncSnapshot<PerfilModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return infoCard(snapshot.data);
                } else {
                  return errorInfo();
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: FloatStatus(color, iconData, statusConnection),
      );
    }
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

  imagen(String cadena) {
    if (cadena == null) {
      return Image.asset('assets/image_default.png');
    } else {
      return Image.network(cadena);
    }
  }

  back() async {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false);
    });
  }

  infoCard(PerfilModel model) {
    Color color = Color(0xFF76FF03);
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

    ///////////--LLENADO DE MODELOS--/////////////
    model.empleadoDni = data;
    marcationModel.marcadoDni = data;
    marcationModel.marcadoFechaHora = tiempoActual.toString();
    marcationModel.marcadoDataQr = data;
    marcationModel.marcadoIdTelefono = model.empleadoTelefono;
    marcationModel.marcadoTiempo = tiempoActual.toString();
    marcationModel.marcadoTemperatura = 0.0;
    notificationModel.idTelefono = model.empleadoTelefono;
    notificationModel.fechahora = tiempoActual.toString();
    geolocalizacion();
    if ((tTotalActual > tTotalInicio || tTotalActual == tTotalInicio) &&
        tTotalActual < tTotalFin) {
      marcationModel.marcadoMotivo = 'Hora de almuerzo';
      marcationModel.marcadoTipo = 'Refrigerio';
      notificationModel.titulo = 'Refrigerio';
      notificationModel.cuerpo =
          '${model.empleadoNombre} ${model.empleadoApellido} marcó su hora de almuerzo';
      tiempoText =
          'Su tiempo de estancia en el comedor es de $tiempoRest minutos';
      services(marcationModel, notificationModel, model, model.empleadoToken);
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
      tiempoText =
          'Ya han pasado $tiempoJ minutos, Para que ingrese al comedor';
      services(marcationModel, notificationModel, model, model.empleadoToken);
    }

    back();
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
          child: Flexible(
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
      ),
    );
  }
}

class FloatStatus extends StatelessWidget {
  final Color colors;
  final IconData icon;
  final String statusConnect;
  const FloatStatus(this.colors, this.icon, this.statusConnect);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: colors,
        elevation: 0,
        highlightElevation: 0,
        child: Icon(
          icon,
          size: 40.0,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(statusConnect,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            backgroundColor: colors,
            duration: Duration(seconds: 3),
          ));
        });
  }
}
