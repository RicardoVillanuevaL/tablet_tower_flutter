import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tablet_tower_flutter/models/EmpleadosDescarga.dart';
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

  Future<bool> registrarMarcacion(
      MarcationModel marcation) async {
    final urlTemp =
        'https://asistenciasendnotification.herokuapp.com/registro/registroMarcado';
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
  }

  Future<bool> registrarNotification(
      NotificationModel model, String token) async {
    final urlTemp =
        'https://asistenciasendnotification.herokuapp.com/registro/registroNotificacion';
    final response = await http.post(urlTemp,
        body: notificationModelToJson(model),
        headers: {"Content-Type": "application/json", "authorization": token});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      return true;
    } else {
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

  Future<dynamic> sendEmail(String nameMessage, String emailMessage,
      String bodyMessage, File file) async {
    // final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final headers = {'Content-Type': 'multipart/form-data'};
    // final headers = {'Content-Type': 'multipart/form-data'};
    // final headers = {'Content-Type': 'application/json'};

    final fileBytes = file.readAsBytesSync();
    String file64 = base64Encode(fileBytes);
    var modelEmail = jsonEncode({
      "name": nameMessage,
      "email": emailMessage,
      "message": bodyMessage,
      "file": file64
    });
    final urlTemp = "https://serviciogenericos.herokuapp.com/send-email";
    final response = await http.post(urlTemp,
        body: modelEmail,
        headers: headers,
        encoding: Encoding.getByName('utf-8'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(response.reasonPhrase);
    print(response);
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> sendEmail2(String nameMessage, String emailMessage,
      String bodyMessage, File file) async {
    //  CON MULTIPART
    var url = Uri.parse('https://serviciogenericos.herokuapp.com/send-email');
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = nameMessage;
    request.fields['email'] = emailMessage;
    request.fields['message'] = bodyMessage;
    request.files
        .add(await http.MultipartFile.fromPath('Reporte Tablet', file.path));
    request.headers.addAll({'Content-Type': 'application/json'});

    var response = await request.send();
    print(response.reasonPhrase);
    print(response);
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<dynamic> sendEmail3(String nameMessage, String emailMessage,
      String bodyMessage, File file) async {
    //CON DIO
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "name": nameMessage,
      "email": emailMessage,
      "message": bodyMessage,
      "file": await http.MultipartFile.fromPath('Reporte Tablet', file.path)
    });

    Response response = await dio.post(
        'https://serviciogenericos.herokuapp.com/send-email',
        data: formData);
    print(response);
  }
}

final allservices = AllServices();
