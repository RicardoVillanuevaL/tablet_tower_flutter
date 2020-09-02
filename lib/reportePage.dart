import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tablet_tower_flutter/database/servicesLocal.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as alerta;

class ReportePage extends StatefulWidget {
  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  @override
  void initState() { 
    getPermission();
    super.initState();
  }

  getPermission() async {
    await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((status) {
      if (status == PermissionStatus.denied) {
        requestPermission();
      }
    });
  }

  requestPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  exportarData() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                child: RaisedButton(onPressed: () {exportarData();}),
              ),
            )
          ],
        ),
      ),
    );
  }
}
