import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/detailEmployee.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/services/addEmployee.dart';

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
              .push(MaterialPageRoute(builder: (context) => AddEmployee()));
        }));
    floatButton.add(null);
    floatButton.add(null);
    //AGREGAMOS LAS VISTAS
    vistas.add(ListEmpleadosGeneral());
    vistas.add(ListSpecialEmployee());
    vistas.add(SincronizacionPage());

    //AGREGAMOS LOS TITULOS
    titles.add('Lista de Empleados');
    titles.add('Lista de Trabajadores por actualizar');
    titles.add('Sincronización');

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
  String stateConnection;
  String stateSincronic;

  @override
  void initState() {
    stateConnection = 'assets/connectionSuccess.png';
    stateSincronic = 'assets/uploadData.png';
    super.initState();
  }

  widgetInfo(double height) {
    return Column(
      children: [
        
      ]
    );
  }

  wigdetStates(double height) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage(stateConnection),
            height: 100,
          ), //IMAGEN DE ESTADO DE CONEXION
          SizedBox(height: 30,),
          Image(
            image: AssetImage(stateSincronic),
            height: 100,
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
