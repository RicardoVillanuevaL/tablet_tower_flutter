import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/detailEmployee.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/reportePage.dart';
import 'package:tablet_tower_flutter/addEmployee.dart';
import 'package:tablet_tower_flutter/services/all_services.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as alerta;

class AdminEmpoyee extends StatefulWidget {
  @override
  _AdminEmpoyeeState createState() => _AdminEmpoyeeState();
}

class _AdminEmpoyeeState extends State<AdminEmpoyee> {
  int currentIndex = 0;
  List<Widget> vistas = List();
  List<String> titles = List();
  List<BottomNavigationBarItem> listBottom = List();
  List<FloatingActionButton> floatButton = List();

  cargarVistas() {
    floatButton.add(FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEmployee()))
              .then((value) {
            setState(() {});
          });
        }));
    floatButton.add(null);
    floatButton.add(null);
    floatButton.add(null);
    //AGREGAMOS LAS VISTAS
    vistas.add(ListEmpleadosGeneral());
    vistas.add(ListSpecialEmployee());
    vistas.add(SincronizacionPage());
    vistas.add(ReportePage());

    //AGREGAMOS LOS TITULOS
    titles.add('Lista de Empleados');
    titles.add('Lista de Trabajadores por actualizar');
    titles.add('Sincronización');
    titles.add('Generar Reportes');

    //AGREGAMOS LOS BNB
    listBottom.add(BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text("Lista Empleados"),
        backgroundColor: Colors.green));
    listBottom.add(BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        title: Text("Actualizar Empleados"),
        backgroundColor: Colors.green));
    listBottom.add(BottomNavigationBarItem(
        icon: Icon(Icons.cloud_upload),
        title: Text("Sincronización"),
        backgroundColor: Color(0xFF388E3C)));
    listBottom.add(BottomNavigationBarItem(
        icon: Icon(Icons.cloud_upload),
        title: Text("Reportes"),
        backgroundColor: Color(0xFF388E3C)));
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    cargarVistas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: Center(
        child: vistas[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: listBottom,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      floatingActionButton: floatButton[currentIndex],
    );
  }
}

class ListEmpleadosGeneral extends StatefulWidget {
  @override
  _ListEmpleadosGeneralState createState() => _ListEmpleadosGeneralState();
}

class _ListEmpleadosGeneralState extends State<ListEmpleadosGeneral> {
  String nombreCompleto(PerfilModel empleado) {
    String result;
    result = '${empleado.empleadoNombre} ${empleado.empleadoApellido}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: RepositoryServicesLocal.selectAllEmployee(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PerfilModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () => print(snapshot.data[index]),
                          leading: Icon(
                            Icons.person,
                            size: 28,
                          ),
                          title: Text(nombreCompleto(snapshot.data[index])),
                          subtitle: Text(snapshot.data[index].empleadoDni),
                        );
                      });
                } else {
                  return Text('NO HAY EMPLEADOS PARA ACTUALIZAR DATOS');
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class ListSpecialEmployee extends StatefulWidget {
  @override
  _ListSpecialEmployeeState createState() => _ListSpecialEmployeeState();
}

class _ListSpecialEmployeeState extends State<ListSpecialEmployee> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RepositoryServicesLocal.updatesEmployee(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PerfilModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailEmployee(snapshot.data[index]))),
                    leading: Icon(
                      Icons.person,
                      size: 28,
                    ),
                    title: Text(snapshot.data[index].empleadoDni),
                  );
                });
          } else {
            return Text('NO HAY EMPLEADOS PARA ACTUALIZAR DATOS');
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

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
    listaMarcaciones = List();
    listaNotificaciones = List();
    state = false;
    final df = new DateFormat('dd-MM-yyyy');
    diaActual = df.format(DateTime.now());
    loadDataSincronization();
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

  loadDataSincronization() async {
    try {
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
      imageStateSincronic = 'assets/cloudError.png';
      messageStateSincronic = 'Oh no!, Error al cargar los registros';
    }
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          Flexible(
              child: Text(
                  'Información de la última sincronización: $messageStateSincronic',
                  textAlign: TextAlign.center,
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
        allservices.registrarMarcacion(node, '77154956');
        cantidadData++;
        setState(() {
          messageStateSincronic = 'Ya se subieron $cantidadData / $cantidad';
        });
      }
      for (var node in listaNotificaciones) {
        allservices.registrarNotification(node, '77154956');
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
              context, listaMarcaciones.length + listaNotificaciones.length);
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
    return Container(
      padding: EdgeInsets.all(20),
      child: Table(
        children: <TableRow>[
          TableRow(children: [
            widgetInfo(screenHeight),
            wigdetStates(screenHeight),
          ])
        ],
      ),
    );
  }
}
