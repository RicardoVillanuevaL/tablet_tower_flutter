import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
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
        headers: {"Content-Type": "application/json", "Authorization": token});
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

  Future<dynamic> sendEmail(String nameMessage, String emailMessage,
      String bodyMessage, File file) async {
    final fileBytes = file.readAsBytesSync();
    String file64 = base64Encode(fileBytes);
    Map<String, dynamic> modelEmail = Map();
    modelEmail = {
      "name": nameMessage,
      "email": emailMessage,
      "message": bodyMessage,
      "file": file64
    };
    final urlTemp = "https://serviciogenericos.herokuapp.com/send-email";
    final response = await http.post(urlTemp, body: modelEmail);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  Future<int> sendEmail2(String nameMessage, String emailMessage,
      String bodyMessage, File file) async {
    //  CON MULTIPART
    var uri = Uri.parse('https://serviciogenericos.herokuapp.com/send-email');
    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = nameMessage
      ..fields['email'] = emailMessage
      ..fields['message'] = bodyMessage
      ..files
          .add(await http.MultipartFile.fromPath('Reporte Tablet', file.path,contentType: MediaType('file', 'csv')));

    var response = await request.send();
    print(response);
    if (response.statusCode == 200){
      return 1;
    }else{
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

    Response response = await dio.post('https://serviciogenericos.herokuapp.com/send-email',data: formData);
    print(response);
  }
}

final allservices = AllServices();
