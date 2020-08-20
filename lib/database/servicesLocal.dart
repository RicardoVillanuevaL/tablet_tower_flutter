import 'package:tablet_tower_flutter/database/database.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:tablet_tower_flutter/models/TempModel.dart';

class RepositoryServicesLocal {
  static Future<PerfilModel> consultarEmpleado(String dni) async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableEmpleado}
              WHERE ${DatabaseCreator.empleado_dni} = ? ''';
    List<dynamic> params = [dni];
    final data = await db.rawQuery(query, params);
    final perfil = PerfilModel.fromJsonLocal(data.first);
    return perfil;
  }

  static Future<PerfilModel> consultarEmpleadoJson(String dni) async {
    PerfilModel empleado = PerfilModel();
    final resp = await rootBundle.loadString('assets/empleado.json');
    Map<String, ModelTemp> dataMap = modelTempFromJson(resp);
    ModelTemp temp  = dataMap[dni];
    empleado.empleadoDni = temp.empleadoDni;
    empleado.empleadoNombre = temp.empleadoNombre;
    empleado.empleadoApellido = temp.empleadoApellido;
    empleado.empleadoEmail = temp.empleadoEmail;
    empleado.empleadoFoto = null;
    empleado.empleadoImei = null;
    empleado.empleadoTelefono = temp.empleadoTelefono;
    empleado.empleadoTokencelular = null;
    empleado.empleadoUltimoIngreso = null;
    empleado.idArea = null;
    empleado.usuarioDniJefe = null;
    empleado.empleadoContrasena = null;
    empleado.idEmpresa = null;
    empleado.idTurno = null;
    empleado.horaInicio='12:00:00';
    empleado.horaFin ='15:00:00';

    print(empleado);
    return empleado;
  }

  static Future<void> addEmpleado(PerfilModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableEmpleado} (
      ${DatabaseCreator.empleado_dni},
      ${DatabaseCreator.empleado_nombre},
      ${DatabaseCreator.empleado_apellido},
      ${DatabaseCreator.empleado_telefono},
      ${DatabaseCreator.hora_inicio},
      ${DatabaseCreator.hora_fin}
      ) VALUES (?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.empleadoDni,
      model.empleadoNombre,
      model.empleadoApellido,
      model.empleadoTelefono,
      model.horaInicio,
      model.horaFin
    ];
    try {
      final result = await db.rawInsert(query, params);
      DatabaseCreator.databaseLog('Add Empleado', query, null, result, params);
    } catch (e) { print(e);}
  }

  static Future<void> addMarcado(MarcationModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableMarcado} (
      ${DatabaseCreator.marcado_id_telefono},
      ${DatabaseCreator.marcado_dni},
      ${DatabaseCreator.marcado_latitud},
      ${DatabaseCreator.marcado_longitud},
      ${DatabaseCreator.marcado_dataQR},
      ${DatabaseCreator.marcado_fecha_hora},
      ${DatabaseCreator.marcado_tipo},
      ${DatabaseCreator.marcado_motivo},
      ${DatabaseCreator.marcado_temperatura},
      ${DatabaseCreator.marcado_tiempo}
    ) VALUES (?,?,?,?,?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.marcadoIdTelefono,
      model.marcadoDni,
      model.marcadoLatitud,
      model.marcadoLongitud,
      model.marcadoDataQr,
      model.marcadoFechaHora,
      model.marcadoTipo,
      model.marcadoMotivo,
      model.marcadoTemperatura,
      model.marcadoTiempo
    ];
    final result = await db.rawInsert(query, params);
    DatabaseCreator.databaseLog('Add Marcado', query, null, result, params);
  }

  static Future<void> addNotificacion(NotificationModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableNotificacion} (
      ${DatabaseCreator.dni_user_notification},
      ${DatabaseCreator.fecha_notification},
      ${DatabaseCreator.latitud_notification},
      ${DatabaseCreator.longtitud_notification},
      ${DatabaseCreator.titulo_notification},
      ${DatabaseCreator.cuerpo_notification}
    ) VALUES (?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.idTelefono,
      model.fechahora,
      model.latitud,
      model.longitud,
      model.titulo,
      model.cuerpo
    ];
    final result = await db.rawInsert(query, params);
    DatabaseCreator.databaseLog(
        'Add Notificacion', query, null, result, params);
  }
}

final localServices = RepositoryServicesLocal();
