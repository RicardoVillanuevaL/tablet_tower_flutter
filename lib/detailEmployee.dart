import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';

class DetailEmployee extends StatefulWidget {
  final PerfilModel _model;

  DetailEmployee(this._model);
  @override
  _DetailEmployeeState createState() => _DetailEmployeeState();
}

class _DetailEmployeeState extends State<DetailEmployee> {
  int stateOperation;
  PerfilModel model;
  TextEditingController controllerNombre,
      controllerApellido,
      controllerTelefono;

  @override
  void initState() {
    model = widget._model;
    stateOperation = 0;
    controllerNombre = TextEditingController();
    controllerApellido = TextEditingController();
    controllerTelefono = TextEditingController();
    super.initState();
  }

  editData(String title, String edit, TextEditingController _controller,
      TextInputType typeInput) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              keyboardType: typeInput,
            ),
          )
        ],
      ),
    );
  }

  actualizarEmpleado() async {
    if (controllerNombre.text.trim().length > 0 &&
        controllerApellido.text.trim().length > 0 &&
        controllerTelefono.text.trim().length > 0) {
      model.empleadoNombre = controllerNombre.text;
      model.empleadoApellido = controllerApellido.text;
      model.empleadoTelefono = controllerTelefono.text;
      final result = await RepositoryServicesLocal.actualizarData(model);
      if (result) {
        stateOperation = 1;
        Navigator.of(context).pop();
      } else {
        stateOperation = 2;
        Navigator.of(context).pop();
      }
    } else {
      stateOperation = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Información'),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 100, right: 100),
          child: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'DNI:${model.empleadoDni}',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                editData('Nombre:', model.empleadoNombre, controllerNombre,
                    TextInputType.name),
                editData('Apellido:', model.empleadoApellido,
                    controllerApellido, TextInputType.name),
                editData('Telefono:', model.empleadoTelefono,
                    controllerTelefono, TextInputType.number),
                SizedBox(height: 20,),
                FloatingActionButton(
                  onPressed: () {
                    actualizarEmpleado();
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.check,
                    size: 40,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
