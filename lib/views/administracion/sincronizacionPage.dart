import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/EmpleadosDescarga.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
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
  bool sincroCompleta;
  Connectivity connectivity;
  String imageStateConnection;
  String imageStateSincronic;
  String messageStateConnection;
  String messageStateSincronic;
  bool state;
  String diaActual;
  ////////LISTAS PARA SINCRONIZAR
  List<MarcationModel> listaMarcaciones;
  List<MarcationModel> listaNoRegistrados;
  List<PerfilModel> listaEmpleados;
  var listDescargaIcons = [
    Icons.cloud_download,
    Icons.restore_page,
    Icons.check,
    Icons.error_outline
  ];
  int stadoDescarga;

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
    stadoDescarga = 0;
    imageStateConnection = 'assets/loader.png';
    imageStateSincronic = 'assets/cloudLoad.png';
    messageStateConnection = 'Estabilizando conexiones . . .';
    messageStateSincronic = 'Cargando registros . . .';
    listaEmpleados = List();
    listaMarcaciones = List();
    listaNoRegistrados = List();
    state = false;
    sincroCompleta = true;
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
    print('todos ${tempList.length}');
    for (var temp in tempList) {
      print('${temp.empleadoDni} ${temp.idTurno}');
      if (temp.idTurno == null) {
        if (temp.idEmpresa == 1) {
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
        } else {
          print('${temp.idEmpresa}');
        }
      } else {
        print('${temp.idTurno}');
      }
    }
    print('BEFORE ${listaEmpleados.length}');
  }

  generarIndicadorRegistro() async {
    bool result1 = await RepositoryServicesLocal.generarIndicadorEmpleado();
    bool result2 = await RepositoryServicesLocal.generarIndicadorMarcado();
    if (result1 && result2) {
      print('EXITO PERROO');
    } else {
      print('SIGUE INTENTANDO PAPI :(');
    }
  }

  filtroMarcado() {
    List<MarcationModel> tempList = List();
    print('LISTA DE MARCACIONES A UN INICIO ${listaMarcaciones.length}');
    for (var nodo in listaMarcaciones) {
      if (nodo.marcadoDataQr.length < 12) {
        tempList.add(nodo);
      }
    }
    listaMarcaciones.clear();
    listaMarcaciones = tempList;
    print('LISTA DE MARCACIONES AL FINAL ${listaMarcaciones.length}');
  }

  loadDataSincronization() async {
    try {
      listaMarcaciones = await RepositoryServicesLocal.listarMarcaciones();
      if (listaMarcaciones.length > 0) {
        filtroMarcado();
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
  }

  widgetInfo(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Text('Información de la tablet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87))),
              SizedBox(height: 20),
              Flexible(
                  child: Text(
                      'Información de la conexión: $messageStateConnection',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87))),
              Flexible(
                  child: Text(
                      'Información de la última sincronización: $messageStateSincronic',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87))),
              SizedBox(height: 30),
              button(),
              SizedBox(
                height: 30,
              ),
            ]),
      ),
    );
  }

  sincronizarData(BuildContext context, int cantidad) async {
    int cantidadData = 0;
    if (!sincroCompleta) {
      setState(() {
        messageStateSincronic = 'Recuperando datos';
      });
      listaMarcaciones.clear();
      loadDataSincronization();
      specialFilter();
      await Future.delayed(Duration(seconds: 3));
      sincroCompleta = true;
      sincronizarData(context, listaMarcaciones.length);
    } else {
      if (listaMarcaciones.length != 0 || listaEmpleados.length != 0) {
        try {
          for (var node in listaMarcaciones) {
            bool temp = await allservices.registrarMarcacion(node);
            if (temp) {
              RepositoryServicesLocal.generarIndicadorMarcadoIndividual(node);
              cantidadData++;
              setState(() {
                messageStateSincronic =
                    'Ya se subieron $cantidadData / $cantidad';
              });
            } else {
              sincroCompleta = false;
              listaNoRegistrados.add(node);
            }
          }
          for (var node in listaEmpleados) {
            bool temp = await allservices.registrarEmpleado(node);
            print(temp);
          }

          if (cantidadData == listaMarcaciones.length) {
            alerta.alertaConImagen(context, 'Exitó!',
                'La sincronización fue exitosa', 'assets/cloudSuccess.png');
            sincroCompleta = true;
            setState(() {
              imageStateSincronic = 'assets/cloudSuccess.png';
            });
          } else {
            sincroCompleta = false;
            alerta.alertaConImagen(
                context,
                'Oh no!',
                'Ocurrio un error, ${listaNoRegistrados.length} no subidos\nPor favor vuelva a ejecutar la sincronización',
                'assets/cloudError.png');
          }
        } catch (e) {
          sincroCompleta = false;
          alerta.alertaConImagen(
              context,
              'Oh no!',
              'Por favor vuelva a ejecutar la sincronización',
              'assets/cloudError.png');
          print(e);
          setState(() {
            imageStateSincronic = 'assets/cloudError.png';
          });
        }
      } else {
        setState(() {
          messageStateSincronic = 'No hay registros por actualizar';
        });
        alerta.alertaConImagen(context, 'Aviso!',
            'Ya toda la data esta sincronizada', 'assets/cloudSuccess.png');
      }
    }
  }

  Widget button() {
    if (state && _connectionStatus) {
      return OutlineButton.icon(
        color: Colors.green,
        onPressed: () {
          sincronizarData(context, listaMarcaciones.length);
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
    return Container(
      height: height,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
        ),
      ),
    );
  }

  descargarEmpleados() async {
    setState(() {
      stadoDescarga = 1;
    });
    try {
      List<DownloadEmployee> listaEmpleados =
          await allservices.descargarEmpleados();
      for (var i = 0; i < listaEmpleados.length; i++) {
        PerfilModel temp = PerfilModel();
        temp.empleadoDni = listaEmpleados[i].empleadoDni;
        temp.empleadoNombre = listaEmpleados[i].empleadoNombre;
        temp.empleadoApellido = listaEmpleados[i].empleadoApellido;
        temp.empleadoTelefono = listaEmpleados[i].empleadoTelefono;
        if (listaEmpleados[i].idEmpresa != null) {
          temp.idEmpresa = 1;
        } else {
          temp.idEmpresa = 0;
        }
        RepositoryServicesLocal.addEmpleado(temp);
      }
      setState(() {
        stadoDescarga = 2;
      });
    } catch (e) {
      setState(() {
        stadoDescarga = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sincronización',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                icon: Icon(listDescargaIcons[stadoDescarga]),
                onPressed: () => descargarEmpleados())
          ],
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
