// To parse this JSON data, do
//
//     final reporteModel = reporteModelFromJson(jsonString);

import 'dart:convert';

import 'package:tablet_tower_flutter/database/database.dart';

List<ReporteModel> reporteModelFromJson(String str) => List<ReporteModel>.from(
    json.decode(str).map((x) => ReporteModel.fromJson(x)));

String reporteModelToJson(List<ReporteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReporteModel {
  ReporteModel({
    this.marcadoDni,
    this.empleadoNombre,
    this.empleadoApellido,
    this.marcadoFechaHora,
    this.marcadoTiempo,
    this.marcadoLatitud,
    this.marcadoLongitud,
    this.marcadoTipo,
    this.marcadoTemperatura,
  });

  String marcadoDni;
  String empleadoNombre;
  String empleadoApellido;
  String marcadoFechaHora;
  String marcadoTiempo;
  String marcadoLatitud;
  String marcadoLongitud;
  String marcadoTipo;
  int marcadoTemperatura;

  factory ReporteModel.fromJson(Map<String, dynamic> json) => ReporteModel(
        marcadoDni: json["marcado_dni"],
        empleadoNombre: json["empleado_nombre"],
        empleadoApellido: json["empleado_apellido"],
        marcadoFechaHora: json["marcado_fecha_hora"],
        marcadoTiempo: json["marcado_tiempo"],
        marcadoLatitud: json["marcado_latitud"],
        marcadoLongitud: json["marcado_longitud"],
        marcadoTipo: json["marcado_tipo"],
        marcadoTemperatura: json["marcado_temperatura"],
      );

  Map<String, dynamic> toJson() => {
        "marcado_dni": marcadoDni,
        "empleado_nombre": empleadoNombre,
        "empleado_apellido": empleadoApellido,
        "marcado_fecha_hora": marcadoFechaHora,
        "marcado_tiempo": marcadoTiempo,
        "marcado_latitud": marcadoLatitud,
        "marcado_longitud": marcadoLongitud,
        "marcado_tipo": marcadoTipo,
        "marcado_temperatura": marcadoTemperatura,
      };

  ReporteModel.fromJsonLocal(Map<String, dynamic> jsonLocal) {
    this.marcadoDni = jsonLocal[DatabaseCreator.marcado_dni];
    this.empleadoNombre = jsonLocal[DatabaseCreator.empleado_nombre];
    this.empleadoApellido = jsonLocal[DatabaseCreator.empleado_apellido];
    this.marcadoFechaHora = jsonLocal[DatabaseCreator.marcado_fecha_hora];
    this.marcadoTiempo = jsonLocal[DatabaseCreator.marcado_tiempo];
    this.marcadoLatitud = jsonLocal[DatabaseCreator.marcado_latitud];
    this.marcadoLongitud = jsonLocal[DatabaseCreator.marcado_longitud];
    this.marcadoTipo = jsonLocal[DatabaseCreator.marcado_tipo];
    this.marcadoTemperatura = jsonLocal[DatabaseCreator.marcado_temperatura];
  }
}
