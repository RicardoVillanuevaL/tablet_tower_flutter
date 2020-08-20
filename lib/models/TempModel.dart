// To parse this JSON data, do
//
//     final modelTemp = modelTempFromJson(jsonString);

import 'dart:convert';

Map<String, ModelTemp> modelTempFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, ModelTemp>(k, ModelTemp.fromJson(v)));

String modelTempToJson(Map<String, ModelTemp> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class ModelTemp {
    ModelTemp({
        this.empleadoDni,
        this.empleadoNombre,
        this.empleadoApellido,
        this.empleadoTelefono,
        this.empleadoEmail,
        this.empleadoContrasea,
        this.empleadoImei,
        this.empleadoToken,
        this.empleadoFoto,
        this.empleadoUltimoIngreso,
        this.empleadoTokencelular,
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
    String empleadoEmail;
    String empleadoContrasea;
    dynamic empleadoImei;
    String empleadoToken;
    String empleadoFoto;
    String empleadoUltimoIngreso;
    String empleadoTokencelular;
    String usuarioDniJefe;
    int tipoIdCargo;
    int idTurno;
    int idArea;
    String idEmpresa;

    factory ModelTemp.fromJson(Map<String, dynamic> json) => ModelTemp(
        empleadoDni: json["empleado_dni"],
        empleadoNombre: json["empleado_nombre"],
        empleadoApellido: json["empleado_apellido"],
        empleadoTelefono: json["empleado_telefono"],
        empleadoEmail: json["empleado_email"],
        empleadoContrasea: json["empleado_contraseña"],
        empleadoImei: json["empleado_imei"],
        empleadoToken: json["empleado_token"] == null ? null : json["empleado_token"],
        empleadoFoto: json["empleado_foto"] == null ? null : json["empleado_foto"],
        empleadoUltimoIngreso: json["empleado_ultimo_ingreso"],
        empleadoTokencelular: json["empleado_tokencelular"] == null ? null : json["empleado_tokencelular"],
        usuarioDniJefe: json["usuario_dni_jefe"] == null ? null : json["usuario_dni_jefe"],
        tipoIdCargo: json["tipo_id_cargo"],
        idTurno: json["id_turno"],
        idArea: json["id_area"] == null ? null : json["id_area"],
        idEmpresa: json["id_empresa"],
    );

    Map<String, dynamic> toJson() => {
        "empleado_dni": empleadoDni,
        "empleado_nombre": empleadoNombre,
        "empleado_apellido": empleadoApellido,
        "empleado_telefono": empleadoTelefono,
        "empleado_email": empleadoEmail,
        "empleado_contraseña": empleadoContrasea,
        "empleado_imei": empleadoImei,
        "empleado_token": empleadoToken == null ? null : empleadoToken,
        "empleado_foto": empleadoFoto == null ? null : empleadoFoto,
        "empleado_ultimo_ingreso": empleadoUltimoIngreso,
        "empleado_tokencelular": empleadoTokencelular == null ? null : empleadoTokencelular,
        "usuario_dni_jefe": usuarioDniJefe == null ? null : usuarioDniJefe,
        "tipo_id_cargo": tipoIdCargo,
        "id_turno": idTurno,
        "id_area": idArea == null ? null : idArea,
        "id_empresa": idEmpresa,
    };
}
