import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/services/all_services.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as alerta;

class SincronizacionPage extends StatefulWidget {
  @override
  _SincronizacionPageState createState() => _SincronizacionPageState();
}

class _SincronizacionPageState extends State<SincronizacionPage> {
  StreamSubscription<ConnectivityResult> subscription;
  bool _connectionStatus;
  Connectivity connectivity;
  String imageStateConnection;
  String imageStateSincronic;
  String messageStateConnection;
  String messageStateSincronic;
  bool state;
  String diaActual;
  ////////LISTAS PARA SINCRONIZAR
  List<MarcationModel> listaMarcaciones;
  List<NotificationModel> listaNotificaciones;
  List<PerfilModel> listaEmpleados;
  PerfilModel tokenAdmin;

  @override
  void initState() {
    _connectionStatus = false;
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        setStatus(result);
      });
    });
    imageStateConnection = 'assets/loader.png';
    imageStateSincronic = 'assets/cloudLoad.png';
    messageStateConnection = 'Estabilizando conexiones . . .';
    messageStateSincronic = 'Cargando registros . . .';
    tokenAdmin = PerfilModel();
    listaEmpleados = List();
    listaMarcaciones = List();
    listaNotificaciones = List();
    state = false;
    final df = new DateFormat('dd-MM-yyyy');
    diaActual = df.format(DateTime.now());
    loadDataSincronization();
    specialFilter();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  setStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      imageStateConnection = 'assets/connectionSuccess.png';
      _connectionStatus = true;
      messageStateConnection = 'Conexión Exitosa';
    } else {
      imageStateConnection = 'assets/connectionError.png';
      _connectionStatus = false;
      messageStateConnection = 'No existe conexión';
    }
  }

  specialFilter() async {
    List<PerfilModel> tempList = List();
    tempList = await RepositoryServicesLocal.sincroEmployee();
    for (var temp in tempList) {
      if (temp.idEmpresa != 1) {
        temp.empleadoDni = temp.empleadoDni;
        temp.empleadoEmail = ' ';
        temp.empleadoContrasena = ' ';
        temp.empleadoFoto = ' ';
        temp.empleadoToken = ' ';
        temp.empleadoTokencelular = ' ';
        temp.usuarioDniJefe = ' ';
        temp.tipoIdCargo = 0;
        temp.idArea = 0;
        temp.idTurno = 0;
        listaEmpleados.add(temp);
        print(temp.empleadoDni);
      }
    }
  }

  loadDataSincronization() async {
    try {
      tokenAdmin = await allservices.encuentraTrabajador('77154956');
      listaMarcaciones = await RepositoryServicesLocal.listarMarcaciones();
      listaNotificaciones = await RepositoryServicesLocal.listaNotificaciones();
      if (listaMarcaciones.length > 0 && listaNotificaciones.length > 0) {
        setState(() {
          imageStateSincronic = 'assets/cloud_server.png';
          messageStateSincronic = 'Registros cargados para sincronizar';
          state = true;
        });
      } else {
        imageStateSincronic = 'assets/cloudLoad.png';
        messageStateSincronic = 'Ya casi están los registros listos';
      }
    } catch (e) {
      print(e);
      imageStateSincronic = 'assets/cloudError.png';
      messageStateSincronic = 'Oh no!, Error al cargar los registros';
    }
    print(tokenAdmin.empleadoToken);
  }

  widgetInfo(double height) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Text('Información de la tablet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          Flexible(
              child: Text('Información de la conexión: $messageStateConnection',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          Flexible(
              child: Text(
                  'Información de la última sincronización: $messageStateSincronic',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          SizedBox(
            height: 30,
          ),
          button(),
          SizedBox(
            height: 30,
          ),
        ]);
  }

  sincronizarData(BuildContext context, int cantidad) {
    int cantidadData = 0;
    try {
      for (var node in listaMarcaciones) {
        allservices.registrarMarcacion(node, tokenAdmin.empleadoToken);
        cantidadData++;
        setState(() {
          messageStateSincronic = 'Ya se subieron $cantidadData / $cantidad';
        });
      }
      for (var node in listaNotificaciones) {
        allservices.registrarNotification(node, tokenAdmin.empleadoToken);
        cantidadData++;
        setState(() {
          messageStateSincronic = 'Ya se subieron $cantidadData / $cantidad';
        });
      }
      for (var node in listaEmpleados) {
        allservices.registrarEmpleado(node, tokenAdmin.empleadoToken);
        cantidadData++;
        setState(() {
          messageStateSincronic = 'Ya se subieron $cantidadData / $cantidad';
        });
      }
      alerta.alertaConImagen(context, 'Exitó!', 'La sincronización fue exitosa',
          'assets/cloudSuccess.png');
      setState(() {
        imageStateSincronic = 'assets/cloudSuccess.png';
      });
    } catch (e) {
      alerta.alertaConImagen(
          context, 'Oh no!', 'Ocurrio un error', 'assets/cloudError.png');
      print(e);
      setState(() {
        imageStateSincronic = 'assets/cloudError.png';
      });
    }
  }

  button() {
    if (state && _connectionStatus) {
      return OutlineButton.icon(
        color: Colors.green,
        onPressed: () {
          sincronizarData(
              context,
              listaMarcaciones.length +
                  listaNotificaciones.length +
                  listaEmpleados.length);
        },
        icon: Icon(Icons.cloud_upload),
        label: Text(
          'Sincronizar',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return Container();
    }
  }

  wigdetStates(double height) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(imageStateConnection),
            fit: BoxFit.fill,
            height: height / 4,
          ), //IMAGEN DE ESTADO DE CONEXION
          SizedBox(
            height: 30,
          ),
          Image(
            image: AssetImage(imageStateSincronic),
            fit: BoxFit.fill,
            height: height / 4,
          )
        ], //IMAGEN DE ESTADO DE SINCRONIZACION
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Sincronización',textAlign: TextAlign.center,),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Table(
            children: <TableRow>[
              TableRow(children: [
                widgetInfo(screenHeight),
                wigdetStates(screenHeight),
              ])
            ],
          ),
        ));
  }
}
