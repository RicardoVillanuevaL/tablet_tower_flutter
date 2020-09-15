import 'dart:convert';
import 'package:tablet_tower_flutter/database/database.dart';

PerfilModel perfilModelFromJson(String str) =>
    PerfilModel.fromJson(json.decode(str));

String perfilModelToJson(PerfilModel data) => json.encode(data.toJson());

class PerfilModel {
  PerfilModel({
    this.empleadoDni, // local
    this.empleadoNombre,
    this.empleadoApellido,
    this.empleadoTelefono,
    this.empleadoFoto,
    this.empleadoToken,
    this.empleadoTokencelular,
    this.horaInicio,
    this.horaFin,
    //local
    this.empleadoEmail,
    this.empleadoContrasena,
    this.empleadoImei,
    this.empleadoUltimoIngreso,
    this.usuarioDniJefe,
    this.tipoIdCargo,
    this.idTurno,
    this.idArea,
    this.idEmpresa,
  });

  String empleadoDni;
  String empleadoNombre;
  String empleadoApellido;
  String empleadoTelefono;
  String empleadoFoto;
  String empleadoToken;
  String empleadoTokencelular;
  String horaInicio;
  String horaFin;
  String empleadoEmail;
  String empleadoContrasena;
  String empleadoImei;
  String empleadoUltimoIngreso;
  String usuarioDniJefe;
  int tipoIdCargo;
  int idTurno;
  int idArea;
  int idEmpresa;

  factory PerfilModel.fromJson(Map<String, dynamic> json) => PerfilModel(
        empleadoDni: json["empleado_dni"],
        empleadoNombre: json["empleado_nombre"],
        empleadoApellido: json["empleado_apellido"],
        empleadoTelefono: json["empleado_telefono"],
        empleadoEmail: json["empleado_email"],
        empleadoContrasena: json["empleado_contraseña"],
        empleadoImei: json["empleado_imei"],
        empleadoFoto: json["empleado_foto"],
        empleadoToken: json["empleado_token"],
        empleadoTokencelular: json["empleado_tokencelular"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        empleadoUltimoIngreso: json["empleado_ultimo_ingreso"],
        usuarioDniJefe: json["usuario_dni_jefe"],
        tipoIdCargo: json["tipo_id_cargo"],
        idTurno: json["id_turno"],
        idArea: json["id_area"],
        idEmpresa: json["id_empresa"],
      );

  Map<String, dynamic> toJson() => {
        "empleado_dni": empleadoDni,
        "empleado_nombre": empleadoNombre,
        "empleado_apellido": empleadoApellido,
        "empleado_telefono": empleadoTelefono,
        "empleado_foto": empleadoFoto,
        "empleado_token": empleadoToken,
        "empleado_tokencelular": empleadoTokencelular,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "empleado_email": empleadoEmail,
        "empleado_contraseña": empleadoContrasena,
        "empleado_imei": empleadoImei,
        "empleado_ultimo_ingreso": empleadoUltimoIngreso,
        "usuario_dni_jefe": usuarioDniJefe,
        "tipo_id_cargo": tipoIdCargo,
        "id_turno": idTurno,
        "id_area": idArea,
        "id_empresa": idEmpresa,
      };

  PerfilModel.fromJsonLocal(Map<String, dynamic> jsonLocal) {
    this.empleadoDni = jsonLocal[DatabaseCreator.empleado_dni];
    this.empleadoNombre = jsonLocal[DatabaseCreator.empleado_nombre];
    this.empleadoApellido = jsonLocal[DatabaseCreator.empleado_apellido];
    this.empleadoTelefono = jsonLocal[DatabaseCreator.empleado_telefono];
    this.empleadoFoto = jsonLocal[DatabaseCreator.empleado_foto];
    this.empleadoToken = jsonLocal[DatabaseCreator.empleado_token];
    this.empleadoTokencelular =
        jsonLocal[DatabaseCreator.empleado_tokencelular];
    this.empleadoEmail = jsonLocal[DatabaseCreator.empleado_email];
    this.empleadoContrasena = jsonLocal[DatabaseCreator.empleado_contrasena];
    this.empleadoImei = jsonLocal[DatabaseCreator.empleado_imei];
    this.empleadoUltimoIngreso =
        jsonLocal[DatabaseCreator.empleado_ultimo_ingreso];
    this.usuarioDniJefe = jsonLocal[DatabaseCreator.usuario_dni_jefe];
    this.tipoIdCargo = jsonLocal[DatabaseCreator.tipo_id_cargo];
    this.idTurno = jsonLocal[DatabaseCreator.id_turno];
    this.idArea = jsonLocal[DatabaseCreator.id_area];
    this.idEmpresa = convert(jsonLocal[DatabaseCreator.id_empresa]);
    this.horaInicio = jsonLocal[DatabaseCreator.hora_inicio];
    this.horaFin = jsonLocal[DatabaseCreator.hora_fin];
  }

  int convert(String data){
    int result;
    if(data==null){
      result = 0;
    }else{
      result = int.parse(data);
    }
    return result;
  }
}
