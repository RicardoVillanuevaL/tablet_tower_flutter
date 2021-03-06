import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as util;
import 'package:tablet_tower_flutter/views/administracion/addEmployee.dart';

class ListadoEmpleados extends StatefulWidget {
  ListadoEmpleados({Key key}) : super(key: key);

  @override
  _ListadoEmpleadosState createState() => _ListadoEmpleadosState();
}

class _ListadoEmpleadosState extends State<ListadoEmpleados> {
  List<PerfilModel> listPersonal;
  List<PerfilModel> listaCorregir;
  int state;

  String nombreCompleto(PerfilModel empleado) {
    String result;
    result = '${empleado.empleadoNombre} ${empleado.empleadoApellido}';
    return result;
  }

  String cadenaVisit(int number) {
    if (number == 1) {
      return 'TRABAJADOR';
    } else {
      return 'VISITANTE';
    }
  }

  bool checkVisit(int number) {
    if (number == 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    state = 0;
    super.initState();
    leerData();
  }

  leerData() async {
    listPersonal = await RepositoryServicesLocal.selectAllEmployee();
    listaCorregir = await RepositoryServicesLocal.updatesEmployee();
    if (listPersonal != null) {
      setState(() {
        state = 1;
      });
    } else {
      setState(() {
        state = 2;
      });
    }
  }

  restardList() async {
    state = 0;
    listPersonal = null;
    leerData();
  }

  bool marca(String dni) {
    bool result;
    try {
      if (listaCorregir.length != 0) {
        for (var i = 0; i < listaCorregir.length; i++) {
          if (listaCorregir[i].empleadoDni == dni) {
            result = true;
          } else {
            result = false;
          }
        }
      } else {
        result = false;
      }
    } catch (e) {
      result = false;
    }
    return result;
  }

  builListEmpleados() {
    if (state == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state == 1) {
      return ListView.builder(
        itemCount: listPersonal.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: CustomDialog(
                      nombre: listPersonal[index].empleadoNombre,
                      apellido: listPersonal[index].empleadoApellido,
                      dni: listPersonal[index].empleadoDni,
                      ruta: true,
                      tipo: checkVisit(listPersonal[index].idEmpresa),
                      telefono: listPersonal[index].empleadoTelefono,
                    )).then((value) => {
                      setState(() {
                        restardList();
                      })
                    });
              },
              child: Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(
                    marca(listPersonal[index].empleadoDni)
                        ? Icons.cancel
                        : Icons.check_circle,
                    color: marca(listPersonal[index].empleadoDni)
                        ? Colors.red
                        : Colors.green,
                  ),
                  title: Text(nombreCompleto(listPersonal[index])),
                  subtitle: Text(listPersonal[index].empleadoDni),
                  trailing: Text(cadenaVisit(listPersonal[index].idEmpresa)),
                ),
              ));
        },
      );
    } else if (state == 2) {
      return Text('NO EXISTE DATOS REGISTRADOS',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Empleados',
              style: TextStyle(fontSize: 26, color: Colors.white)),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: EmpleadosSearch(),
                  ).then((value) => setState(() {
                        restardList();
                      }));
                })
          ],
        ),
        body: Center(
          child: builListEmpleados(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 35,
          ),
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddEmployee()))
                .then((value) async {
              print(value);
              if (value) {
                util.alertWaitDialog(
                    context,
                    'Exito!',
                    'El usuario se actualizó correctamente',
                    'assets/connectionSuccess.png');
                await Future.delayed(Duration(seconds: 2));
                Navigator.pop(context);
              } else {
                util.alertaRegistroMarcacion(
                    context, 'Oh no', 'Algo falló, intentelo más tarde');
              }
              setState(() {
                restardList();
              });
            });
          },
        ));
  }
}

class EmpleadosSearch extends SearchDelegate<PerfilModel> {
  List<PerfilModel> list = List();

  void cargarLista() async {
    list = await RepositoryServicesLocal.selectAllEmployee();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  bool checkVisit(int number) {
    if (number == 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    cargarLista();
    list = query.isEmpty
        ? list
        : list
            .where((element) => element.empleadoDni.startsWith(query))
            .toList();
    return list.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'No hay resultados . . .\nRecuerde que la búsqueda es con el DNI',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final PerfilModel model = list[index];
              return ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: CustomDialog(
                        nombre: model.empleadoNombre,
                        apellido: model.empleadoApellido,
                        dni: model.empleadoDni,
                        tipo: checkVisit(model.idEmpresa),
                        telefono: model.empleadoTelefono,
                        ruta: false,
                      )).then((value) => cargarLista());
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.empleadoNombre} ${model.empleadoApellido}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${model.empleadoDni}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Divider()
                  ],
                ),
              );
            });
  }
}

//POP UP DIALOG BOX BELOW
class CustomDialog extends StatefulWidget {
  final String nombre, apellido, dni, telefono;
  final bool tipo, ruta;
  CustomDialog(
      {this.nombre,
      this.apellido,
      this.dni,
      this.tipo,
      this.telefono,
      this.ruta});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String texto;
  String dni;
  bool tipo, ruta;
  String nombre, apellido, telefono = '';

  @override
  void initState() {
    texto = this.widget.nombre;
    dni = this.widget.dni;
    tipo = this.widget.tipo;
    nombre = this.widget.nombre;
    apellido = this.widget.apellido;
    telefono = this.widget.telefono;
    ruta = this.ruta;
    super.initState();
  }

  Future<bool> onBackPressed() {
    if (ruta) {
      // SI VIENE
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListadoEmpleados()),
      );
    } else {
      Navigator.pop(context);
    }

    return null;
  }

  String cadenaVisit(bool tipo) {
    if (tipo) {
      return 'TRABAJADOR';
    } else {
      return 'VISITANTE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          backgroundColor: Colors.transparent,
          child: dialogContent(context)),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: 500,
            padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Información de $texto',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(dni,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tipo de usuario: '),
                      Switch(
                          value: tipo,
                          onChanged: (checked) {
                            setState(() {
                              tipo = checked;
                            });
                          }),
                      Text('${cadenaVisit(tipo)}')
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: new TextEditingController()
                      ..text = '${this.widget.nombre}',
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    style: TextStyle(fontSize: 24),
                    onChanged: (value) => nombre = value,
                    decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(fontSize: 22)),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: new TextEditingController()
                      ..text = '${this.widget.apellido}',
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    onChanged: (value) => apellido = value,
                    decoration: InputDecoration(
                        labelText: 'Apellido',
                        labelStyle: TextStyle(fontSize: 22)),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: new TextEditingController()
                      ..text = '${this.widget.telefono}',
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    onChanged: (value) => telefono = value,
                    decoration: InputDecoration(
                        labelText: 'Telefono',
                        labelStyle: TextStyle(fontSize: 22)),
                  ),
                  SizedBox(height: 24.0),
                  SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      textColor: Colors.blue,
                      onPressed: () async {
                        if (nombre.trim().isNotEmpty &&
                            apellido.trim().isNotEmpty) {
                          PerfilModel model = PerfilModel(
                              empleadoNombre: nombre,
                              empleadoApellido: apellido,
                              empleadoDni: dni,
                              empleadoTelefono:
                                  telefono.isEmpty ? '99999' : telefono);
                          bool result = await actualizarData(model);
                          Navigator.of(context).pop(result);
                        }
                      },
                      child: Text('Aceptar'),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 50,
              child: Container(
                child: Image.asset('assets/attendance.png'),
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 0,
              child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ],
      ),
    );
  }

  int conversor(bool value) {
    if (value) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<bool> actualizarData(PerfilModel model) async {
    int value = conversor(tipo);
    bool resutl =
        await RepositoryServicesLocal.actualizarTipodeUsuario(dni, value);
    bool result2 = await RepositoryServicesLocal.actualizarData(model);
    if (resutl && result2) {
      return true;
    } else {
      return false;
    }
  }
}
