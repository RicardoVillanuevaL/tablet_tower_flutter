import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/addEmployee.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';

class ListadoEmpleados extends StatefulWidget {
  ListadoEmpleados({Key key}) : super(key: key);

  @override
  _ListadoEmpleadosState createState() => _ListadoEmpleadosState();
}

class _ListadoEmpleadosState extends State<ListadoEmpleados> {
  List<PerfilModel> listPersonal;
  int state;

  String nombreCompleto(PerfilModel empleado) {
    String result;
    result = '${empleado.empleadoNombre} ${empleado.empleadoApellido}';
    return result;
  }

  String cadenaVisit(int number) {
      if (number == 2) {
        return 'TRABAJADOR';
      } else {
        return 'VISITANTE';
      }
  }

  bool checkVisit(int number) {
      if (number == 2) {
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
                    child: CustomDialog(
                      nombre: nombreCompleto(listPersonal[index]),
                      dni: listPersonal[index].empleadoDni,
                      tipo: checkVisit(listPersonal[index].idEmpresa),
                    )).then((value) => {
                      setState(() {
                        restardList();
                      })
                    });
              },
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(nombreCompleto(listPersonal[index])),
                subtitle: Text(listPersonal[index].empleadoDni),
                trailing: Text(cadenaVisit(listPersonal[index].idEmpresa)),
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
        appBar: AppBar(title: Text('Lista de Empleados')),
        body: Center(
          child: builListEmpleados(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddEmployee()))
                .then((value) {
              setState(() {
                restardList();
              });
            });
          },
        ));
  }
}

//POP UP DIALOG BOX BELOW
class CustomDialog extends StatefulWidget {
  final String nombre, dni;
  final bool tipo;
  CustomDialog({this.nombre, this.dni, this.tipo});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String texto;
  String dni;
  bool tipo;

  @override
  void initState() {
    texto = this.widget.nombre;
    dni = this.widget.dni;
    tipo = this.widget.tipo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: dialogContent(context));
  }

  listWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(texto,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Text(dni,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Switch(
              value: tipo,
              onChanged: (checked) {
                setState(() {
                  tipo = checked;
                });
              })
        ],
      ),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: 500,
              padding:
                  EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
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
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      textColor: Colors.blue,
                      onPressed: () async {
                        actualizarData();
                        Navigator.of(context).pop(tipo);
                      },
                      child: Text('Aceptar'),
                    ),
                  )
                ],
              )),
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
              ))
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

  actualizarData() async {
    int value = conversor(tipo);
    bool resutl = await RepositoryServicesLocal.actualizarTipodeUsuario(dni, value);
    print('$resutl $dni $tipo $value');
  }
}
