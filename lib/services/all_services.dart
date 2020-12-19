import 'package:tablet_tower_flutter/models/EmpleadosDescarga.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllServices {
  Map<dynamic, dynamic> header = {};
  AllServices() {
    header = {"Content-Type": "application/json"};
  }
  Future<PerfilModel> encuentraTrabajador(String dni) async {
    final response = await http.get(
        'https://asistenciasendnotification.herokuapp.com/consulta/consultaTablet/$dni',
        headers: {"Content-Type": "application/json"});
    final List<dynamic> decodedData = json.decode(response.body);
    final List<PerfilModel> listModel = new List();
    if (decodedData == null) return null;

    decodedData.forEach((element) {
      final temp = PerfilModel.fromJson(element);
      listModel.add(temp);
    });
    if (listModel.length < 0) {
      listModel[0] = null;
    }

    return listModel[0];
  }

  Future<List<DownloadEmployee>> descargarEmpleados() async {
    final response = await http.get(
        'https://asistenciasendnotification.herokuapp.com/consulta/descargaEmpleados');
    final List<dynamic> decodedData = json.decode(response.body);
    final List<DownloadEmployee> listEmpleados = new List();
    if (decodedData == null || decodedData == []) {
      return [];
    } else {
      decodedData.forEach((element) {
        final temp = DownloadEmployee.fromJson(element);
        listEmpleados.add(temp);
      });
      return listEmpleados;
    }
  }

  Future<bool> registrarMarcacion(MarcationModel marcation) async {
    try {
      final urlTemp =
          'https://asistenciasendnotification.herokuapp.com/registro/registroMarcadoSpecial';
      final response = await http.post(urlTemp,
          body: marcationModelToJson(marcation),
          headers: {"Content-Type": "application/json"});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> registrarEmpleado(PerfilModel model) async {
    final urlTemp =
        'https://asistenciasendnotification.herokuapp.com/registro/registroTrabajador';
    final response = await http.post(urlTemp,
        body: perfilModelToJson(model),
        headers: {"Content-Type": "application/json"});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

final allservices = AllServices();
