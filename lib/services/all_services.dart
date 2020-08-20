import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
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

  Future<MarcationModel> registrarMarcacion(
      MarcationModel marcation, String token) async {
    final urlTemp =
        'https://asistenciasendnotification.herokuapp.com/registro/registroMarcado';
    final response = await http.post(urlTemp,
        body: marcationModelToJson(marcation),
        headers: {"Content-Type": "application/json", "authorization": token});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return marcation;
  }

  Future<NotificationModel> registrarNotification(
      NotificationModel model, String token) async {
    final urlTemp =
        'https://asistenciasendnotification.herokuapp.com/registro/registroNotificacion';
    final response = await http.post(urlTemp,
        body: notificationModelToJson(model),
        headers: {"Content-Type": "application/json", "authorization": token});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return model;
  }
}

final allservices = AllServices();
