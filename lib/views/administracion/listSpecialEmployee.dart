import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:tablet_tower_flutter/views/administracion/detailEmployee.dart';

class ListSpecialEmployee extends StatefulWidget {
  @override
  _ListSpecialEmployeeState createState() => _ListSpecialEmployeeState();
}

class _ListSpecialEmployeeState extends State<ListSpecialEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Trabajadores por actualizar'),),
          body: FutureBuilder(
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
      ),
    );
  }
}
