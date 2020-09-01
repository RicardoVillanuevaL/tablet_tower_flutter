import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  PerfilModel model = PerfilModel();
  TextEditingController controllerDNI,
      controllerNombre,
      controllerApellido,
      controllerTelefono;

  @override
  void initState() {
    super.initState();
    controllerDNI = TextEditingController();
    controllerNombre = TextEditingController();
    controllerApellido = TextEditingController();
    controllerTelefono = TextEditingController();
  }

  boxForm(String title, String edit, TextEditingController _controller,
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

  registrarEmpleado() {
    if (controllerDNI.text.trim().length > 0 &&
        controllerNombre.text.trim().length > 0 &&
        controllerApellido.text.trim().length > 0 &&
        controllerTelefono.text.trim().length > 0) {
      model.empleadoDni = controllerDNI.text;
      model.empleadoNombre = controllerNombre.text;
      model.empleadoApellido = controllerApellido.text;
      model.empleadoTelefono = controllerTelefono.text;
      model.horaInicio = '10:00:00';
      model.horaFin = '23:00:00';
      RepositoryServicesLocal.addEmpleado(model);
      Navigator.of(context).pop();
    } else {
      //NO SE PUEDE REGISTRAR DATOS EN BLANCO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Empleado')),
      body: Padding(
        padding: EdgeInsets.only(left: 100, right: 100),
        child: Container(
          child: ListView(
            children: [
              boxForm('DNI:', model.empleadoDni, controllerDNI,
                  TextInputType.number),
              boxForm('NOMBRE:', model.empleadoNombre, controllerNombre,
                  TextInputType.name),
              boxForm('APELLIDO:', model.empleadoApellido, controllerApellido,
                  TextInputType.name),
              boxForm('TELEFONO:', model.empleadoTelefono, controllerTelefono,
                  TextInputType.number),
              FloatingActionButton(onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
